import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class EditTopics extends StatelessWidget {
  final List<TextEditingController> topicControllers;
  final VoidCallback onAddTopic;

  const EditTopics({Key? key, required this.topicControllers, required this.onAddTopic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Topics', style: AppTextStyles.h3.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        ...topicControllers.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: entry.value,
              style: AppTextStyles.body.copyWith(fontSize: 16, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Type a topic...',
                hintStyle: AppTextStyles.body.copyWith(fontSize: 16, color: AppColors.textSecondary),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Center(
                    widthFactor: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2A7FF7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
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
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onAddTopic,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2A7FF7),
              side: const BorderSide(color: Color(0xFF2A7FF7), width: 2, style: BorderStyle.solid),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: Colors.white,
            ),
            child: Text('+ Add Another Topic', style: AppTextStyles.button.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF2A7FF7))),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
