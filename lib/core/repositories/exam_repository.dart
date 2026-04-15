import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/exam.dart';
import '../services/connectivity_service.dart';

class ExamRepository {
  static const _boxName = 'exams';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivity;

  ExamRepository(this._connectivity);

  Box<Exam> get _box => Hive.box<Exam>(_boxName);

  CollectionReference get _collection => _firestore.collection('exams');

  static Future<void> init() async {
    await Hive.openBox<Exam>(_boxName);
  }

  // ── OFFLINE-FIRST: Read from Hive ──────────────────────────────

  List<Exam> getExams(String userId) {
    return _box.values.where((e) => e.userId == userId && !e.deleted).toList()
      ..sort((a, b) => a.examDate.compareTo(b.examDate));
  }

  Exam? getExamById(String id) {
    try {
      return _box.values.firstWhere((e) => e.id == id && !e.deleted);
    } catch (_) {
      return null;
    }
  }

  // ── ADD ────────────────────────────────────────────────────────

  Future<Exam> addExam(Exam exam) async {
    // 1. Save locally first (always works)
    await _box.put(exam.id, exam);

    // 2. Try to sync to Firestore
    if (await _connectivity.checkConnectivity()) {
      try {
        await _collection.doc(exam.id).set(exam.toFirestore());
        final synced = exam.copyWith(synced: true);
        await _box.put(exam.id, synced);
        debugPrint(
          'ExamRepository.addExam synced to Firestore (project=${Firebase.app().options.projectId}, examId=${exam.id}, userId=${exam.userId})',
        );
        return synced;
      } on FirebaseException catch (e) {
        debugPrint('ExamRepository.addExam Firestore error: ${e.code} ${e.message}');
      }
    }
    return exam;
  }

  // ── UPDATE ─────────────────────────────────────────────────────

  Future<Exam> updateExam(Exam exam) async {
    final updated = exam.copyWith(synced: false);
    await _box.put(exam.id, updated);

    if (await _connectivity.checkConnectivity()) {
      try {
        await _collection.doc(exam.id).update(exam.toFirestore());
        final synced = exam.copyWith(synced: true);
        await _box.put(exam.id, synced);
        debugPrint(
          'ExamRepository.updateExam synced to Firestore (project=${Firebase.app().options.projectId}, examId=${exam.id}, userId=${exam.userId})',
        );
        return synced;
      } on FirebaseException catch (e) {
        debugPrint('ExamRepository.updateExam Firestore error: ${e.code} ${e.message}');
      }
    }
    return updated;
  }

  // ── DELETE ─────────────────────────────────────────────────────

  Future<void> deleteExam(String id) async {
    final exam = getExamById(id);
    if (exam == null) return;

    // Mark as deleted locally
    final deleted = exam.copyWith(deleted: true, synced: false);
    await _box.put(id, deleted);

    if (await _connectivity.checkConnectivity()) {
      try {
        await _collection.doc(id).delete();
        await _box.delete(id);
      } on FirebaseException catch (e) {
        debugPrint('ExamRepository.deleteExam Firestore error: ${e.code} ${e.message}');
      }
    }
  }

  // ── SYNC: Push unsynced local data → Firestore ────────────────

  Future<void> syncToFirestore() async {
    if (!await _connectivity.checkConnectivity()) return;

    final unsynced = _box.values.where((e) => !e.synced).toList();
    for (final exam in unsynced) {
      try {
        if (exam.deleted) {
          await _collection.doc(exam.id).delete();
          await _box.delete(exam.id);
          debugPrint(
            'ExamRepository.syncToFirestore deleted exam (project=${Firebase.app().options.projectId}, examId=${exam.id}, userId=${exam.userId})',
          );
        } else {
          await _collection.doc(exam.id).set(exam.toFirestore());
          await _box.put(exam.id, exam.copyWith(synced: true));
          debugPrint(
            'ExamRepository.syncToFirestore uploaded exam (project=${Firebase.app().options.projectId}, examId=${exam.id}, userId=${exam.userId})',
          );
        }
      } on FirebaseException catch (e) {
        debugPrint('ExamRepository.syncToFirestore Firestore error (${exam.id}): ${e.code} ${e.message}');
        // Continue with other items
      }
    }
  }

  // ── SYNC: Pull Firestore data → Hive ──────────────────────────

  Future<void> syncFromFirestore(String userId) async {
    if (!await _connectivity.checkConnectivity()) return;

    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .get();
      debugPrint(
        'ExamRepository.syncFromFirestore fetched ${snapshot.docs.length} exams (project=${Firebase.app().options.projectId}, userId=$userId)',
      );

      for (final doc in snapshot.docs) {
        final exam = Exam.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
        // Only overwrite if not locally modified
        final local = getExamById(exam.id);
        if (local == null || local.synced) {
          await _box.put(exam.id, exam);
        }
      }
    } on FirebaseException catch (e) {
      debugPrint('ExamRepository.syncFromFirestore Firestore error: ${e.code} ${e.message}');
      // Offline or error — use cached data
    }
  }

  // ── Full bidirectional sync ────────────────────────────────────

  Future<void> fullSync(String userId) async {
    await syncToFirestore();
    await syncFromFirestore(userId);
  }
}
