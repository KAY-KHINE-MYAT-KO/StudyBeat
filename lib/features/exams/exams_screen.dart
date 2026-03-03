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
      body: Consumer<ExamProvider>(
        builder: (context, examProvider, child) {
          final exams = examProvider.exams;

          if (examProvider.isLoading && exams.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (exams.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(height: 16),
                    Text('No exams yet', style: AppTextStyles.h2),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add your first exam',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Exams', style: AppTextStyles.h1),
                  const SizedBox(height: 20),
                  ...exams.map((exam) {
                    final dateStr = DateFormat(
                      'MMM d, yyyy',
                    ).format(exam.examDate);
                    final sessionProvider = context
                        .watch<StudySessionProvider>();
                    final progress = sessionProvider.getProgressForExam(exam);
                    final progressPct = (progress * 100).toInt();
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
                          percentageText: '$progressPct%',
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 80),
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
