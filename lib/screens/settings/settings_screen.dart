import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/theme_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/edit_profile_dialog.dart';
import '../../widgets/common/change_password_dialog.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.settings,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferences',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // Dark Mode
              _buildSettingTile(
                context,
                icon: Icons.dark_mode_outlined,
                title: AppStrings.darkMode,
                subtitle: 'Switch between light and dark theme',
                trailing: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (_) => themeProvider.toggleTheme(),
                      activeColor: AppColors.oceanBlue,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // Notifications
              Consumer<NotificationProvider>(
                builder: (context, notificationProvider, child) {
                  return _buildSettingTile(
                    context,
                    icon: Icons.notifications_outlined,
                    title: AppStrings.notifications,
                    subtitle: 'Receive analysis completion alerts',
                    trailing: Switch(
                      value: notificationProvider.notificationsEnabled,
                      onChanged: (value) {
                        notificationProvider.toggleNotifications(value);
                      },
                      activeColor: AppColors.oceanBlue,
                    ),
                    onTap: () {
                      notificationProvider.toggleNotifications(
                        !notificationProvider.notificationsEnabled,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppSizes.xxxl),

              Text(
                'Account',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              _buildSettingTile(
                context,
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Update name and email',
                onTap: () => EditProfileDialog.show(context),
              ),
              const SizedBox(height: AppSizes.md),

              _buildSettingTile(
                context,
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () => ChangePasswordDialog.show(context),
              ),
              const SizedBox(height: AppSizes.xxxl),

              Text(
                'About',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              _buildSettingTile(
                context,
                icon: Icons.info_outline,
                title: 'App Version',
                subtitle: '1.0.0',
                onTap: null,
              ),
              const SizedBox(height: AppSizes.md),

              _buildSettingTile(
                context,
                icon: Icons.policy_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy terms',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSizes.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: AppSizes.iconMd,
              ),
            ),
            const SizedBox(width: AppSizes.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
