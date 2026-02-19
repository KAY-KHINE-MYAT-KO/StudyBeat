import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'models/topic.dart';
import 'widgets/exam_details_header.dart';
import 'widgets/topics_list.dart';
import 'widgets/exam_actions.dart';
import 'widgets/exams_bottom_nav.dart';

class ExamDetailsScreen extends StatefulWidget {
  final String examName;
  final String examDate;
  final double progress;
  final List<String> topics;

  const ExamDetailsScreen({
    super.key,
    required this.examName,
    required this.examDate,
    required this.progress,
    required this.topics,
  });

  @override
  State<ExamDetailsScreen> createState() => _ExamDetailsScreenState();
}

class _ExamDetailsScreenState extends State<ExamDetailsScreen> {
  int? selectedTopicId;

  // Get topics based on exam
  List<Topic> _getTopicsForExam() {
    // Physics Midterm topics
    if (widget.examName.contains('Physics')) {
      return [
        Topic(
          id: 1,
          name: 'Kinematics & Dynamics',
          flashcards: '12 flashcards mastered',
          completed: true,
        ),
        Topic(
          id: 2,
          name: 'Work and Energy',
          flashcards: '8 flashcards mastered',
          completed: true,
        ),
        Topic(
          id: 3,
          name: 'Circular Motion',
          flashcards: '15 flashcards mastered',
          completed: true,
        ),
        Topic(
          id: 4,
          name: 'Thermodynamics',
          flashcards: '0/10 flashcards completed',
          completed: false,
        ),
      ];
    }
    // Math Final topics
    else if (widget.examName.contains('Math')) {
      return [
        Topic(
          id: 1,
          name: 'Calculus',
          flashcards: '5 flashcards mastered',
          completed: true,
        ),
        Topic(
          id: 2,
          name: 'Linear Algebra',
          flashcards: '0/15 flashcards completed',
          completed: false,
        ),
        Topic(
          id: 3,
          name: 'Statistics',
          flashcards: '0/12 flashcards completed',
          completed: false,
        ),
      ];
    }
    // Chemistry Quiz topics
    else if (widget.examName.contains('Chemistry')) {
      return [
        Topic(
          id: 1,
          name: 'Organic Chemistry',
          flashcards: '20 flashcards mastered',
          completed: true,
        ),
        Topic(
          id: 2,
          name: 'Inorganic Chemistry',
          flashcards: '18 flashcards mastered',
          completed: true,
        ),
        Topic(
          id: 3,
          name: 'Chemical Bonding',
          flashcards: '15 flashcards mastered',
          completed: true,
        ),
      ];
    }
    // Default topics
    else {
      return [
        Topic(
          id: 1,
          name: 'Topic 1',
          flashcards: '0/10 flashcards completed',
          completed: false,
        ),
      ];
    }
  }

  void _handleStudyNow() {
    if (selectedTopicId != null) {
      final topics = _getTopicsForExam();
      final selectedTopic = topics.firstWhere((t) => t.id == selectedTopicId);
      context.go('/timer', extra: [selectedTopic.name]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topics = _getTopicsForExam();
    final completedTopics = topics.where((t) => t.completed).length;
    final totalTopics = topics.length;
    final progress = widget.progress.toInt();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
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
          child: Container(
            color: const Color(0xFFE5E7EB),
            height: 1,
          ),
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
                  examName: widget.examName,
                  examDate: widget.examDate,
                  progress: progress,
                  completedTopics: completedTopics,
                  totalTopics: totalTopics,
                ),
                TopicsList(topics: topics, selectedTopicId: selectedTopicId, onSelect: (id) => setState(() => selectedTopicId = id)),
                const SizedBox(height: 24),
                ExamActions(
                  onEdit: () => context.pushNamed('edit-exam', extra: {
                    'examName': widget.examName,
                    'examDate': widget.examDate,
                    'examProgress': widget.progress.toInt(),
                  }),
                  onDelete: () => _showDeleteDialog(context),
                  onStudyNow: _handleStudyNow,
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
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Exam', style: AppTextStyles.h2),
          content: Text(
            'Are you sure you want to delete this exam?',
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/exams');
              },
              child: Text(
                'Delete',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
