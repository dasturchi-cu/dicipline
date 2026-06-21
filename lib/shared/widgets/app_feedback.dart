import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';

void hapticLight() => HapticFeedback.lightImpact();
void hapticMedium() => HapticFeedback.mediumImpact();
void hapticSuccess() => HapticFeedback.heavyImpact();

/// Dialog yopilgach controllerlarni xavfsiz yo'q qiladi (animatsiya tugaguncha kutadi).
void deferDispose(VoidCallback dispose) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    Future<void>.delayed(const Duration(milliseconds: 320), dispose);
  });
}

void showSavedSnackBar(BuildContext context, {String? message}) {
  hapticLight();
  _showFeedbackSnackBar(
    context,
    message: message ?? AppStrings.saved,
    icon: Icons.check_circle_rounded,
    color: AppColors.success,
  );
}

void showDeletedSnackBar(BuildContext context) {
  hapticMedium();
  _showFeedbackSnackBar(
    context,
    message: AppStrings.deleted,
    icon: Icons.delete_outline_rounded,
    color: AppColors.error,
  );
}

void showCompletedSnackBar(BuildContext context, {String? message}) {
  hapticSuccess();
  _showFeedbackSnackBar(
    context,
    message: message ?? AppStrings.taskCompleted,
    icon: Icons.celebration_rounded,
    color: AppColors.secondary,
  );
}

void showAchievementSnackBar(
  BuildContext context, {
  required String emoji,
  required String title,
}) {
  hapticSuccess();
  _showFeedbackSnackBar(
    context,
    message: '$emoji $title',
    icon: Icons.emoji_events_rounded,
    color: AppColors.gold,
    duration: const Duration(seconds: 4),
  );
}

void _showFeedbackSnackBar(
  BuildContext context, {
  required String message,
  required IconData icon,
  required Color color,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppColors.lightTextPrimary
          : AppColors.darkSurfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      content: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : AppColors.darkTextPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<bool> confirmDelete(BuildContext context) async {
  hapticLight();
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final brightness = Theme.of(ctx).brightness;
      return AlertDialog(
        backgroundColor: AppColors.surface(brightness, elevated: true),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        title: Text(AppStrings.delete),
        content: Text(AppStrings.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppStrings.delete),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
