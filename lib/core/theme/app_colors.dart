import 'package:flutter/material.dart';

/// REJABON visual identity — indigo command + mint momentum + fire streaks.
class AppColors {
  AppColors._();

  // Brand core
  static const primary = Color(0xFF5B4DFF);
  static const primaryLight = Color(0xFFEDEBFF);
  static const primaryDark = Color(0xFF4338CA);
  static const secondary = Color(0xFF00D4AA);
  static const accent = Color(0xFF06B6D4);
  static const fire = Color(0xFFFF6B2C);
  static const gold = Color(0xFFFFB800);

  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  // Light surfaces
  static const lightBackground = Color(0xFFF5F6FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceElevated = Color(0xFFFAFBFE);
  static const lightTextPrimary = Color(0xFF0F0F1A);
  static const lightTextSecondary = Color(0xFF6B7280);
  static const lightTextTertiary = Color(0xFF9CA3AF);
  static const lightBorder = Color(0xFFE5E7EB);
  static const lightBorderSubtle = Color(0xFFF0F1F5);

  // Dark surfaces
  static const darkBackground = Color(0xFF09090F);
  static const darkSurface = Color(0xFF14141F);
  static const darkSurfaceElevated = Color(0xFF1C1C2A);
  static const darkTextPrimary = Color(0xFFF9FAFB);
  static const darkTextSecondary = Color(0xFF9CA3AF);
  static const darkTextTertiary = Color(0xFF6B7280);
  static const darkBorder = Color(0xFF2A2A3C);
  static const darkBorderSubtle = Color(0xFF1F1F2E);

  // Glass / nav
  static const glassLight = Color(0xF0FFFFFF);
  static const glassDark = Color(0xE614141F);
  static const navIndicator = Color(0x335B4DFF);

  // Gradients
  static const heroGradientLight = [
    Color(0xFF5B4DFF),
    Color(0xFF7C3AED),
  ];
  static const heroGradientDark = [
    Color(0xFF4338CA),
    Color(0xFF5B21B6),
  ];
  static const streakGradient = [
    Color(0xFFFF6B2C),
    Color(0xFFFFB800),
  ];
  static const momentumGradient = [
    Color(0xFF00D4AA),
    Color(0xFF06B6D4),
  ];

  // Priority
  static const priorityLow = Color(0xFF10B981);
  static const priorityMedium = Color(0xFFF59E0B);
  static const priorityHigh = Color(0xFFEF4444);

  static Color surface(Brightness brightness, {bool elevated = false}) {
    if (brightness == Brightness.light) {
      return elevated ? lightSurfaceElevated : lightSurface;
    }
    return elevated ? darkSurfaceElevated : darkSurface;
  }

  static Color textPrimary(Brightness brightness) =>
      brightness == Brightness.light ? lightTextPrimary : darkTextPrimary;

  static Color textSecondary(Brightness brightness) =>
      brightness == Brightness.light ? lightTextSecondary : darkTextSecondary;

  static Color border(Brightness brightness, {bool subtle = false}) {
    if (brightness == Brightness.light) {
      return subtle ? lightBorderSubtle : lightBorder;
    }
    return subtle ? darkBorderSubtle : darkBorder;
  }
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const double full = 999;
}
