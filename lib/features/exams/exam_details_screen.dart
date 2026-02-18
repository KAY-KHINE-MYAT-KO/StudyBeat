import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class Topic {
  final int id;
  final String name;
  final String flashcards;
  final bool completed;

  Topic({
    required this.id,
    required this.name,
    required this.flashcards,
    required this.completed,
  });
}

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
                // Exam Title (Dynamic)
                Text(
                  widget.examName,
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Date and Ready Status (Dynamic)
                Text(
                  '${widget.examDate}, 2024 • $progress% Ready',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                // Overall Progress Section (Dynamic)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'OVERALL PROGRESS',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 12,
                            color: const Color(0xFF2A7FF7),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '$progress%',
                          style: AppTextStyles.h2.copyWith(
                            fontSize: 18,
                            color: const Color(0xFF2A7FF7),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: const Color(0xFFE5E7EB),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF2A7FF7),
                        ),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Topics Section (Dynamic count)
                Row(
                  children: [
                    Text(
                      'Topics ',
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '($completedTopics/$totalTopics)',
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 20,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Topics List - Only incomplete topics are selectable (Dynamic topics)
                ...topics.map((topic) {
                  final isSelected = selectedTopicId == topic.id;
                  final isClickable = !topic.completed;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: isClickable
                          ? () {
                              setState(() {
                                selectedTopicId = topic.id;
                              });
                            }
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status Icon - Checkmark for completed, Circle/Radio for incomplete
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: topic.completed
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF4CD964),
                                      size: 24,
                                    )
                                  : Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF2A7FF7)
                                              : const Color(0xFFD1D5DB),
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Center(
                                              child: Container(
                                                width: 12,
                                                height: 12,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF2A7FF7),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                            ),

                            const SizedBox(width: 12),

                            // Topic Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic.name,
                                    style: AppTextStyles.h3.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    topic.flashcards,
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                              // Navigate to edit exam screen with current exam data
                              context.pushNamed('edit-exam', extra: {
                                'examName': widget.examName,
                                'examDate': widget.examDate,
                                'examProgress': widget.progress.toInt(),
                              });
                            },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2A7FF7),
                          side: const BorderSide(
                            color: Color(0xFF2A7FF7),
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Edit Exam',
                          style: AppTextStyles.button.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2A7FF7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _showDeleteDialog(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFEF4444),
                          side: const BorderSide(
                            color: Color(0xFFEF4444),
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Delete Exam',
                          style: AppTextStyles.button.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Study Now Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedTopicId != null ? _handleStudyNow : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A7FF7),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFF2A7FF7).withOpacity(0.3),
                    ),
                    child: Text(
                      'Study Now',
                      style: AppTextStyles.button.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Dashboard
              InkWell(
                onTap: () => context.go('/dashboard'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.dashboard_outlined,
                        color: const Color(0xFF9CA3AF),
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Dashboard',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Exams (Active)
              InkWell(
                onTap: () => context.go('/exams'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: const Color(0xFF2A7FF7),
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Exams',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: const Color(0xFF2A7FF7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Timer
              InkWell(
                onTap: () => context.go('/timer-select'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: const Color(0xFF9CA3AF),
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Timer',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
