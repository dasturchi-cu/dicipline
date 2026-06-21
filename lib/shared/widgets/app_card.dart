import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';

enum AppCardVariant { elevated, outlined, filled, gradient }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.outlined,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius = AppRadius.lg,
    this.gradientColors,
  });

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;

    final isGradient = variant == AppCardVariant.gradient;
    final backgroundColor = switch (variant) {
      AppCardVariant.elevated => AppColors.surface(brightness, elevated: true),
      AppCardVariant.outlined => AppColors.surface(brightness),
      AppCardVariant.filled => isLight ? AppColors.primaryLight : AppColors.darkSurfaceElevated,
      AppCardVariant.gradient => Colors.transparent,
    };

    final border = variant == AppCardVariant.outlined || variant == AppCardVariant.elevated
        ? Border.all(color: AppColors.border(brightness, subtle: true))
        : isGradient
            ? null
            : null;

    final elevation = variant == AppCardVariant.elevated ? 1.0 : 0.0;
    final shadowColor = isLight
        ? Colors.black.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.35);

    final gradient = isGradient
        ? (gradientColors ??
            (isLight ? AppColors.heroGradientLight : AppColors.heroGradientDark))
        : null;

    final content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      child: child,
    );

    final decorated = AnimatedContainer(
      duration: AppMotion.normal,
      margin: margin,
      decoration: BoxDecoration(
        color: isGradient ? null : backgroundColor,
        gradient: gradient != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              )
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : isGradient
                ? [
                    BoxShadow(
                      color: (gradient?.first ?? AppColors.primary)
                          .withValues(alpha: 0.28),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
      ),
      child: content,
    );

    if (onTap == null) return decorated;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: isGradient
            ? Colors.white.withValues(alpha: 0.12)
            : AppColors.primary.withValues(alpha: 0.08),
        child: decorated,
      ),
    );
  }
}
