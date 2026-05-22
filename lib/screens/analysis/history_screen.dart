import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/analysis_provider.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/dashboard/recent_analysis_card.dart';
import 'analysis_result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });
  }

  Future<void> _loadHistory() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final analysisProvider =
        Provider.of<AnalysisProvider>(context, listen: false);

    if (authProvider.user != null) {
      await analysisProvider.loadHistory(authProvider.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Analysis History',
        showBackButton: true,
      ),
      body: Consumer<AnalysisProvider>(
        builder: (context, analysisProvider, child) {
          if (analysisProvider.isLoadingHistory) {
            return const LoadingWidget(message: 'Loading history...');
          }

          if (analysisProvider.analysisHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'No history yet',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Analyze your first resume to see it here',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadHistory,
            color: AppColors.oceanBlue,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.xxl),
              itemCount: analysisProvider.analysisHistory.length,
              itemBuilder: (context, index) {
                final analysis = analysisProvider.analysisHistory[index];
                return Dismissible(
                  key: Key(analysis.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSizes.lg),
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppColors.white,
                    ),
                  ),
                  onDismissed: (_) async {
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    await analysisProvider.deleteAnalysis(
                      authProvider.user!.uid,
                      analysis.id,
                    );
                  },
                  child: RecentAnalysisCard(
                    analysis: analysis,
                    onTap: () {
                      analysisProvider.setCurrentAnalysis(analysis);
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
            ),
          );
        },
      ),
    );
  }
}
