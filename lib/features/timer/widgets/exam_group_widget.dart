import 'package:flutter/material.dart';
import '../models/timer_models.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import 'topic_item.dart';

class ExamGroupWidget extends StatelessWidget {
  final ExamGroup exam;
  final VoidCallback onToggle;
  final void Function(int) onToggleTopic;

  const ExamGroupWidget({Key? key, required this.exam, required this.onToggle, required this.onToggleTopic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(exam.name, style: AppTextStyles.h2.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Icon(exam.expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
        if (exam.expanded)
          Column(
            children: exam.topics.map((topic) {
              return TopicItem(topic: topic, onTap: () => onToggleTopic(topic.id));
            }).toList(),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
