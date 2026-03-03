import 'package:go_router/go_router.dart';
import 'services/auth_notifier.dart';
import '../features/welcome/welcome_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/exams/exams_screen.dart';
import '../features/exams/add_exam_screen.dart';
import '../features/exams/edit_exam_screen.dart';
import '../features/exams/exam_details_screen.dart';
import '../features/timer/timer_topic_select_screen.dart';
import '../features/timer/timer_screen.dart';
import 'widgets/main_shell.dart';
import '../features/profile/profile_screen.dart';

class AppRouter {
  static const _authRoutes = [
    '/welcome',
    '/login',
    '/sign-up',
    '/forgot-password',
  ];

  static GoRouter createRouter(AuthNotifier authNotifier) => GoRouter(
    initialLocation: authNotifier.isLoggedIn ? '/dashboard' : '/welcome',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final loggedIn = authNotifier.isLoggedIn;
      final isAuthPage = _authRoutes.contains(state.matchedLocation);
      if (loggedIn && isAuthPage) return '/dashboard';
      if (!loggedIn && !isAuthPage) return '/welcome';
      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
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
            path: '/timer-select',
            name: 'timer-select',
            builder: (context, state) => const TimerTopicSelectScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
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
          final examId = state.extra as String;
          return EditExamScreen(examId: examId);
        },
      ),
      GoRoute(
        path: '/exam-details',
        name: 'exam-details',
        builder: (context, state) {
          final examId = state.extra as String;
          return ExamDetailsScreen(examId: examId);
        },
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
