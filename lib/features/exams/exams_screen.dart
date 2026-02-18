import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bar_widget.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/progress_card.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

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
              Text('My Exams', style: AppTextStyles.h1),
              const SizedBox(height: 20),
              
              // Exams List
              GestureDetector(
                onTap: () {
                  context.pushNamed('exam-details', extra: {
                    'examName': 'Physics II',
                    'examDate': 'Jan 29, 2026',
                    'progress': 0.3,
                    'topics': ['Kinematics', 'Dynamics'],
                  });
                },
                child: const ProgressCard(
                  title: 'Physics II',
                  subtitle: 'Exam: Jan 29, 2026',
                  progress: 0.3,
                  percentageText: '30%',
                ),
              ),
              const SizedBox(height: 12),
              
              GestureDetector(
                onTap: () {
                  context.pushNamed('exam-details', extra: {
                    'examName': 'Organic Chem',
                    'examDate': 'Feb 15th',
                    'progress': 0.7,
                    'topics': ['Reactions', 'Mechanisms'],
                  });
                },
                child: const ProgressCard(
                  title: 'Organic Chem',
                  subtitle: 'Exam: Feb 15th',
                  progress: 0.7,
                  percentageText: '70%',
                ),
              ),
              const SizedBox(height: 12),
              
              GestureDetector(
                onTap: () {
                  context.pushNamed('exam-details', extra: {
                    'examName': 'Swvars II',
                    'examDate': 'Jan 29, 2026',
                    'progress': 0.2,
                    'topics': ['Topic A', 'Topic B'],
                  });
                },
                child: const ProgressCard(
                  title: 'Swvars II',
                  subtitle: 'Exam: Jan 29, 2026',
                  progress: 0.2,
                  percentageText: '20%',
                ),
              ),
              const SizedBox(height: 12),
              
              GestureDetector(
                onTap: () {
                  context.pushNamed('exam-details', extra: {
                    'examName': 'Reewable Energy',
                    'examDate': 'Feb 14th',
                    'progress': 0.2,
                    'topics': ['Sustainability', 'Wind Power'],
                  });
                },
                child: const ProgressCard(
                  title: 'Reewable Energy',
                  subtitle: 'Exam: Feb 14th',
                  progress: 0.2,
                  percentageText: '20%',
                ),
              ),
              
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add-exam');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}