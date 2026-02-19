import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class EditFields extends StatelessWidget {
  final TextEditingController examNameController;
  final TextEditingController subjectController;
  final TextEditingController dateController;

  const EditFields({
    Key? key,
    required this.examNameController,
    required this.subjectController,
    required this.dateController,
  }) : super(key: key);

  InputDecoration _decoration({required String hint, Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.body.copyWith(fontSize: 16, color: AppColors.textSecondary),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: prefix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Exam Name', style: AppTextStyles.h3.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: examNameController,
          style: AppTextStyles.body.copyWith(fontSize: 16, color: AppColors.textPrimary),
          decoration: _decoration(hint: 'e.g., Physics Midterm'),
        ),
        const SizedBox(height: 20),
        Text('Subject', style: AppTextStyles.h3.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: subjectController,
          style: AppTextStyles.body.copyWith(fontSize: 16, color: AppColors.textPrimary),
          decoration: _decoration(hint: 'e.g., Physics'),
        ),
        const SizedBox(height: 20),
        Text('Date', style: AppTextStyles.h3.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: dateController,
          style: AppTextStyles.body.copyWith(fontSize: 16, color: AppColors.textPrimary),
          decoration: _decoration(hint: 'Feb 20, 2024', prefix: const Icon(Icons.calendar_today, color: Color(0xFF2A7FF7), size: 20)),
        ),
      ],
    );
  }
}
