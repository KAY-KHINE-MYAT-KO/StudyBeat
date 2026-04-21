import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'exam_fields.dart';

class EditTopics extends StatelessWidget {
  final List<TextEditingController> topicControllers;
  final VoidCallback onAddTopic;

  const EditTopics({
    Key? key,
    required this.topicControllers,
    required this.onAddTopic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topics',
          style: AppTextStyles.h3.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Add the topics you want to track and study for this exam.',
          style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 14),
        ...topicControllers.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: entry.value,
              style: AppTextStyles.body.copyWith(fontSize: 16),
              decoration: buildExamFieldDecoration(
                hintText: 'Topic ${entry.key + 1}',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 8),
                  child: Center(
                    widthFactor: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onAddTopic,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: const BorderSide(color: AppColors.accent, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: AppColors.accent.withOpacity(0.04),
            ),
            child: Text(
              '+ Add Another Topic',
              style: AppTextStyles.button.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
