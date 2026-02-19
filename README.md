StudyBeat

StudyBeat is a minimal, offline-first study planner built with Flutter. It's a student project intended to help manage exams and track focused study time using a simple timer.

## Features

- Dashboard: overview of study readiness and progress cards
- Exams: list exams, view details, add and edit exams locally
- Timer: select a topic and run a study timer
- Fully offline: no authentication or backend — data is stored locally (placeholder for local storage integration)

## Architecture

- Feature-based folder structure under `lib/` for clarity and easy scaling
- Simple core modules for routing, theme, and shared widgets
- Local-only data handling (implement persistence later with Hive/SharedPreferences/SQLite)

## Project Layout (important files)

```
lib/
├─ main.dart
├─ core/
│  ├─ router.dart
│  ├─ theme/
│  │  ├─ app_theme.dart
│  │  ├─ app_colors.dart
│  │  └─ app_text_styles.dart
│  └─ widgets/
│     ├─ primary_button.dart
│     └─ bottom_nav_bar.dart
└─ features/
   ├─ welcome/
   │  └─ welcome_screen.dart
   ├─ dashboard/
   │  └─ dashboard_screen.dart
   ├─ exams/
   │  ├─ exams_screen.dart
   │  ├─ exam_details_screen.dart
   │  └─ add_exam_screen.dart
   └─ timer/
      ├─ timer_topic_select_screen.dart
      └─ timer_screen.dart
```

## Getting started

Prerequisites: Flutter SDK installed. See https://flutter.dev/docs/get-started/install

Run locally:

```bash
# from project root (/Users/kaykhinemyatko/Mobile Development)
flutter pub get
flutter run    # or flutter run -d chrome | -d macos
```

## Notes for developers

- Routing is implemented with `go_router` in `lib/core/router.dart`.
- Current UI is a prototype; data persistence and business logic are placeholders.
- Suggested next work:
  - Implement local persistence for exams (Hive/SQLite)
  - Prefill `Add Exam` when editing an existing exam
  - Add tests and CI checks

## License

Add a `LICENSE` file if you plan to open-source the project (MIT recommended for small projects).

---

Built for learning and quick prototyping.


