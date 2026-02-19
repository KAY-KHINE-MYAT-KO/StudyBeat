import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class ExamActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onStudyNow;
  final bool canStudy;

  const ExamActions({Key? key, required this.onEdit, required this.onDelete, required this.onStudyNow, required this.canStudy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onEdit,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2A7FF7),
                  side: const BorderSide(color: Color(0xFF2A7FF7), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white,
                ),
                child: Text('Edit Exam', style: AppTextStyles.button.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF2A7FF7))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: onDelete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: const BorderSide(color: Color(0xFFEF4444), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white,
                ),
                child: Text('Delete Exam', style: AppTextStyles.button.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canStudy ? onStudyNow : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A7FF7),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: const Color(0xFF2A7FF7).withOpacity(0.3),
            ),
            child: Text('Study Now', style: AppTextStyles.button.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
