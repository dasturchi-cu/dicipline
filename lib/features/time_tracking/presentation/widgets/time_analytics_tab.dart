import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/theme/app_typography.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/features/capture/presentation/providers/capture_providers.dart';
import 'package:rejabon_ai/features/time_tracking/domain/time_analytics_service.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_empty_state.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';

/// Analitika hub — vaqt tabi.
class TimeAnalyticsTab extends ConsumerWidget {
  const TimeAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(timeAnalyticsProvider);
    final period = ref.watch(timePeriodProvider);
    final brightness = Theme.of(context).brightness;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            0,
          ),
          child: SegmentedButton<TimePeriod>(
            segments: const [
              ButtonSegment(value: TimePeriod.day, label: Text(AppStrings.periodDay)),
              ButtonSegment(value: TimePeriod.week, label: Text(AppStrings.periodWeek)),
              ButtonSegment(value: TimePeriod.month, label: Text(AppStrings.periodMonth)),
              ButtonSegment(value: TimePeriod.year, label: Text(AppStrings.periodYear)),
            ],
            selected: {period},
            onSelectionChanged: (s) =>
                ref.read(timePeriodProvider.notifier).state = s.first,
          ),
        ),
        Expanded(
          child: reportAsync.when(
            loading: () => const AppLoadingState(),
            error: (_, __) => AppErrorState(
              onRetry: () => ref.invalidate(timeAnalyticsProvider),
            ),
            data: (report) {
              if (!report.hasData) {
                return AppEmptyState(
                  icon: Icons.timer_outlined,
                  title: AppStrings.timeAnalyticsEmpty,
                  description: AppStrings.timeAnalyticsEmptyDesc,
                  actionLabel: AppStrings.timeTracking,
                  onAction: () => context.push('/hayot/vaqt'),
                );
              }

              return ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  ContentInsets.shellScrollBottom(context),
                ),
                children: [
                  FadeIn(
                    child: AppCard(
                      variant: AppCardVariant.outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.totalHours,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.textSecondary(brightness),
                                ),
                          ),
                          Text(
                            report.totalHours.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            '${AppDateFormat.formatDate(report.periodStart)} — '
                            '${AppDateFormat.formatDate(report.periodEnd)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  for (final cat in report.categories) ...[
                    AppCard(
                      child: Row(
                        children: [
                          Text(cat.emoji, style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cat.label,
                                    style: Theme.of(context).textTheme.titleSmall),
                                Text(
                                  '${cat.hours.toStringAsFixed(1)} ${AppStrings.hours}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
