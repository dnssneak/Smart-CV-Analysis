import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class RolesSection extends StatelessWidget {
  final List<String> roles;

  const RolesSection({
    super.key,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.work_outline,
              color: AppColors.oceanBlue,
              size: AppSizes.iconMd,
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              'Recommended Roles',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: roles.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: AppSizes.md),
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
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.oceanBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: const Icon(
                        Icons.business_center_outlined,
                        color: AppColors.oceanBlue,
                        size: AppSizes.iconMd,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      roles[index],
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
