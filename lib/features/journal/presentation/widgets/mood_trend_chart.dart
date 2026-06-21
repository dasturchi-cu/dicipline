import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/mood_trend_service.dart';

class MoodTrendChart extends StatelessWidget {
  const MoodTrendChart({super.key, required this.report});

  final MoodTrendReport report;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface(brightness),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border(brightness)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.moodTrendTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: report.last7Days.map((point) {
              final mood = point.mood;
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      mood != null ? moodEmoji(mood) : '·',
                      style: TextStyle(
                        fontSize: mood != null ? 20 : 16,
                        color: mood == null
                            ? AppColors.textSecondary(brightness)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${point.date.day}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary(brightness),
                          ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (report.hasSufficientData) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              report.insight,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary(brightness),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
