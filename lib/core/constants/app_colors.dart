import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette (from your design system)
  static const Color black = Color(0xFF000000);
  static const Color deepTeal = Color(0xFF003B4D);
  static const Color oceanBlue = Color(0xFF005F73);
  static const Color softBlue = Color(0xFF4F9CB5);
  static const Color skyBlue = Color(0xFF8BC7DE);
  static const Color lightBlue = Color(0xFFC7E6F2);
  static const Color white = Color(0xFFFFFFFF);

  // Light Mode
  static const Color lightBackground = white;
  static const Color lightSurface = Color(0xFFEEF2F6);
  static const Color lightCard = Color(0xFFF1F3F5);
  static const Color lightBorder = Color(0xFFE8EDF2);
  static const Color lightTextPrimary = black;
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);

  // Dark Mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF252525);
  static const Color darkBorder = Color(0xFF2D2D2D);
  static const Color darkTextPrimary = white;
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextTertiary = Color(0xFF808080);

  // Functional Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = oceanBlue;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [oceanBlue, softBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [deepTeal, oceanBlue, softBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}