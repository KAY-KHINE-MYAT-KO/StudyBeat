import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CircularProgressWidget extends StatelessWidget {
  final int percentage;
  final String label;
  final String subtitle;
  final String helperText;

  const CircularProgressWidget({
    super.key,
    required this.percentage,
    required this.label,
    required this.subtitle,
    this.helperText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.accent.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.18),
                      Colors.white,
                    ],
                    stops: const [0.15, 1.0],
                  ),
                ),
              ),
              SizedBox(
                width: 196,
                height: 196,
                child: CustomPaint(
                  painter: CircularProgressPainter(
                    progress: percentage / 100,
                    progressColor: AppColors.accent,
                    backgroundColor: AppColors.border,
                  ),
                  child: Center(
                    child: Container(
                      width: 142,
                      height: 142,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.07),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: percentage.toString(),
                              style: AppTextStyles.percentage.copyWith(
                                fontSize: 40,
                              ),
                              children: [
                                TextSpan(
                                  text: '%',
                                  style: AppTextStyles.h1.copyWith(
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Ready',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (helperText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              helperText,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;

  CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
