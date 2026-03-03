import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/exams')) return 1;
    if (location.startsWith('/timer-select')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex(context),
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.primary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined, size: 22),
              activeIcon: Icon(Icons.dashboard, size: 22),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined, size: 22),
              activeIcon: Icon(Icons.description, size: 22),
              label: 'Exams',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined, size: 22),
              activeIcon: Icon(Icons.timer, size: 22),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded, size: 22),
              activeIcon: Icon(Icons.person_rounded, size: 22),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/dashboard');
                break;
              case 1:
                context.go('/exams');
                break;
              case 2:
                context.go('/timer-select');
                break;
              case 3:
                context.go('/profile');
                break;
            }
          },
        ),
      ),
    );
  }
}
