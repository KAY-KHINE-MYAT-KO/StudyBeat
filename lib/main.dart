import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_notifier.dart';
import 'core/services/session_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/models/exam.dart';
import 'core/models/study_session.dart';
import 'core/repositories/exam_repository.dart';
import 'core/repositories/study_session_repository.dart';
import 'core/providers/exam_provider.dart';
import 'core/providers/study_session_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(ExamAdapter());
  Hive.registerAdapter(StudySessionAdapter());

  await SessionService.init();
  await ExamRepository.init();
  await StudySessionRepository.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kIsWeb) GoRouter.optionURLReflectsImperativeAPIs = true;

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final authNotifier = AuthNotifier();
  final connectivityService = ConnectivityService();
  final examRepository = ExamRepository(connectivityService);
  final sessionRepository = StudySessionRepository(connectivityService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: connectivityService),
        ChangeNotifierProvider(
          create: (_) => ExamProvider(examRepository, connectivityService),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              StudySessionProvider(sessionRepository, connectivityService),
        ),
      ],
      child: StudyBeatApp(authNotifier: authNotifier),
    ),
  );
}

class StudyBeatApp extends StatefulWidget {
  final AuthNotifier authNotifier;

  const StudyBeatApp({super.key, required this.authNotifier});

  @override
  State<StudyBeatApp> createState() => _StudyBeatAppState();
}

class _StudyBeatAppState extends State<StudyBeatApp> {
  late final _router = AppRouter.createRouter(widget.authNotifier);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StudyBeat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
