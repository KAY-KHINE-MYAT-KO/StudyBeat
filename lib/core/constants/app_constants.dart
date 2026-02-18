class AppConstants {
  // App Info
  static const String appName = 'StudyBeat';
  static const String appTagline = 'Master your exams with\nsmart study sessions';
  
  // Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration timerTickDuration = Duration(seconds: 1);
  
  // Limits
  static const int maxTopicsPerExam = 20;
  static const int maxExamNameLength = 50;
  static const int minExamNameLength = 3;
  
  // Messages
  static const String welcomeMessage = 'Hi there, ready to final your exams!';
  static const String noExamsMessage = 'No exams yet. Add your first exam to get started!';
  static const String noTopicsSelectedMessage = 'Please select at least one topic';
  
  // Storage Keys
  static const String examsStorageKey = 'exams';
  static const String sessionsStorageKey = 'sessions';
  static const String preferencesStorageKey = 'preferences';
}