import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.oceanBlue,
        onPrimary: AppColors.white,
        secondary: AppColors.softBlue,
        onSecondary: AppColors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        error: AppColors.error,
        onError: AppColors.white,
        outline: AppColors.lightBorder,
        surfaceContainerHighest: AppColors.lightCard,
      ),
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: _buildAppBarTheme(Brightness.light),
      cardTheme: _buildCardTheme(Brightness.light),
      inputDecorationTheme: _buildInputTheme(Brightness.light),
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.light),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.light),
      textButtonTheme: _buildTextButtonTheme(Brightness.light),
      bottomNavigationBarTheme: _buildBottomNavTheme(Brightness.light),
      dividerTheme: _buildDividerTheme(Brightness.light),
      chipTheme: _buildChipTheme(Brightness.light),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.oceanBlue,
        linearTrackColor: AppColors.lightBorder,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXl),
          ),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.skyBlue,
        onPrimary: AppColors.black,
        secondary: AppColors.softBlue,
        onSecondary: AppColors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        error: AppColors.error,
        onError: AppColors.white,
        outline: AppColors.darkBorder,
        surfaceContainerHighest: AppColors.darkCard,
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: _buildAppBarTheme(Brightness.dark),
      cardTheme: _buildCardTheme(Brightness.dark),
      inputDecorationTheme: _buildInputTheme(Brightness.dark),
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.dark),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.dark),
      textButtonTheme: _buildTextButtonTheme(Brightness.dark),
      bottomNavigationBarTheme: _buildBottomNavTheme(Brightness.dark),
      dividerTheme: _buildDividerTheme(Brightness.dark),
      chipTheme: _buildChipTheme(Brightness.dark),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.skyBlue,
        linearTrackColor: AppColors.darkBorder,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXl),
          ),
        ),
      ),
    );
  }

  // Text Theme
  static TextTheme _buildTextTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final baseTextTheme =
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;

    return GoogleFonts.poppinsTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.poppins(
        fontSize: AppSizes.text4xl,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: AppSizes.text3xl,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: AppSizes.text2xl,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: AppSizes.text2xl,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: AppSizes.textXl,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: AppSizes.textLg,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: AppSizes.textLg,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: AppSizes.textBase,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: AppSizes.textSm,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: AppSizes.textBase,
        fontWeight: FontWeight.normal,
        color: primaryColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: AppSizes.textSm,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: AppSizes.textXs,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: AppSizes.textSm,
        fontWeight: FontWeight.w500,
        color: primaryColor,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: AppSizes.textXs,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: AppSizes.textXs,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
    );
  }

  // AppBar Theme
  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      foregroundColor:
          isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: AppSizes.textLg,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
    );
  }

  // Card Theme
  static CardThemeData _buildCardTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return CardThemeData(
      elevation: AppSizes.elevationSm,
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
    );
  }

  // Input Decoration Theme
  static InputDecorationTheme _buildInputTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fillColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.oceanBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: AppSizes.textSm,
        color:
            isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: AppSizes.textSm,
        color:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
    );
  }

  // Elevated Button Theme
  static ElevatedButtonThemeData _buildElevatedButtonTheme(
      Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isDark ? AppColors.skyBlue : AppColors.oceanBlue,
        foregroundColor: isDark ? AppColors.black : AppColors.white,
        minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: AppSizes.textBase,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      ),
    );
  }

  // Outlined Button Theme
  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
      Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: isDark ? AppColors.skyBlue : AppColors.oceanBlue,
        side: BorderSide(
          color: isDark ? AppColors.skyBlue : AppColors.oceanBlue,
          width: 1.5,
        ),
        minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: AppSizes.textBase,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      ),
    );
  }

  // Text Button Theme
  static TextButtonThemeData _buildTextButtonTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: isDark ? AppColors.skyBlue : AppColors.oceanBlue,
        textStyle: GoogleFonts.poppins(
          fontSize: AppSizes.textSm,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
      ),
    );
  }

  // Bottom Navigation Theme
  static BottomNavigationBarThemeData _buildBottomNavTheme(
      Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return BottomNavigationBarThemeData(
      backgroundColor:
          isDark ? AppColors.darkSurface : AppColors.lightBackground,
      selectedItemColor: isDark ? AppColors.skyBlue : AppColors.oceanBlue,
      unselectedItemColor:
          isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: AppSizes.elevationSm,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: AppSizes.textXs,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: AppSizes.textXs,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Divider Theme
  static DividerThemeData _buildDividerTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return DividerThemeData(
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      thickness: 1,
      space: AppSizes.lg,
    );
  }

  // Chip Theme
  static ChipThemeData _buildChipTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ChipThemeData(
      backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      selectedColor: isDark ? AppColors.skyBlue : AppColors.oceanBlue,
      labelStyle: GoogleFonts.poppins(
        fontSize: AppSizes.textXs,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      secondaryLabelStyle: GoogleFonts.poppins(
        fontSize: AppSizes.textXs,
        fontWeight: FontWeight.w500,
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
    );
  }
}
