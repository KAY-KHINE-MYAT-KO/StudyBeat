import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';

class ExamsBottomNav extends StatelessWidget {
  const ExamsBottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE5E7EB), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () => context.go('/dashboard'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.dashboard_outlined, color: const Color(0xFF9CA3AF), size: 22),
                    const SizedBox(height: 2),
                    Text('Dashboard', style: AppTextStyles.caption.copyWith(fontSize: 10, color: const Color(0xFF9CA3AF))),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => context.go('/exams'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.description_outlined, color: const Color(0xFF2A7FF7), size: 22),
                    const SizedBox(height: 2),
                    Text('Exams', style: AppTextStyles.caption.copyWith(fontSize: 10, color: const Color(0xFF2A7FF7))),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => context.go('/timer-select'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, color: const Color(0xFF9CA3AF), size: 22),
                    const SizedBox(height: 2),
                    Text('Timer', style: AppTextStyles.caption.copyWith(fontSize: 10, color: const Color(0xFF9CA3AF))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
