import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class FilePreview extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final VoidCallback onRemove;

  const FilePreview({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.onRemove,
  });

  IconData _getFileIcon(String name) {
    if (name.toLowerCase().endsWith('.pdf')) {
      return Icons.picture_as_pdf_rounded;
    } else if (name.toLowerCase().endsWith('.docx')) {
      return Icons.description_rounded;
    }
    return Icons.insert_drive_file_rounded;
  }

  Color _getFileColor(String name) {
    if (name.toLowerCase().endsWith('.pdf')) {
      return AppColors.error;
    } else if (name.toLowerCase().endsWith('.docx')) {
      return AppColors.oceanBlue;
    }
    return AppColors.softBlue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getFileColor(fileName).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(
              _getFileIcon(fileName),
              color: _getFileColor(fileName),
              size: AppSizes.iconLg,
            ),
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  fileSize,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.close_rounded,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              size: AppSizes.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}