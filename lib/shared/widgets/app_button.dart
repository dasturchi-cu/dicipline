import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, ghost }

enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final height = switch (size) {
      AppButtonSize.sm => 40.0,
      AppButtonSize.md => 48.0,
      AppButtonSize.lg => 56.0,
    };
    final horizontalPadding = switch (size) {
      AppButtonSize.sm => AppSpacing.md,
      AppButtonSize.md => AppSpacing.lg,
      AppButtonSize.lg => AppSpacing.xl,
    };

    final child = _buildChild(theme);

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: _isDisabled ? null : onPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(isExpanded ? double.infinity : 0, height),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: _isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(isExpanded ? double.infinity : 0, height),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            foregroundColor: AppColors.primary,
            side: BorderSide(
              color: _isDisabled
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.primary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.ghost => TextButton(
          onPressed: _isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(isExpanded ? double.infinity : 0, height),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            foregroundColor: brightness == Brightness.light
                ? AppColors.lightTextPrimary
                : AppColors.darkTextPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          child: child,
        ),
    };

    return button;
  }

  Widget _buildChild(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: variant == AppButtonVariant.primary
              ? Colors.white
              : AppColors.primary,
        ),
      );
    }

    final text = Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        color: variant == AppButtonVariant.primary
            ? Colors.white
            : variant == AppButtonVariant.secondary
                ? AppColors.primary
                : null,
        fontWeight: FontWeight.w600,
      ),
    );

    if (icon == null) {
      return text;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: AppSpacing.sm),
        text,
      ],
    );
  }
}
