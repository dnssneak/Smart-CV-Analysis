import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/common/custom_appbar.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Help & Support',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Support Banner Card
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
                        Icons.contact_support_outlined,
                        color: AppColors.white,
                        size: AppSizes.iconXl,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      'How Can We Help You?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      'We are here to assist you 24/7',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xxxl),

              Text(
                'Frequently Asked Questions',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              _buildFaqItem(
                context,
                question: 'How does the ATS score calculation work?',
                answer: 'Our AI analyzes your resume text against modern applicant tracking system guidelines, evaluating section formatting, content clarity, keyword optimization, and layout parsing compatibility.',
              ),
              const SizedBox(height: AppSizes.md),

              _buildFaqItem(
                context,
                question: 'Is my resume data secure?',
                answer: 'Absolutely. We encrypt all data in transit and at rest. Your CV analyses are saved privately to your account and are never shared or sold to third parties.',
              ),
              const SizedBox(height: AppSizes.md),

              _buildFaqItem(
                context,
                question: 'What file types are supported?',
                answer: 'We currently support PDF files and direct copy-pasted resume text. Support for Word documents (.docx) will be rolled out in an upcoming update.',
              ),
              const SizedBox(height: AppSizes.md),

              _buildFaqItem(
                context,
                question: 'How do I delete my analysis history?',
                answer: 'Navigate to the "Analysis History" screen, swipe left on the card you wish to delete, and confirm. This permanently removes the analysis from our databases.',
              ),
              const SizedBox(height: AppSizes.xxxl),

              // Contact Card
              Text(
                'Still Need Help?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.md),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.xl),
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
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mail_outline_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSizes.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Support',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            'support@smartcvanalysis.com',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Email client launched (mock)'),
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    final theme = Theme.of(context);

    return ExpansionTile(
      title: Text(
        question,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      iconColor: theme.colorScheme.primary,
      collapsedIconColor: theme.colorScheme.onSurface.withOpacity(0.6),
      childrenPadding: const EdgeInsets.only(
        left: AppSizes.lg,
        right: AppSizes.lg,
        bottom: AppSizes.lg,
      ),
      expandedAlignment: Alignment.topLeft,
      shape: Border.all(color: Colors.transparent),
      collapsedShape: Border.all(color: Colors.transparent),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      collapsedBackgroundColor: theme.colorScheme.surfaceContainerHighest,
      clipBehavior: Clip.antiAlias,
      children: [
        Text(
          answer,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
