import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/features/heatmap/domain/life_heatmap_service.dart';
import 'package:rejabon_ai/features/retention/presentation/providers/retention_providers.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';

/// GitHub-style 365 kunlik hayot heatmap.
class LifeHeatmapWidget extends ConsumerWidget {
  const LifeHeatmapWidget({super.key, this.weeks = 52});

  final int weeks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(lifeHeatmapProvider);
    final service = ref.watch(lifeHeatmapServiceProvider);
    final activeDays = service.totalActiveDays(days);
    final streak = service.currentStreak(days);
    final brightness = Theme.of(context).brightness;

    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$activeDays faol kun · $streak kun ketma-ket',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary(brightness),
                    ),
              ),
              const Spacer(),
              _Legend(brightness: brightness),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _HeatmapGrid(days: days),
          ),
        ],
      ),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  const _HeatmapGrid({required this.days});

  final List<HeatmapDay> days;

  @override
  Widget build(BuildContext context) {
    const cellSize = 11.0;
    const gap = 2.0;
    const cols = 53;

    return SizedBox(
      width: cols * (cellSize + gap),
      height: 7 * (cellSize + gap),
      child: Wrap(
        direction: Axis.vertical,
        spacing: gap,
        runSpacing: gap,
        children: days.map((day) {
          return Tooltip(
            message:
                '${day.date.day}/${day.date.month}: ${day.tasksCompleted} vazifa, ${day.habitsCompleted} odat',
            child: Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                color: _intensityColor(day.intensity),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _intensityColor(int level) => switch (level) {
        0 => AppColors.primary.withValues(alpha: 0.08),
        1 => AppColors.primary.withValues(alpha: 0.25),
        2 => AppColors.primary.withValues(alpha: 0.45),
        3 => AppColors.primary.withValues(alpha: 0.65),
        _ => AppColors.primary.withValues(alpha: 0.9),
      };
}

class _Legend extends StatelessWidget {
  const _Legend({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Kam', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(width: 4),
        for (var i = 0; i <= 4; i++)
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(left: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08 + i * 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        const SizedBox(width: 4),
        Text('Ko\'p', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
