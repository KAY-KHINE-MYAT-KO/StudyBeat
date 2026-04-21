import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'exam_fields.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DatePickerField({Key? key, required this.selectedDate, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: IgnorePointer(
        child: TextFormField(
          decoration: buildExamFieldDecoration(
            hintText: 'Select date',
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: AppColors.accent,
              size: 20,
            ),
          ),
          controller: TextEditingController(
            text: selectedDate == null
                ? ''
                : DateFormat('MMM d, yyyy').format(selectedDate!),
          ),
          style: AppTextStyles.body.copyWith(fontSize: 16),
        ),
      ),
    );
  }
}
