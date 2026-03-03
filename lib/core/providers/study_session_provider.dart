import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/exam.dart';
import '../models/study_session.dart';
import '../repositories/study_session_repository.dart';
import '../services/connectivity_service.dart';

class StudySessionProvider extends ChangeNotifier {
  final StudySessionRepository _repository;
  final ConnectivityService _connectivity;

  List<StudySession> _sessions = [];
  bool _isLoading = false;

  StudySessionProvider(this._repository, this._connectivity) {
    _connectivity.addListener(_onConnectivityChanged);
  }

  List<StudySession> get sessions => _sessions;
  bool get isLoading => _isLoading;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // ── Computed stats ─────────────────────────────────────────────

  Duration get totalStudyTime {
    final totalSeconds = _sessions.fold<int>(
      0,
      (sum, s) => sum + s.durationInSeconds,
    );
    return Duration(seconds: totalSeconds);
  }

  Duration get todayStudyTime {
    if (_userId == null) return Duration.zero;
    return _repository.getTodayStudyTime(_userId!);
  }

  int get todaySessionCount {
    if (_userId == null) return 0;
    return _repository.getTodaySessions(_userId!).length;
  }

  String get formattedTodayTime {
    final d = todayStudyTime;
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  // ── Study time per exam (matched by topic names) ──────────────

  /// Returns the total seconds studied for a specific exam,
  /// by checking if session topics overlap with the exam's topics.
  int getStudySecondsForExam(Exam exam) {
    int total = 0;
    for (final session in _sessions) {
      final hasOverlap = session.topics.any(
        (topic) => exam.topics.contains(topic),
      );
      if (hasOverlap) {
        total += session.durationInSeconds;
      }
    }
    return total;
  }

  /// Returns progress (0.0 to 1.0) for an exam based on
  /// actual study time vs targetStudyHours.
  /// TODO: Remove the 100x multiplier after testing!
  double getProgressForExam(Exam exam) {
    if (exam.targetStudyHours <= 0) return 0.0;
    final studiedSeconds = getStudySecondsForExam(exam);
    final targetSeconds = (exam.targetStudyHours * 3600).toInt();
    final progress =
        (studiedSeconds * 100) / targetSeconds; // 100x speed for testing
    return progress.clamp(0.0, 1.0);
  }

  // ── Load sessions (offline-first) ─────────────────────────────

  Future<void> loadSessions() async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // 1. Load from Hive immediately
      _sessions = _repository.getSessions(_userId!);
      notifyListeners();

      // 2. Sync with Firestore in background
      await _repository.fullSync(_userId!);

      // 3. Reload from Hive after sync
      _sessions = _repository.getSessions(_userId!);
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Save a completed session ───────────────────────────────────

  Future<void> saveSession({
    required List<String> topics,
    required int durationInSeconds,
  }) async {
    if (_userId == null) return;

    final session = StudySession(
      id: const Uuid().v4(),
      startTime: DateTime.now().subtract(Duration(seconds: durationInSeconds)),
      endTime: DateTime.now(),
      topics: topics,
      durationInSeconds: durationInSeconds,
      userId: _userId!,
    );

    await _repository.addSession(session);
    _sessions = _repository.getSessions(_userId!);
    notifyListeners();
  }

  // ── Connectivity change → auto-sync ────────────────────────────

  void _onConnectivityChanged() {
    if (_connectivity.isOnline && _userId != null) {
      _repository.fullSync(_userId!).then((_) {
        _sessions = _repository.getSessions(_userId!);
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _connectivity.removeListener(_onConnectivityChanged);
    super.dispose();
  }
}
