import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isError ? AppColors.white : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError
            ? AppColors.error
            : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSizes.lg),
        duration: duration,
        elevation: AppSizes.elevationMd,
      ),
    );
  }
}