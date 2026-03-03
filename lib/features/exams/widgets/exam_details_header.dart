import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ExamDetailsHeader extends StatelessWidget {
  final String examName;
  final String examDate;
  final int progress;
  final int completedTopics;
  final int totalTopics;

  const ExamDetailsHeader({
    Key? key,
    required this.examName,
    required this.examDate,
    required this.progress,
    required this.completedTopics,
    required this.totalTopics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          examName,
          style: AppTextStyles.h1.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$examDate, 2024 • $progress% Ready',
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
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
            const SizedBox(height: 24),
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
          ],
        ),
      ],
    );
  }
}
