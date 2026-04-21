import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
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

          // Calculate overall readiness using cached progress values
          final overallProgress = sessionProvider.getOverallReadiness(exams);
          final studyTime = sessionProvider.formattedTodayTime;
          final sessionCount = sessionProvider.todaySessionCount;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Dashboard',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Keep your exam prep focused',
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 28,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Track how ready you are, review today’s effort, and jump back into the next study session quickly.',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  CircularProgressWidget(
                    percentage: overallProgress,
                    label: 'OVERALL READINESS',
                    subtitle: 'Your study readiness at a glance',
                    helperText:
                        'This score reflects the progress you have built across your exams so far.',
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Today’s activity',
                    style: AppTextStyles.h2.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'A quick summary of the work you have done today.',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'Study time',
                          value: studyTime.isEmpty ? '0m' : studyTime,
                          icon: Icons.schedule_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Sessions',
                          value: '$sessionCount today',
                          icon: Icons.auto_graph_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Exams',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${exams.length} total',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap an exam to review its progress and topics.',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 14),

                  if (exams.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.description_outlined,
                              color: AppColors.accent,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No upcoming exams yet',
                            style: AppTextStyles.h2.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first exam to start tracking readiness and building a study plan.',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 14,
                              height: 1.45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
