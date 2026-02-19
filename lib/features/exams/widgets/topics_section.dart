import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TopicsSection extends StatelessWidget {
  final List<String> topics;
  final TextEditingController topicController;
  final VoidCallback onAddTopic;
  final void Function(int) onRemoveTopic;

  const TopicsSection({
    Key? key,
    required this.topics,
    required this.topicController,
    required this.onAddTopic,
    required this.onRemoveTopic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Topics', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: topicController,
                decoration: InputDecoration(
                  hintText: 'Enter topic name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                onSubmitted: (_) => onAddTopic(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onAddTopic,
              icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (topics.isNotEmpty)
          Column(
            children: List.generate(topics.length, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(topics[index], style: AppTextStyles.body),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.error, size: 20),
                      onPressed: () => onRemoveTopic(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }
}
