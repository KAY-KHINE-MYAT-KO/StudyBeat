import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/study_session.dart';
import '../services/connectivity_service.dart';

class StudySessionRepository {
  static const _boxName = 'study_sessions';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivity;

  StudySessionRepository(this._connectivity);

  Box<StudySession> get _box => Hive.box<StudySession>(_boxName);

  CollectionReference get _collection =>
      _firestore.collection('study_sessions');

  static Future<void> init() async {
    await Hive.openBox<StudySession>(_boxName);
  }

  // ── OFFLINE-FIRST: Read from Hive ──────────────────────────────

  List<StudySession> getSessions(String userId) {
    return _box.values.where((s) => s.userId == userId).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  List<StudySession> getTodaySessions(String userId) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return getSessions(
      userId,
    ).where((s) => s.startTime.isAfter(todayStart)).toList();
  }

  Duration getTotalStudyTime(String userId) {
    final sessions = getSessions(userId);
    final totalSeconds = sessions.fold<int>(
      0,
      (sum, s) => sum + s.durationInSeconds,
    );
    return Duration(seconds: totalSeconds);
  }

  Duration getTodayStudyTime(String userId) {
    final sessions = getTodaySessions(userId);
    final totalSeconds = sessions.fold<int>(
      0,
      (sum, s) => sum + s.durationInSeconds,
    );
    return Duration(seconds: totalSeconds);
  }

  // ── ADD ────────────────────────────────────────────────────────

  Future<StudySession> addSession(StudySession session) async {
    await _box.put(session.id, session);

    if (await _connectivity.checkConnectivity()) {
      try {
        await _collection.doc(session.id).set(session.toFirestore());
        final synced = session.copyWith(synced: true);
        await _box.put(session.id, synced);
        return synced;
      } catch (_) {}
    }
    return session;
  }

  // ── UPDATE ─────────────────────────────────────────────────────

  Future<StudySession> updateSession(StudySession session) async {
    final updated = session.copyWith(synced: false);
    await _box.put(session.id, updated);

    if (await _connectivity.checkConnectivity()) {
      try {
        await _collection.doc(session.id).update(session.toFirestore());
        final synced = session.copyWith(synced: true);
        await _box.put(session.id, synced);
        return synced;
      } catch (_) {}
    }
    return updated;
  }

  // ── SYNC ───────────────────────────────────────────────────────

  Future<void> syncToFirestore() async {
    if (!await _connectivity.checkConnectivity()) return;

    final unsynced = _box.values.where((s) => !s.synced).toList();
    for (final session in unsynced) {
      try {
        await _collection.doc(session.id).set(session.toFirestore());
        await _box.put(session.id, session.copyWith(synced: true));
      } catch (_) {}
    }
  }

  Future<void> syncFromFirestore(String userId) async {
    if (!await _connectivity.checkConnectivity()) return;

    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in snapshot.docs) {
        final session = StudySession.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
        final local = _box.get(session.id);
        if (local == null || local.synced) {
          await _box.put(session.id, session);
        }
      }
    } catch (_) {}
  }

  Future<void> fullSync(String userId) async {
    await syncToFirestore();
    await syncFromFirestore(userId);
  }
}
