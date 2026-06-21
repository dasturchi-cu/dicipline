/// REJABON design system — 8px grid, consistent elevation & motion.
library;

export 'app_colors.dart';
export 'app_motion.dart';
export 'app_typography.dart';

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_motion.dart';

/// Elevation / shadow levels — Linear-style subtle depth.
class AppElevation {
  AppElevation._();

  static List<BoxShadow> level0 = const [];

  static List<BoxShadow> level1(Brightness brightness) => [
        BoxShadow(
          color: AppColors.textPrimary(brightness).withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> level2(Brightness brightness) => [
        BoxShadow(
          color: AppColors.textPrimary(brightness).withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> level3(Brightness brightness) => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
}

/// Standard page transitions.
class AppTransitions {
  AppTransitions._();

  static Widget fadeSlide(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: AppMotion.standard),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: AppMotion.standard)),
        child: child,
      ),
    );
  }
}
