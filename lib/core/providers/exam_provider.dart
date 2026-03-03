import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/exam.dart';
import '../repositories/exam_repository.dart';
import '../services/connectivity_service.dart';

class ExamProvider extends ChangeNotifier {
  final ExamRepository _repository;
  final ConnectivityService _connectivity;

  List<Exam> _exams = [];
  bool _isLoading = false;
  String? _error;

  ExamProvider(this._repository, this._connectivity) {
    // Listen for connectivity changes to trigger sync
    _connectivity.addListener(_onConnectivityChanged);
  }

  List<Exam> get exams => _exams;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // ── Load exams (offline-first) ─────────────────────────────────

  Future<void> loadExams() async {
    if (_userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Load from Hive immediately
      _exams = _repository.getExams(_userId!);
      notifyListeners();

      // 2. Sync with Firestore in background
      await _repository.fullSync(_userId!);

      // 3. Reload from Hive after sync
      _exams = _repository.getExams(_userId!);
    } catch (e) {
      _error = 'Failed to load exams';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Add exam ───────────────────────────────────────────────────

  Future<void> addExam({
    required String name,
    required String subject,
    required DateTime examDate,
    required List<String> topics,
    double targetStudyHours = 10.0,
  }) async {
    if (_userId == null) return;

    final exam = Exam(
      id: const Uuid().v4(),
      name: name,
      subject: subject,
      examDate: examDate,
      topics: topics,
      userId: _userId!,
      targetStudyHours: targetStudyHours,
    );

    await _repository.addExam(exam);
    _exams = _repository.getExams(_userId!);
    notifyListeners();
  }

  // ── Update exam ────────────────────────────────────────────────

  Future<void> updateExam(Exam exam) async {
    await _repository.updateExam(exam);
    _exams = _repository.getExams(_userId!);
    notifyListeners();
  }

  // ── Delete exam ────────────────────────────────────────────────

  Future<void> deleteExam(String id) async {
    await _repository.deleteExam(id);
    if (_userId != null) {
      _exams = _repository.getExams(_userId!);
    }
    notifyListeners();
  }

  // ── Get single exam ────────────────────────────────────────────

  Exam? getExamById(String id) {
    try {
      return _exams.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Connectivity change → auto-sync ────────────────────────────

  void _onConnectivityChanged() {
    if (_connectivity.isOnline && _userId != null) {
      _repository.fullSync(_userId!).then((_) {
        _exams = _repository.getExams(_userId!);
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
