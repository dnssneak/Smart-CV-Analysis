import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/analysis_provider.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/analysis/ats_score_card.dart';
import '../../widgets/analysis/strengths_section.dart';
import '../../widgets/analysis/weakness_section.dart';
import '../../widgets/analysis/suggestions_section.dart';
import '../../widgets/analysis/skills_section.dart';
import '../../widgets/analysis/roles_section.dart';

class AnalysisResultScreen extends StatelessWidget {
  const AnalysisResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Analysis Results',
        showBackButton: true,
      ),
      body: Consumer<AnalysisProvider>(
        builder: (context, analysisProvider, child) {
          if (analysisProvider.isLoading) {
            return const LoadingWidget(message: 'Analyzing your resume...');
          }

          if (analysisProvider.currentAnalysis == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'No analysis available',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Upload a resume to get started',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            );
          }

          final analysis = analysisProvider.currentAnalysis!;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: AppSizes.iconMd,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Text(
                              analysis.resumeName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),
                      AtsScoreCard(score: analysis.atsScore),
                      const SizedBox(height: AppSizes.xxxl),
                      if (analysis.summary != null) ...[
                        Container(
                          padding: const EdgeInsets.all(AppSizes.lg),
                          decoration: BoxDecoration(
                            color: AppColors.oceanBlue.withOpacity(0.05),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMd),
                            border: Border.all(
                              color: AppColors.oceanBlue.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.oceanBlue,
                                size: AppSizes.iconMd,
                              ),
                              const SizedBox(width: AppSizes.sm),
                              Expanded(
                                child: Text(
                                  analysis.summary!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.oceanBlue,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.xxxl),
                      ],
                      StrengthsSection(strengths: analysis.strengths),
                      const SizedBox(height: AppSizes.md),
                      WeaknessSection(weaknesses: analysis.weaknesses),
                      const SizedBox(height: AppSizes.md),
                      SuggestionsSection(suggestions: analysis.suggestions),
                      const SizedBox(height: AppSizes.md),
                      SkillsSection(missingSkills: analysis.missingSkills),
                      const SizedBox(height: AppSizes.xxxl),
                      RolesSection(roles: analysis.recommendedRoles),
                      const SizedBox(height: AppSizes.xxxl),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved to history'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save to History'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: AppColors.white,
                          minimumSize: const Size(
                              double.infinity, AppSizes.buttonHeight),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMd),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.xxl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
