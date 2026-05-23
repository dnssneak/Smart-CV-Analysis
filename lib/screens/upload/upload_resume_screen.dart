import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/snackbar.dart';
import '../../providers/upload_provider.dart';
import '../../providers/analysis_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_textfield.dart';
import '../../widgets/common/lottie_loading_overlay.dart';
import '../../widgets/upload/upload_box.dart';
import '../../widgets/upload/file_preview.dart';
import '../../widgets/upload/upload_progress.dart';
import '../analysis/analysis_result_screen.dart';

class UploadResumeScreen extends StatefulWidget {
  const UploadResumeScreen({super.key});

  @override
  State<UploadResumeScreen> createState() => _UploadResumeScreenState();
}

class _UploadResumeScreenState extends State<UploadResumeScreen> {
  final _manualTextController = TextEditingController();
  final _jobTitleController = TextEditingController();
  bool _showManualInput = false;

  @override
  void dispose() {
    _manualTextController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => UploadProvider(),
      child: Consumer<AnalysisProvider>(
        builder: (context, analysisProvider, _) {
          final isAnalyzing = analysisProvider.state == AnalysisState.loading;
          return Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.uploadResume),
              elevation: 0,
            ),
            body: Consumer<UploadProvider>(
              builder: (context, uploadProvider, child) {
                return Stack(
                  children: [
                    SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSizes.xxl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload your resume',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSizes.xs),
                            Text(
                              'We accept PDF and DOCX files',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSizes.xxl),
                            CustomTextField(
                              label: AppStrings.targetJobTitle,
                              hint: AppStrings.jobTitleHint,
                              controller: _jobTitleController,
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: AppSizes.xxxl),
                            if (uploadProvider.state == UploadState.picking ||
                                uploadProvider.state == UploadState.extracting) ...[
                              const Center(
                                child: UploadProgress(
                                  message: 'Processing file...',
                                ),
                              ),
                            ] else if (uploadProvider.hasFile) ...[
                              FilePreview(
                                fileName: uploadProvider.fileName,
                                fileSize: uploadProvider.fileSize,
                                onRemove: () => uploadProvider.clearFile(),
                              ),
                            ] else ...[
                              UploadBox(
                                onTap: () => uploadProvider.pickFile(),
                              ),
                            ],
                            const SizedBox(height: AppSizes.xxl),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: theme.colorScheme.outline.withOpacity(0.3),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.md,
                                  ),
                                  child: Text(
                                    'or',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: theme.colorScheme.outline.withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.xxl),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showManualInput = !_showManualInput;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _showManualInput
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: AppSizes.xs),
                                  Text(
                                    _showManualInput
                                        ? 'Hide text input'
                                        : 'Paste resume text manually',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_showManualInput) ...[
                              const SizedBox(height: AppSizes.lg),
                              CustomTextField(
                                label: 'Resume Text',
                                hint: 'Paste your resume content here...',
                                controller: _manualTextController,
                                maxLines: 10,
                                onChanged: (text) => uploadProvider.setManualText(text),
                              ),
                            ],
                            const SizedBox(height: AppSizes.xxxl),
                            CustomButton(
                              text: AppStrings.startAnalysis,
                              isLoading: isAnalyzing,
                              onPressed:
                                  (uploadProvider.hasText || uploadProvider.hasFile) &&
                                          _jobTitleController.text.trim().isNotEmpty &&
                                          !isAnalyzing
                                      ? () => _startAnalysis(context, uploadProvider)
                                      : null,
                            ),
                            const SizedBox(height: AppSizes.xxl),
                          ],
                        ),
                      ),
                    ),
                    // Full-screen Lottie overlay during AI analysis
                    if (isAnalyzing)
                      const LottieLoadingOverlay(
                        message: 'Our AI is scanning your resume...\nThis may take a moment.',
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _startAnalysis(BuildContext context, UploadProvider uploadProvider) {
    final text = uploadProvider.getResumeText();
    if (text.trim().isEmpty) {
      AppSnackbar.show(
        context,
        message: 'Please upload a file or paste resume text',
        isError: true,
      );
      return;
    }

    final targetJobTitle = _jobTitleController.text.trim();
    if (targetJobTitle.isEmpty) {
      AppSnackbar.show(
        context,
        message: AppStrings.jobTitleRequired,
        isError: true,
      );
      return;
    }

    final analysisProvider =
        Provider.of<AnalysisProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.user == null) {
      AppSnackbar.show(
        context,
        message: 'Please login first',
        isError: true,
      );
      return;
    }

    analysisProvider
        .analyzeResume(
      text,
      resumeName: uploadProvider.fileName.isNotEmpty
          ? uploadProvider.fileName
          : 'Manual Entry',
      targetJobTitle: targetJobTitle,
      userId: authProvider.user!.uid,
    )
        .then((_) {
      if (analysisProvider.state == AnalysisState.success && context.mounted) {
        uploadProvider.reset();
        _jobTitleController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AnalysisResultScreen(),
          ),
        );
      } else if (analysisProvider.state == AnalysisState.error &&
          context.mounted) {
        AppSnackbar.show(
          context,
          message: analysisProvider.errorMessage ?? 'Analysis failed',
          isError: true,
        );
      }
    });
  }
}
