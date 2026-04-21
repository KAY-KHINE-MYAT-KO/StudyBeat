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

  int get _selectedTopicCount => _examGroups
      .expand((exam) => exam.topics)
      .where((topic) => topic.selected)
      .length;

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
      for (final exam in _examGroups) {
        for (final topic in exam.topics) {
          final isTarget = exam.id == examId && topic.id == topicId;
          if (isTarget) {
            topic.selected = !topic.selected;
          } else {
            topic.selected = false;
          }
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Timer',
          style: AppTextStyles.appBarTitle.copyWith(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.06),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
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
                                'Study session',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Select topics to focus on',
                              style: AppTextStyles.h1.copyWith(
                                fontSize: 26,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Choose one topic from your exams, then start a focused study timer built around that session.',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 15,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                _InfoChip(
                                  icon: Icons.check_circle_outline_rounded,
                                  label: '$_selectedTopicCount selected',
                                  highlighted: _selectedTopicCount > 0,
                                ),
                                const SizedBox(width: 10),
                                _InfoChip(
                                  icon: Icons.menu_book_rounded,
                                  label: '${_examGroups.length} exams',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Choose your topics',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Expand an exam and tap the single topic you want to study in this session.',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 20),

                      // Exams List
                      if (_examGroups.isEmpty)
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
                                'No exams yet',
                                style: AppTextStyles.h2.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add an exam first so you can select topics and start a study session.',
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
              selectedCount: _selectedTopicCount,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = highlighted
        ? AppColors.accent.withOpacity(0.14)
        : AppColors.background;
    final foregroundColor = highlighted
        ? AppColors.accent
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: highlighted
              ? AppColors.accent.withOpacity(0.22)
              : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foregroundColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
