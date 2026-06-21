import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'app_feedback.dart';

class FilterPills<T> extends StatelessWidget {
  const FilterPills({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.labelBuilder,
  });

  final List<T> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final String Function(T) labelBuilder;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  hapticLight();
                  onSelected(option);
                },
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surface(brightness, elevated: true),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border(brightness, subtle: true),
                    ),
                  ),
                  child: Text(
                    labelBuilder(option),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary(brightness),
                        ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
