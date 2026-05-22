import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class SuggestionsSection extends StatelessWidget {
  final List<String> suggestions;

  const SuggestionsSection({
    super.key,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _buildSection(
      context,
      title: 'Suggestions',
      icon: Icons.lightbulb_outline,
      iconColor: AppColors.oceanBlue,
      children: suggestions.map((suggestion) {
        return _buildItem(
          context,
          text: suggestion,
          icon: Icons.arrow_forward_ios,
          iconColor: AppColors.oceanBlue,
        );
      }).toList(),
    );
  }
}

Widget _buildSection(
  BuildContext context, {
  required String title,
  required IconData icon,
  required Color iconColor,
  required List<Widget> children,
}) {
  final theme = Theme.of(context);

  return Container(
    margin: const EdgeInsets.only(bottom: AppSizes.lg),
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
            Icon(icon, color: iconColor, size: AppSizes.iconMd),
            const SizedBox(width: AppSizes.sm),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        ...children,
      ],
    ),
  );
}

Widget _buildItem(
  BuildContext context, {
  required String text,
  required IconData icon,
  required Color iconColor,
}) {
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.only(bottom: AppSizes.sm),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: AppSizes.iconSm,
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}
