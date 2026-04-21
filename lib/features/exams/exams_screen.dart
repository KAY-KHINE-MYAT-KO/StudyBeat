import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/progress_card.dart';
import '../../core/providers/exam_provider.dart';
import '../../core/providers/study_session_provider.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  @override
  void initState() {
    super.initState();
    // Load exams when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().loadExams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ExamProvider>(
        builder: (context, examProvider, child) {
          final exams = examProvider.exams;
          final sessionProvider = context.watch<StudySessionProvider>();

          if (examProvider.isLoading && exams.isEmpty) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return SafeArea(
            child: Container(
              color: AppColors.background,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(20.0),
                    sliver: SliverToBoxAdapter(
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
                                    'Exams',
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Keep all your exams in one place',
                                  style: AppTextStyles.h1.copyWith(
                                    fontSize: 28,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Track each exam, review your readiness, and jump into the details whenever you want to focus your prep.',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 15,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Exams',
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
                            exams.isEmpty
                                ? 'Add your first exam to start building your study plan.'
                                : 'Tap any exam to open its details and progress.',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (exams.isEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      sliver: SliverToBoxAdapter(
                        child: Container(
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
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.school_outlined,
                                  size: 30,
                                  color: AppColors.accent,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'No exams yet',
                                style: AppTextStyles.h2.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create your first exam to start tracking topics, progress, and readiness in one place.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => context.pushNamed('add-exam'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.accent,
                                    side: const BorderSide(
                                      color: AppColors.accent,
                                      width: 1.5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor:
                                        AppColors.accent.withOpacity(0.04),
                                  ),
                                  child: Text(
                                    'Add Your First Exam',
                                    style: AppTextStyles.button.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      sliver: SliverList.builder(
                        itemCount: exams.length,
                        itemBuilder: (context, index) {
                          final exam = exams[index];
                          final dateStr = DateFormat(
                            'MMM d, yyyy',
                          ).format(exam.examDate);
                          final progress = sessionProvider.getProgressForExam(
                            exam,
                          );
                          final progressPct = (progress * 100).toInt();

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  'exam-details',
                                  extra: exam.id,
                                );
                              },
                              child: ProgressCard(
                                title: exam.name,
                                subtitle: 'Exam: $dateStr',
                                progress: progress,
                                percentageText: '$progressPct%',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SliverPadding(
                    padding: EdgeInsets.only(bottom: 100),
                    sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add-exam');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
