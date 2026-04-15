import 'dart:async';
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

  // Cache for exam progress to avoid expensive recalculations
  final Map<String, double> _progressCache = {};
  int _lastSessionCount = 0;
  late final StreamSubscription<User?> _authSub;

  StudySessionProvider(this._repository, this._connectivity) {
    _connectivity.addListener(_onConnectivityChanged);
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        _sessions = [];
        _isLoading = false;
        _progressCache.clear();
        _lastSessionCount = 0;
        notifyListeners();
        return;
      }
      loadSessions();
    });
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

  // ── Cache invalidation helper ──────────────────────────────────

  void _invalidateCacheIfNeeded() {
    if (_sessions.length != _lastSessionCount) {
      _progressCache.clear();
      _lastSessionCount = _sessions.length;
    }
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
  /// Uses caching to avoid expensive recalculations on every build.
  double getProgressForExam(Exam exam) {
    _invalidateCacheIfNeeded();

    // Return cached value if available
    if (_progressCache.containsKey(exam.id)) {
      return _progressCache[exam.id]!;
    }

    if (exam.targetStudyHours <= 0) {
      _progressCache[exam.id] = 0.0;
      return 0.0;
    }

    final studiedSeconds = getStudySecondsForExam(exam);
    final targetSeconds = (exam.targetStudyHours * 3600).toInt();
    final progress = studiedSeconds / targetSeconds;
    final clampedProgress = progress.clamp(0.0, 1.0);

    // Cache the calculated value
    _progressCache[exam.id] = clampedProgress;
    return clampedProgress;
  }

  /// Calculates overall readiness (0-100) for a list of exams.
  /// Uses cached progress values, so prefer this over calculating in the UI.
  int getOverallReadiness(List<Exam> exams) {
    if (exams.isEmpty) return 0;
    final totalProgress = exams.fold<double>(
      0,
      (sum, e) => sum + getProgressForExam(e),
    );
    return (totalProgress / exams.length * 100).toInt();
  }

  // ── Load sessions (offline-first) ─────────────────────────────

  Future<void> loadSessions() async {
    if (_userId == null) {
      _sessions = [];
      _isLoading = false;
      _progressCache.clear();
      _lastSessionCount = 0;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // 1. Load from Hive immediately
      _sessions = _repository.getSessions(_userId!);
      notifyListeners();

      // 2. Sync with Firestore in background
      await _repository.fullSync(_userId!);

      // 3. Reload from Hive after sync (ensures we have fresh Firestore data)
      _sessions = _repository.getSessions(_userId!);
      _invalidateCacheIfNeeded();
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
    final userId = _userId;
    if (_connectivity.isOnline && userId != null) {
      _repository.fullSync(userId).then((_) {
        _sessions = _repository.getSessions(userId);
        notifyListeners();
      }).catchError((e) {
        // Log error but don't crash
      });
    }
  }

  // ── Clear user data on logout ──────────────────────────────────

  Future<void> clearUserData(String userId) async {
    _sessions = [];
    _progressCache.clear();
    _lastSessionCount = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub.cancel();
    _connectivity.removeListener(_onConnectivityChanged);
    super.dispose();
  }
}
