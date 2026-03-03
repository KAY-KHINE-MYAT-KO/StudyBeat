import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/providers/exam_provider.dart';
import 'models/timer_models.dart';
import 'widgets/exam_group_widget.dart';
import 'widgets/start_footer.dart';

class TimerTopicSelectScreen extends StatefulWidget {
  const TimerTopicSelectScreen({super.key});

  @override
  State<TimerTopicSelectScreen> createState() => _TimerTopicSelectScreenState();
}

class _TimerTopicSelectScreenState extends State<TimerTopicSelectScreen> {
  bool _showWarning = false;
  List<ExamGroup> _examGroups = [];
  List<String> _lastExamIds = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncExamGroups();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncExamGroups();
  }

  void _syncExamGroups() {
    final exams = context.read<ExamProvider>().exams;
    final currentIds = exams.map((e) => e.id).toList();

    // Only rebuild if the exam list actually changed
    if (_listEquals(currentIds, _lastExamIds)) return;
    _lastExamIds = currentIds;

    // Preserve existing selection state
    final selectedTopicNames = <String>{};
    for (final group in _examGroups) {
      for (final topic in group.topics) {
        if (topic.selected)
          selectedTopicNames.add('${group.name}::${topic.name}');
      }
    }

    setState(() {
      _examGroups = exams.asMap().entries.map((entry) {
        return ExamGroup(
          id: entry.key + 1,
          name: entry.value.name,
          expanded: _examGroups.length > entry.key
              ? _examGroups[entry.key].expanded
              : false,
          topics: entry.value.topics.asMap().entries.map((topicEntry) {
            final key = '${entry.value.name}::${topicEntry.value}';
            return TimerTopic(
              id: entry.key * 100 + topicEntry.key + 1,
              name: topicEntry.value,
              selected: selectedTopicNames.contains(key),
            );
          }).toList(),
        );
      }).toList();
    });
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _toggleExam(int examId) {
    setState(() {
      final index = _examGroups.indexWhere((e) => e.id == examId);
      if (index != -1) {
        _examGroups[index].expanded = !_examGroups[index].expanded;
      }
    });
  }

  void _toggleTopic(int examId, int topicId) {
    setState(() {
      final examIndex = _examGroups.indexWhere((e) => e.id == examId);
      if (examIndex != -1) {
        final topicIndex = _examGroups[examIndex].topics.indexWhere(
          (t) => t.id == topicId,
        );
        if (topicIndex != -1) {
          _examGroups[examIndex].topics[topicIndex].selected =
              !_examGroups[examIndex].topics[topicIndex].selected;
        }
      }
    });
  }

  void _handleStartStudying() {
    final selectedTopics = _examGroups
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
                      if (_examGroups.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'No exams yet. Add an exam first!',
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                        )
                      else
                        ..._examGroups.map((exam) {
                          return ExamGroupWidget(
                            exam: exam,
                            onToggle: () => _toggleExam(exam.id),
                            onToggleTopic: (topicId) =>
                                _toggleTopic(exam.id, topicId),
                          );
                        }).toList(),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),

            StartFooter(
              onStart: _handleStartStudying,
              showWarning: _showWarning,
            ),
          ],
        ),
      ),
    );
  }
}
