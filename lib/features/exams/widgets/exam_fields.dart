import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

InputDecoration buildExamFieldDecoration({
  required String hintText,
  Widget? prefixIcon,
  String? suffixText,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: AppTextStyles.body.copyWith(
      fontSize: 16,
      color: AppColors.textSecondary,
    ),
    filled: true,
    fillColor: Colors.white,
    prefixIcon: prefixIcon,
    suffixText: suffixText,
    suffixStyle: AppTextStyles.bodySmall.copyWith(
      fontSize: 14,
      color: AppColors.textSecondary,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.accent, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}

class ExamNameField extends StatelessWidget {
  final TextEditingController controller;

  const ExamNameField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exam Name',
          style: AppTextStyles.h3.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: AppTextStyles.body.copyWith(fontSize: 16),
          decoration: buildExamFieldDecoration(
            hintText: 'e.g. Physics Midterm',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter exam name';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class SubjectField extends StatelessWidget {
  final TextEditingController controller;

  const SubjectField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject',
          style: AppTextStyles.h3.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: AppTextStyles.body.copyWith(fontSize: 16),
          decoration: buildExamFieldDecoration(
            hintText: 'e.g. Physics',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter subject';
            }
            return null;
          },
        ),
      ],
    );
  }
}
