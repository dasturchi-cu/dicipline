import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static String get fontFamily => GoogleFonts.inter().fontFamily!;

  static String get displayFamily => GoogleFonts.plusJakartaSans().fontFamily!;

  static TextTheme textTheme(Brightness brightness) {
    final primary = AppColors.textPrimary(brightness);
    final secondary = AppColors.textSecondary(brightness);
    final tertiary = brightness == Brightness.light
        ? AppColors.lightTextTertiary
        : AppColors.darkTextTertiary;

    final display = GoogleFonts.plusJakartaSans;
    final body = GoogleFonts.inter;

    return TextTheme(
      displayLarge: display(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: primary,
        letterSpacing: -1.2,
        height: 1.1,
      ),
      displayMedium: display(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.8,
        height: 1.15,
      ),
      headlineLarge: display(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      headlineMedium: display(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.3,
        height: 1.25,
      ),
      headlineSmall: display(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.2,
        height: 1.3,
      ),
      titleLarge: body(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.1,
      ),
      titleMedium: body(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: body(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: body(fontSize: 16, color: primary, height: 1.55),
      bodyMedium: body(fontSize: 14, color: secondary, height: 1.5),
      bodySmall: body(fontSize: 12, color: tertiary, height: 1.45),
      labelLarge: body(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: 0.1,
      ),
      labelMedium: body(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
      labelSmall: body(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: tertiary,
        letterSpacing: 0.3,
      ),
    );
  }

  static TextStyle statValue(Brightness brightness, {Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: color ?? AppColors.textPrimary(brightness),
      letterSpacing: -1,
      height: 1,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle sectionLabel(Brightness brightness) {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary(brightness),
      letterSpacing: 0,
    );
  }
}
