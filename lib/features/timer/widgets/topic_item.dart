import 'package:flutter/material.dart';
import '../models/timer_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TopicItem extends StatelessWidget {
  final TimerTopic topic;
  final VoidCallback onTap;

  const TopicItem({
    Key? key,
    required this.topic,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = topic.selected
        ? AppColors.accent.withOpacity(0.10)
        : AppColors.background;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: topic.selected
                    ? AppColors.accent
                    : AppColors.border,
                width: topic.selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: topic.selected ? AppColors.accent : Colors.white,
                    border: Border.all(
                      color: topic.selected
                          ? AppColors.accent
                          : AppColors.textLight,
                      width: 2,
                    ),
                  ),
                  child: topic.selected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    topic.name,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 16,
                      fontWeight: topic.selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: topic.selected
                      ? AppColors.accent
                      : AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
