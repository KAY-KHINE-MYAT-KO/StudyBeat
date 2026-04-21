import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();
    final displayName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : 'StudyBeat User';
    final email = user?.email ?? 'No email available';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: AppTextStyles.appBarTitle.copyWith(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardShell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Profile',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary,
                                AppColors.accent.withOpacity(0.95),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.18),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _initials(user),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: AppTextStyles.h1.copyWith(
                                  fontSize: 24,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                email,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: AppColors.accent.withOpacity(0.18),
                                  ),
                                ),
                                child: Text(
                                  'Account active',
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Manage your account details and privacy settings from here.',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionHeader(label: 'Account'),
              _CardShell(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _ProfileTile(
                      icon: Icons.person_outline_rounded,
                      label: 'Display Name',
                      trailing: Text(
                        displayName,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
                      ),
                    ),
                    const _Divider(),
                    _ProfileTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      trailing: Text(
                        email,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionHeader(label: 'Actions'),
              _CardShell(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _ProfileTile(
                      icon: Icons.logout_rounded,
                      label: 'Log Out',
                      iconColor: AppColors.primary,
                      onTap: () => _confirmLogout(context, authService),
                    ),
                    const _Divider(),
                    _ProfileTile(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete Account',
                      labelColor: AppColors.error,
                      iconColor: AppColors.error,
                      onTap: () => _confirmDeleteAccount(context, authService),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(User? user) {
    final name = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : (user?.email ?? 'S');
    final parts = name.split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  void _confirmLogout(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Log Out',
          style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: AppTextStyles.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await authService.signOut();
              if (context.mounted) context.go('/welcome');
            },
            child: Text(
              'Log Out',
              style: AppTextStyles.button.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, AuthService authService) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Account',
          style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This action is permanent and cannot be undone. Enter your password to confirm.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Your password',
                hintStyle: const TextStyle(color: AppColors.textLight),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              passwordController.dispose();
            },
            child: Text(
              'Cancel',
              style: AppTextStyles.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final password = passwordController.text;
              Navigator.of(ctx).pop();
              passwordController.dispose();
              try {
                await authService.deleteAccount(password: password);
                if (context.mounted) context.go('/welcome');
              } on FirebaseAuthException catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AuthService.getErrorMessage(e)),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(
              'Delete',
              style: AppTextStyles.button.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    ).then((_) => passwordController.dispose());
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _CardShell({
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color labelColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.label,
    this.iconColor = AppColors.textSecondary,
    this.labelColor = AppColors.textPrimary,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 21),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
              if (trailing == null && onTap != null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textLight,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 1,
      color: AppColors.border,
    );
  }
}
