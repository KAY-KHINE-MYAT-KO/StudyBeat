import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'exam_fields.dart';

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
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: examNameController,
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
        const SizedBox(height: 20),
        Text(
          'Subject',
          style: AppTextStyles.h3.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: subjectController,
          style: AppTextStyles.body.copyWith(fontSize: 16),
          decoration: buildExamFieldDecoration(hintText: 'e.g. Physics'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter subject';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        Text(
          'Date',
          style: AppTextStyles.h3.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: dateController,
          readOnly: true,
          style: AppTextStyles.body.copyWith(fontSize: 16),
          decoration: buildExamFieldDecoration(
            hintText: 'Feb 20, 2024',
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: AppColors.accent,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
