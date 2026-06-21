import 'package:flutter/material.dart';

import 'package:rejabon_ai/core/constants/life_areas.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';

/// Hayot sohasi tanlash — ko'p tanlov.
class LifeAreaPicker extends StatelessWidget {
  const LifeAreaPicker({
    super.key,
    required this.selected,
    required this.onChanged,
    this.compact = false,
  });

  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: LifeArea.all.map((area) {
        final isSelected = selected.contains(area.id);
        return FilterChip(
          selected: isSelected,
          showCheckmark: false,
          label: Text(
            compact ? area.emoji : '${area.emoji} ${area.label}',
            style: TextStyle(
              fontSize: compact ? 13 : 14,
              color: isSelected
                  ? Colors.white
                  : AppColors.textPrimary(Theme.of(context).brightness),
            ),
          ),
          selectedColor: area.color,
          backgroundColor: area.color.withValues(alpha: 0.1),
          side: BorderSide(
            color: isSelected ? area.color : area.color.withValues(alpha: 0.3),
          ),
          onSelected: (_) {
            final next = List<String>.from(selected);
            if (isSelected) {
              next.remove(area.id);
            } else {
              next.add(area.id);
            }
            onChanged(next);
          },
        );
      }).toList(),
    );
  }
}
