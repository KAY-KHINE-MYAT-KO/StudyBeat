# StudyBeat Performance Issues Report

## Critical Issues 🔴

### 1. **Timer Screen: Excessive setState() Calls (HIGH IMPACT)**
**Location:** [lib/features/timer/timer_screen.dart](lib/features/timer/timer_screen.dart#L44-L56)

**Problem:**
- Timer calls `setState()` every single second, triggering a complete widget rebuild
- This rebuilds the entire UI tree (timer display, buttons, cards) every second
- Very inefficient for a simple counter update

```dart
_timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  setState(() {  // ❌ Rebuilds entire widget every second
    _seconds++;
    _totalSeconds++;
    // ...
  });
});
```

**Impact:** Battery drain, unnecessary CPU usage, potential frame drops on low-end devices

**Solution:** Use `ValueNotifier` or `AnimationController` instead of full widget rebuilds, or use a more efficient state management approach.

---

### 2. **N+1 Performance: Multiple getProgressForExam() Calls (HIGH IMPACT)**
**Locations:** 
- [lib/features/exams/exams_screen.dart](lib/features/exams/exams_screen.dart#L75-L80)
- [lib/features/dashboard/dashboard_screen.dart](lib/features/dashboard/dashboard_screen.dart#L35-L50)
- [lib/features/dashboard/dashboard_screen.dart](lib/features/dashboard/dashboard_screen.dart#L117-L140)

**Problem:**
- `getProgressForExam()` is called inside loops on every widget rebuild
- Each call iterates through ALL sessions to find matching topics: O(n*m) complexity
- Exams screen + Dashboard both call this multiple times per build
- Results are recalculated even when data hasn't changed

```dart
// ExamsScreen - calls getProgressForExam for EVERY exam on every rebuild
...exams.map((exam) {
  final sessionProvider = context.watch<StudySessionProvider>();  // Watches provider
  final progress = sessionProvider.getProgressForExam(exam);  // O(n*m) operation
  // ...
})
```

**Impact:** Quadratic performance degradation as exams/sessions grow. On dashboard with 10 exams, this performs hundreds of iterations unnecessarily.

**Solution:** Cache progress values and only recalculate when sessions change.

---

### 3. **TextEditingController Memory Leak (MEDIUM IMPACT)**
**Location:** [lib/features/profile/profile_screen.dart](lib/features/profile/profile_screen.dart#L145)

**Problem:**
- `TextEditingController` created inside `showDialog()` callback, called on every rebuild
- Never properly disposed
- Creates memory leak

```dart
void _confirmDeleteAccount(BuildContext context, AuthService authService) {
  final passwordController = TextEditingController();  // ❌ Created in callback, never disposed
  
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      // ...
    ),
  );
}
```

**Impact:** Memory leak accumulates with each dialog open/close cycle

**Solution:** Dispose controller properly or move it to State variables.

---

## High Priority Issues 🟡

### 4. **Inefficient List Rebuilds with Spread Operator (HIGH IMPACT)**
**Locations:**
- [lib/features/exams/exams_screen.dart](lib/features/exams/exams_screen.dart#L63-85)
- [lib/features/dashboard/dashboard_screen.dart](lib/features/dashboard/dashboard_screen.dart#L117-140)

**Problem:**
- Using `...exams.map()` spreads all widgets into Column
- Any change to ANY exam rebuilds ALL exam widgets in the list
- No widget caching or keying

```dart
Column(
  children: [
    Text('My Exams', style: AppTextStyles.h1),
    const SizedBox(height: 20),
    ...exams.map((exam) {  // ❌ No keys, complete rebuild on any exam change
      // Build individual exam widgets
    }),
  ],
)
```

**Impact:** Poor performance on large exam lists

**Solution:** Use `ListView.builder` with proper keys for each item.

---

### 5. **100x Testing Multiplier Bug in Production Code (MEDIUM IMPACT)**
**Location:** [lib/core/providers/study_session_provider.dart](lib/core/providers/study_session_provider.dart#L64-75)

**Problem:**
- Progress calculation has 100x multiplier left over from testing
- Makes all progress calculations incorrect

```dart
double getProgressForExam(Exam exam) {
  if (exam.targetStudyHours <= 0) return 0.0;
  final studiedSeconds = getStudySecondsForExam(exam);
  final targetSeconds = (exam.targetStudyHours * 3600).toInt();
  final progress = (studiedSeconds * 100) / targetSeconds;  // ❌ TODO: Remove 100x multiplier
  return progress.clamp(0.0, 1.0);
}
```

**Impact:** Progress bars show incorrect values, reaching 100% after only 1% study time

**Solution:** Remove the `* 100` multiplier.

---

### 6. **Expensive Computations in Build Methods (MEDIUM IMPACT)**
**Location:** [lib/features/dashboard/dashboard_screen.dart](lib/features/dashboard/dashboard_screen.dart#L35-60)

**Problem:**
- `overallProgress` calculation done on every build
- Uses `fold()` which iterates through all exams
- Each iteration calls expensive `getProgressForExam()`

```dart
final overallProgress = exams.isEmpty
    ? 0
    : (exams.fold<double>(
        0,
        (sum, e) => sum + sessionProvider.getProgressForExam(e),  // ❌ Expensive in loop
      ) / exams.length * 100).toInt();
```

**Impact:** Dashboard becomes slower as exam count increases

**Solution:** Cache this value in provider and recalculate only when sessions update.

---

### 7. **No Pagination for Lists (MEDIUM IMPACT)**
**Locations:**
- [lib/features/exams/exams_screen.dart](lib/features/exams/exams_screen.dart#L64-85)
- [lib/features/timer/timer_topic_select_screen.dart](lib/features/timer/timer_topic_select_screen.dart#L134-200+)

**Problem:**
- Using `SingleChildScrollView` + `Column` for potentially large lists
- All widgets rendered at once, even off-screen
- No lazy loading

**Impact:** High memory usage and slow scrolling on large lists

**Solution:** Use `ListView.builder` or `LazyColumn` for better virtual scrolling.

---

## Medium Priority Issues 🟠

### 8. **Hive Query Inefficiencies (LOW-MEDIUM IMPACT)**
**Location:** [lib/core/repositories/exam_repository.dart](lib/core/repositories/exam_repository.dart#L20-25)

**Problem:**
- Creating unnecessary intermediate lists
- `.toList()` called after `.where()` creates a copy

```dart
List<Exam> getExams(String userId) {
  return _box.values.where((e) => e.userId == userId && !e.deleted).toList()  // ❌ Creates intermediate list
    ..sort((a, b) => a.examDate.compareTo(b.examDate));
}
```

**Solution:** Minor - acceptable for small datasets, but could use better indexing in Hive if queries grow.

---

### 9. **didChangeDependencies Called Too Frequently (LOW-MEDIUM IMPACT)**
**Location:** [lib/features/timer/timer_topic_select_screen.dart](lib/features/timer/timer_topic_select_screen.dart#L29-31)

**Problem:**
- `_syncExamGroups()` called in both `initState()` AND `didChangeDependencies()`
- `didChangeDependencies()` is called very frequently

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _syncExamGroups();  // ❌ Called too often, could be debounced
}
```

**Solution:** Add change detection to only sync when provider actually changes.

---

### 10. **Multiple Calls to context.read() in Same Build (LOW IMPACT)**
**Locations:** Multiple screens

**Problem:**
- Multiple `context.read()` calls in same build method
- Should be extracted to reduce lookups

```dart
final exams = context.read<ExamProvider>().exams;
// ... later
await context.read<ExamProvider>().deleteExam(examId);
```

**Solution:** Extract to local variable or use `watch` instead of `read`.

---

## Summary Table

| Issue | Severity | Impact | Fix Difficulty |
|-------|----------|--------|-----------------|
| Timer setState() loop | 🔴 CRITICAL | Battery drain, CPU usage | 🟢 Easy |
| N+1 getProgressForExam | 🔴 CRITICAL | Quadratic slowdown | 🔴 Hard |
| TextEditingController leak | 🔴 CRITICAL | Memory leak | 🟢 Easy |
| Inefficient list rebuilds | 🔴 CRITICAL | Poor scroll performance | 🔴 Hard |
| 100x multiplier bug | 🟡 HIGH | Wrong progress values | 🟢 Easy |
| Build method computations | 🟡 HIGH | Dashboard slowdown | 🟡 Medium |
| No pagination | 🟡 HIGH | High memory usage | 🔴 Hard |
| Hive query inefficiency | 🟠 MEDIUM | Minor (small datasets) | 🟢 Easy |
| didChangeDependencies | 🟠 MEDIUM | Unnecessary syncs | 🟡 Medium |
| Multiple context.read() | 🠢 LOW | Negligible | 🟢 Easy |

---

## Recommended Fixes Priority

1. **Immediate:** Fix the 100x multiplier bug (1 minute)
2. **Immediate:** Fix TextEditingController leak (5 minutes)
3. **High Priority:** Replace timer setState() with ValueNotifier (30 minutes)
4. **High Priority:** Implement progress caching (1-2 hours)
5. **Medium Priority:** Convert lists to ListView.builder (2-3 hours)
6. **Medium Priority:** Optimize build methods (1 hour)

Total estimated fix time: ~5-8 hours for all issues.
