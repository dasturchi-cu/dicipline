import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum AppCardVariant { elevated, outlined, filled }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.outlined,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius = AppRadius.lg,
  });

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;

    final backgroundColor = switch (variant) {
      AppCardVariant.elevated => isLight
          ? AppColors.lightSurface
          : AppColors.darkSurface,
      AppCardVariant.outlined => isLight
          ? AppColors.lightSurface
          : AppColors.darkSurface,
      AppCardVariant.filled => isLight
          ? AppColors.primaryLight
          : AppColors.darkSurface,
    };

    final border = variant == AppCardVariant.outlined
        ? Border.all(
            color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
          )
        : null;

    final elevation = variant == AppCardVariant.elevated ? 2.0 : 0.0;
    final shadowColor = isLight
        ? Colors.black.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.4);

    final content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      child: child,
    );

    final decorated = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: content,
    );

    if (onTap == null) {
      return decorated;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: decorated,
      ),
    );
  }
}
