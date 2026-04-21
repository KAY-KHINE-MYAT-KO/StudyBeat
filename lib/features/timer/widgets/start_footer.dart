import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class StartFooter extends StatelessWidget {
  final VoidCallback onStart;
  final bool showWarning;
  final int selectedCount;

  const StartFooter({
    Key? key,
    required this.onStart,
    required this.showWarning,
    required this.selectedCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canStart = selectedCount > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: canStart
                      ? AppColors.accent.withOpacity(0.12)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: canStart ? AppColors.accent : AppColors.textLight,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      canStart
                          ? '$selectedCount topic${selectedCount == 1 ? '' : 's'} ready'
                          : 'Choose one topic',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      canStart
                          ? 'Start your focused study session for this topic.'
                          : 'Your timer will start after you choose one topic.',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: canStart
                    ? AppColors.primary
                    : AppColors.textLight,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: canStart ? 4 : 0,
                shadowColor: AppColors.primary.withOpacity(0.25),
              ),
              child: Text(
                canStart ? 'Start Studying' : 'Select Topics First',
                style: AppTextStyles.button.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (showWarning)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Please choose one topic to start studying.',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 14,
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
