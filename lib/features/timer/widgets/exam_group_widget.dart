import 'package:flutter/material.dart';
import '../models/timer_models.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import 'topic_item.dart';

class ExamGroupWidget extends StatelessWidget {
  final ExamGroup exam;
  final VoidCallback onToggle;
  final void Function(int) onToggleTopic;

  const ExamGroupWidget({
    Key? key,
    required this.exam,
    required this.onToggle,
    required this.onToggleTopic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedCount = exam.topics.where((topic) => topic.selected).length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: exam.expanded
              ? AppColors.accent.withOpacity(0.28)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: exam.expanded
                          ? AppColors.accent.withOpacity(0.14)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: exam.expanded
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.name,
                          style: AppTextStyles.h2.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${exam.topics.length} topics • $selectedCount selected',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 13,
                            color: selectedCount > 0
                                ? AppColors.accent
                                : AppColors.textSecondary,
                            fontWeight: selectedCount > 0
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: exam.expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (exam.expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                children: exam.topics.map((topic) {
                  return TopicItem(
                    topic: topic,
                    onTap: () => onToggleTopic(topic.id),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
