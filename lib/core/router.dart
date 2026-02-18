import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/welcome/welcome_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/exams/exams_screen.dart';
import '../features/exams/add_exam_screen.dart';
import '../features/exams/edit_exam_screen.dart';
import '../features/exams/exam_details_screen.dart';
import '../features/timer/timer_topic_select_screen.dart';
import '../features/timer/timer_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/exams',
        name: 'exams',
        builder: (context, state) => const ExamsScreen(),
      ),
      GoRoute(
        path: '/add-exam',
        name: 'add-exam',
        builder: (context, state) => const AddExamScreen(),
      ),
      GoRoute(
        path: '/edit-exam',
        name: 'edit-exam',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EditExamScreen(
            examName: extra['examName'] as String,
            examDate: extra['examDate'] as String,
            examProgress: extra['examProgress'] as int,
          );
        },
      ),
      GoRoute(
        path: '/exam-details',
        name: 'exam-details',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ExamDetailsScreen(
            examName: extra['examName'] as String,
            examDate: extra['examDate'] as String,
            progress: extra['progress'] as double,
            topics: extra['topics'] as List<String>,
          );
        },
      ),
      GoRoute(
        path: '/timer-select',
        name: 'timer-select',
        builder: (context, state) => const TimerTopicSelectScreen(),
      ),
      GoRoute(
        path: '/timer',
        name: 'timer',
        builder: (context, state) {
          final topics = state.extra as List<String>? ?? [];
          return TimerScreen(selectedTopics: topics);
        },
      ),
    ],
  );
}
