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
  bool _showManualInput = false;

  @override
  void dispose() {
    _manualTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => UploadProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.uploadResume),
          elevation: 0,
        ),
        body: Consumer<UploadProvider>(
          builder: (context, uploadProvider, child) {
            return SafeArea(
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
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
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
                      isLoading: uploadProvider.state == UploadState.analyzing,
                      onPressed:
                          uploadProvider.hasText || uploadProvider.hasFile
                              ? () => _startAnalysis(context, uploadProvider)
                              : null,
                    ),
                    const SizedBox(height: AppSizes.xxl),
                  ],
                ),
              ),
            );
          },
        ),
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
      userId: authProvider.user!.uid,
    )
        .then((_) {
      if (analysisProvider.state == AnalysisState.success && context.mounted) {
        uploadProvider.reset();
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
