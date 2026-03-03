import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/providers/exam_provider.dart';
import '../../core/providers/study_session_provider.dart';
import '../../core/models/exam.dart';
import 'models/topic.dart';
import 'widgets/exam_details_header.dart';
import 'widgets/topics_list.dart';
import 'widgets/exam_actions.dart';
import 'widgets/exams_bottom_nav.dart';

class ExamDetailsScreen extends StatefulWidget {
  final String examId;

  const ExamDetailsScreen({super.key, required this.examId});

  @override
  State<ExamDetailsScreen> createState() => _ExamDetailsScreenState();
}

class _ExamDetailsScreenState extends State<ExamDetailsScreen> {
  int? selectedTopicId;

  List<Topic> _buildTopics(Exam exam) {
    return exam.topics.asMap().entries.map((entry) {
      return Topic(
        id: entry.key + 1,
        name: entry.value,
        flashcards: '0 flashcards',
        completed: false,
      );
    }).toList();
  }

  void _handleStudyNow(Exam exam) {
    if (selectedTopicId != null) {
      final topics = _buildTopics(exam);
      final selectedTopic = topics.firstWhere((t) => t.id == selectedTopicId);
      context.go('/timer', extra: [selectedTopic.name]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamProvider>(
      builder: (context, examProvider, child) {
        final exam = examProvider.getExamById(widget.examId);

        if (exam == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'Exam Details',
                style: AppTextStyles.appBarTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            body: const Center(child: Text('Exam not found')),
          );
        }

        final topics = _buildTopics(exam);
        final completedTopics = topics.where((t) => t.completed).length;
        final totalTopics = topics.length;
        final sessionProvider = context.watch<StudySessionProvider>();
        final computedProgress = sessionProvider.getProgressForExam(exam);
        final progress = (computedProgress * 100).toInt();
        final dateStr = DateFormat('MMM d, yyyy').format(exam.examDate);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 24,
              ),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Exam Details',
              style: AppTextStyles.appBarTitle.copyWith(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: const Color(0xFFE5E7EB), height: 1),
            ),
          ),
          body: Container(
            color: AppColors.background,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExamDetailsHeader(
                      examName: exam.name,
                      examDate: dateStr,
                      progress: progress,
                      completedTopics: completedTopics,
                      totalTopics: totalTopics,
                    ),
                    TopicsList(
                      topics: topics,
                      selectedTopicId: selectedTopicId,
                      onSelect: (id) => setState(() => selectedTopicId = id),
                    ),
                    const SizedBox(height: 24),
                    ExamActions(
                      onEdit: () =>
                          context.pushNamed('edit-exam', extra: exam.id),
                      onDelete: () => _showDeleteDialog(context, exam.id),
                      onStudyNow: () => _handleStudyNow(exam),
                      canStudy: selectedTopicId != null,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: const ExamsBottomNav(),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String examId) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Delete Exam', style: AppTextStyles.h2),
          content: Text(
            'Are you sure you want to delete this exam?',
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await context.read<ExamProvider>().deleteExam(examId);
                if (mounted) context.go('/exams');
              },
              child: Text(
                'Delete',
                style: AppTextStyles.button.copyWith(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
