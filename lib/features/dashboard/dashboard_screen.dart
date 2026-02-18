import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bar_widget.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/widgets/progress_card.dart';
import 'widgets/circular_progress_widget.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'StudyBeat'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card - FULL WIDTH
              Card(
                child: Container(
                  width: double.infinity, // Make it full width
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Hi there, ready to final your exams!',
                    style: AppTextStyles.caption,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Circular Progress - CENTERED
              Center(
                child: const CircularProgressWidget(
                  percentage: 75,
                  label: 'READY',
                  subtitle: 'Your Overall Study Readiness',
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Stats Cards
              Row(
                children: const [
                  Expanded(
                    child: StatCard(
                      label: 'Studied',
                      value: '2h 15m',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Sessions',
                      value: '3 Today',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Upcoming Exams Section
              Text('Upcoming Exams', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              
              const ProgressCard(
                title: 'Physics II',
                subtitle: 'Exam: Jan 29, 2026',
                progress: 0.3,
                percentageText: '30%',
              ),
              
              const SizedBox(height: 12),
              
              const ProgressCard(
                title: 'Organic Chem',
                subtitle: 'Exam: Feb 15th',
                progress: 0.7,
                percentageText: '70%',
              ),
              
              const SizedBox(height: 12),
              
              const ProgressCard(
                title: 'Swvars II',
                subtitle: 'Exam: Jan 29, 2026',
                progress: 0.2,
                percentageText: '20%',
              ),
              
              const SizedBox(height: 12),
              
              const ProgressCard(
                title: 'Reewable Energy',
                subtitle: 'Exam: Feb 14th',
                progress: 0.2,
                percentageText: '20%',
              ),
              
              const SizedBox(height: 24),
              
              // Bottom Buttons
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Add Exam',
                      onPressed: () {
                        context.pushNamed('add-exam');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Start Now',
                      onPressed: () {
                        context.go('/timer-select');
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
