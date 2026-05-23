import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/common/custom_appbar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Privacy Policy',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.xl),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.oceanBlue.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.white,
                        size: AppSizes.iconXl,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      'Your Privacy is Our Priority',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      'Last Updated: May 2026',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xxxl),

              Text(
                'Information Policy',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              _buildPolicySection(
                context,
                icon: Icons.person_search_outlined,
                title: '1. Information We Collect',
                content: 'We collect information you provide directly to us when using Smart CV Analysis. This includes your account name, email address, password hash, target job titles, and any resume text or uploaded documents (e.g., PDFs) that you submit for analysis.',
              ),
              const SizedBox(height: AppSizes.lg),

              _buildPolicySection(
                context,
                icon: Icons.psychology_outlined,
                title: '2. How We Use AI & Data',
                content: 'Your resume data is processed securely through advanced AI models to provide feedback on ATS score, strengths, weaknesses, and recommended job roles. We do not use your resumes or personal information to train public models, nor do we share them with third-party advertisers.',
              ),
              const SizedBox(height: AppSizes.lg),

              _buildPolicySection(
                context,
                icon: Icons.lock_outline,
                title: '3. Data Security & Storage',
                content: 'We use industry-standard encryption protocols (HTTPS/SSL) to secure your data in transit and at rest. Your profile and historical analyses are stored securely via Google Cloud/Firebase services, and access is strictly limited to authorized sessions.',
              ),
              const SizedBox(height: AppSizes.lg),

              _buildPolicySection(
                context,
                icon: Icons.delete_sweep_outlined,
                title: '4. Data Retention & Deletion',
                content: 'You retain full ownership of your data. You can delete individual resume analysis results from your history screen at any time, or permanently delete your account through our settings panel, which will wipe all associated data.',
              ),
              const SizedBox(height: AppSizes.lg),

              _buildPolicySection(
                context,
                icon: Icons.contact_support_outlined,
                title: '5. Contact Us',
                content: 'If you have any questions, concerns, or requests regarding this Privacy Policy, please reach out to our privacy department at privacy@smartcvanalysis.com.',
              ),
              const SizedBox(height: AppSizes.xxxl),

              // Footer branding
              Center(
                child: Text(
                  'Smart CV Analysis © 2026',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: AppSizes.iconMd,
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
