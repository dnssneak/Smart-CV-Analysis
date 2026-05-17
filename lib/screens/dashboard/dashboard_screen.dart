import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/dashboard/ats_score_card.dart';
import '../../widgets/dashboard/recent_analysis_card.dart';
import '../../widgets/dashboard/recommendation_card.dart';
import '../upload/upload_resume_screen.dart';
import '../analysis/analysis_result_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).loadMockData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, child) {
              if (dashboardProvider.isLoading) {
                return const LoadingWidget(message: 'Loading dashboard...');
              }

              return CustomScrollView(
                slivers: [
                  // App Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.xxl),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppStrings.welcome},',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: AppSizes.xs),
                                Text(
                                  user?.displayName ?? 'User',
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to profile
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.oceanBlue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: AppColors.oceanBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ATS Score Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.xxl,
                      ),
                      child: AtsScoreCard(
                        score: dashboardProvider.latestAnalysis?.atsScore ?? 0,
                        onTap: () {
                          if (dashboardProvider.latestAnalysis != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AnalysisResultScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.xxxl),
                  ),

                  // Quick Actions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.xxl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSizes.lg),
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionCard(
                                  context,
                                  icon: Icons.upload_file_rounded,
                                  label: 'Upload Resume',
                                  color: AppColors.oceanBlue,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const UploadResumeScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: AppSizes.lg),
                              Expanded(
                                child: _buildActionCard(
                                  context,
                                  icon: Icons.history_rounded,
                                  label: 'View History',
                                  color: AppColors.softBlue,
                                  onTap: () {
                                    // Navigate to history
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.xxxl),
                  ),

                  // Recent Analysis
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.xxl,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.recentAnalysis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xxl,
                      vertical: AppSizes.lg,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final analysis = dashboardProvider.recentAnalyses[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSizes.md,
                            ),
                            child: RecentAnalysisCard(
                              analysis: analysis,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AnalysisResultScreen(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        childCount: dashboardProvider.recentAnalyses.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.lg),
                  ),

                  // Career Suggestions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.xxl,
                      ),
                      child: Text(
                        AppStrings.careerSuggestions,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 140,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.xxl,
                          vertical: AppSizes.lg,
                        ),
                        children: const [
                          RecommendationCard(
                            role: 'Flutter Developer',
                            description: 'High demand in mobile development',
                            icon: Icons.phone_android_rounded,
                          ),
                          RecommendationCard(
                            role: 'AI Engineer',
                            description: 'Growing field with top salaries',
                            icon: Icons.psychology_rounded,
                          ),
                          RecommendationCard(
                            role: 'Cybersecurity Analyst',
                            description: 'Critical role in tech industry',
                            icon: Icons.security_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.xxl),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
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
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                icon,
                color: color,
                size: AppSizes.iconLg,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}