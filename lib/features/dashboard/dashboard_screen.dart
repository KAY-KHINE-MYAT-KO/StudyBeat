import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/widgets/progress_card.dart';
import '../../core/providers/exam_provider.dart';
import '../../core/providers/study_session_provider.dart';
import 'widgets/circular_progress_widget.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().loadExams();
      context.read<StudySessionProvider>().loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<ExamProvider, StudySessionProvider>(
        builder: (context, examProvider, sessionProvider, child) {
          final exams = examProvider.exams;

          // Calculate overall readiness from actual study time vs target
          final overallProgress = exams.isEmpty
              ? 0
              : (exams.fold<double>(
                          0,
                          (sum, e) =>
                              sum + sessionProvider.getProgressForExam(e),
                        ) /
                        exams.length *
                        100)
                    .toInt();
          //  final overallProgress = exams.isEmpty
          // ? 0
          // : (exams.fold<double>(
          //             0,
          //             (sum, e) =>
          //                 sum + sessionProvider.getProgressForExam(e)
          //           ) /
          //           exams.length *
          //           100)
          //       .toInt();
          debugPrint(overallProgress.toString());
          final studyTime = sessionProvider.formattedTodayTime;
          final sessionCount = sessionProvider.todaySessionCount;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Card(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Hi there, ready to final your exams!',
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Circular Progress
                  Center(
                    child: CircularProgressWidget(
                      percentage: overallProgress,
                      label: 'READY',
                      subtitle: 'Your Overall Study Readiness',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'Studied',
                          value: studyTime.isEmpty ? '0m' : studyTime,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Sessions',
                          value: '$sessionCount Today',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Upcoming Exams Section
                  Text('Upcoming Exams', style: AppTextStyles.h3),
                  const SizedBox(height: 12),

                  if (exams.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No upcoming exams. Add one!',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ),
                    )
                  else
                    ...exams.take(4).map((exam) {
                      final dateStr = DateFormat(
                        'MMM d, yyyy',
                      ).format(exam.examDate);
                      final progress = sessionProvider.getProgressForExam(exam);
                      final pct = (progress * 100).toInt();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed('exam-details', extra: exam.id);
                          },
                          child: ProgressCard(
                            title: exam.name,
                            subtitle: 'Exam: $dateStr',
                            progress: progress,
                            percentageText: '$pct%',
                          ),
                        ),
                      );
                    }),

                  const SizedBox(height: 24),

                  // Bottom Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: 'Add Exam',
                          onPressed: () {
                            context.pushNamed('add-exam');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Start Now',
                          onPressed: () {
                            context.go('/timer-select');
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
