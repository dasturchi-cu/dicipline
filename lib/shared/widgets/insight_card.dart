import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/features/analytics/domain/analytics_insight_service.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';

/// Analitika va murabbiy kartalar uchun umumiy insight UI.
class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    this.metric,
    this.trend,
    this.actionRoute,
    this.actionLabel,
    this.onTap,
  });

  factory InsightCard.fromAnalytics(AnalyticsInsight insight) {
    return InsightCard(
      emoji: insight.emoji,
      title: insight.title,
      description: insight.description,
      metric: insight.metric,
      trend: insight.trend,
      actionRoute: insight.actionRoute,
      actionLabel: insight.actionLabel,
    );
  }

  final String emoji;
  final String title;
  final String description;
  final String? metric;
  final String? trend;
  final String? actionRoute;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final trendColor = switch (trend) {
      'up' => AppColors.success,
      'down' => AppColors.error,
      _ => AppColors.textSecondary(brightness),
    };

    return AppCard(
      variant: AppCardVariant.outlined,
      onTap: onTap ??
          (actionRoute != null ? () => context.push(actionRoute!) : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (metric != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: trendColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    metric!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: trendColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (actionRoute != null && actionLabel != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                actionLabel!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
