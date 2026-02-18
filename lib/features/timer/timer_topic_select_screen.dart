import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class Topic {
  final int id;
  final String name;
  bool selected;

  Topic({
    required this.id,
    required this.name,
    this.selected = false,
  });
}

class ExamGroup {
  final int id;
  final String name;
  final List<Topic> topics;
  bool expanded;

  ExamGroup({
    required this.id,
    required this.name,
    required this.topics,
    this.expanded = false, // ✅ Start collapsed
  });
}

class TimerTopicSelectScreen extends StatefulWidget {
  const TimerTopicSelectScreen({super.key});

  @override
  State<TimerTopicSelectScreen> createState() => _TimerTopicSelectScreenState();
}

class _TimerTopicSelectScreenState extends State<TimerTopicSelectScreen> {
  bool _showWarning = false; // ✅ Warning state

  final List<ExamGroup> _exams = [
    ExamGroup(
      id: 1,
      name: 'Physics Midterm',
      expanded: false, // ✅ Collapsed by default
      topics: [
        Topic(id: 1, name: 'Optics'),
        Topic(id: 2, name: 'Thermodynamics'),
      ],
    ),
    ExamGroup(
      id: 2,
      name: 'Math Final',
      expanded: false, // ✅ Collapsed by default
      topics: [
        Topic(id: 3, name: 'Calculus'),
        Topic(id: 4, name: 'Linear Algebra'),
      ],
    ),
  ];

  void _toggleExam(int examId) {
    setState(() {
      final index = _exams.indexWhere((e) => e.id == examId);
      if (index != -1) {
        _exams[index].expanded = !_exams[index].expanded;
      }
    });
  }

  void _toggleTopic(int examId, int topicId) {
    setState(() {
      final examIndex = _exams.indexWhere((e) => e.id == examId);
      if (examIndex != -1) {
        final topicIndex = _exams[examIndex].topics.indexWhere((t) => t.id == topicId);
        if (topicIndex != -1) {
          _exams[examIndex].topics[topicIndex].selected = 
              !_exams[examIndex].topics[topicIndex].selected;
        }
      }
    });
  }

  void _handleStartStudying() {
    final selectedTopics = _exams
        .expand((exam) => exam.topics)
        .where((topic) => topic.selected)
        .map((topic) => topic.name)
        .toList();

    // ✅ Show warning if no topics selected
    if (selectedTopics.isEmpty) {
      setState(() {
        _showWarning = true;
      });
      // Hide warning after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showWarning = false;
          });
        }
      });
      return;
    }

    // Navigate to timer with selected topics
    context.go('/timer', extra: selectedTopics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'StudyBeat',
            style: AppTextStyles.appBarTitle.copyWith(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // Main Content - Scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Timer',
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Subtitle
                      Text(
                        'Select A Topic to Start Studying',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Exams List
                      ..._exams.map((exam) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Exam Header
                            InkWell(
                              onTap: () => _toggleExam(exam.id),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      exam.name,
                                      style: AppTextStyles.h2.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Icon(
                                      exam.expanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: AppColors.textSecondary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Topics (visible when expanded)
                            if (exam.expanded)
                              Column(
                                children: exam.topics.map((topic) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: InkWell(
                                      onTap: () => _toggleTopic(exam.id, topic.id),
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: topic.selected
                                                ? AppColors.accent
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
                                          children: [
                                            // Status Icon
                                            topic.selected
                                                ? const Icon(
                                                    Icons.check_circle,
                                                    color: AppColors.accent,
                                                    size: 24,
                                                  )
                                                : Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: const Color(0xFFD1D5DB),
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                            const SizedBox(width: 12),

                                            // Topic Name
                                            Expanded(
                                              child: Text(
                                                topic.name,
                                                style: AppTextStyles.body.copyWith(
                                                  fontSize: 16,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),

            // Start Studying Button
            Container(
              color: AppColors.background,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleStartStudying,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.3),
                      ),
                      child: Text(
                        'Start Studying',
                        style: AppTextStyles.button.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // ✅ Warning message
                  if (_showWarning)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Please select at least one topic to start studying.',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 14,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ],
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
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Dashboard',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Exams
              InkWell(
                onTap: () => context.go('/exams'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Exams',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Timer (Active)
              InkWell(
                onTap: () => context.go('/timer-select'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: AppColors.accent,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Timer',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: AppColors.accent,
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
}
