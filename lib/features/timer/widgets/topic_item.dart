import 'package:flutter/material.dart';
import '../models/timer_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TopicItem extends StatelessWidget {
  final TimerTopic topic;
  final VoidCallback onTap;

  const TopicItem({Key? key, required this.topic, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: topic.selected ? AppColors.accent : Colors.transparent, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              topic.selected
                  ? const Icon(Icons.check_circle, color: AppColors.accent, size: 24)
                  : Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD1D5DB), width: 2)),
                    ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  topic.name,
                  style: AppTextStyles.body.copyWith(fontSize: 16, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
