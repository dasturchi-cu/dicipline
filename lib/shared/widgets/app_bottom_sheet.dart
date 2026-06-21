import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/theme/app_colors.dart';

/// Dispose controllers after the sheet route fully closes.
void deferDispose(VoidCallback dispose) {
  SchedulerBinding.instance.addPostFrameCallback((_) => dispose());
}

Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  String? title,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final bottom = MediaQuery.paddingOf(ctx).bottom;
      final keyboard = MediaQuery.viewInsetsOf(ctx).bottom;
      final brightness = Theme.of(ctx).brightness;
      final maxHeight = MediaQuery.sizeOf(ctx).height * 0.9;

      return Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          bottom + AppSpacing.md,
        ),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(bottom: keyboard),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface(brightness, elevated: true),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xxl),
                  bottom: Radius.circular(AppRadius.xl),
                ),
                border: Border.all(
                  color: AppColors.border(brightness, subtle: true),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: brightness == Brightness.light ? 0.12 : 0.4,
                    ),
                    blurRadius: 32,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border(brightness),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(ctx).textTheme.titleLarge,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(Icons.close_rounded),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
