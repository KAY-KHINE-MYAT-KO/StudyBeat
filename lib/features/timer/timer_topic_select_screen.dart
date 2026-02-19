import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'models/timer_models.dart';
import 'widgets/exam_group_widget.dart';
import 'widgets/start_footer.dart';
import '../exams/widgets/exams_bottom_nav.dart';
import '../../core/widgets/bottom_nav_bar.dart';

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
        TimerTopic(id: 1, name: 'Optics'),
        TimerTopic(id: 2, name: 'Thermodynamics'),
      ],
    ),
    ExamGroup(
      id: 2,
      name: 'Math Final',
      expanded: false, // ✅ Collapsed by default
      topics: [
        TimerTopic(id: 3, name: 'Calculus'),
        TimerTopic(id: 4, name: 'Linear Algebra'),
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
                        return ExamGroupWidget(
                          exam: exam,
                          onToggle: () => _toggleExam(exam.id),
                          onToggleTopic: (topicId) => _toggleTopic(exam.id, topicId),
                        );
                      }).toList(),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),

            StartFooter(onStart: _handleStartStudying, showWarning: _showWarning),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),//bottomNavigationBar: const ExamsBottomNav(),
    );
  }
}
