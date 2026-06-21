import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/content_insets.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/fade_in.dart';
import '../../../../shared/widgets/insight_card.dart';
import '../../../../shared/widgets/module_screen.dart';
import '../../../platform/presentation/providers/platform_providers.dart';
import '../../domain/analytics_insight_service.dart';

/// MVP analitika — qoidaviy, tez va tushunarli xulosalar.
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(analyticsInsightsProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.analytics,
      showBackButton: true,
      body: insightsAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          onRetry: () => ref.invalidate(analyticsInsightsProvider),
        ),
        data: (insights) {
          if (insights.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  AppStrings.noAnalyticsDesc,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          final grouped = <InsightCategory, List<AnalyticsInsight>>{};
          for (final insight in insights) {
            grouped.putIfAbsent(insight.category, () => []).add(insight);
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(analyticsInsightsProvider),
            color: AppColors.primary,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                ContentInsets.shellScrollBottom(context),
              ),
              children: [
                for (final entry in grouped.entries) ...[
                  Text(
                    _categoryLabel(entry.key),
                    style: AppTypography.sectionLabel(brightness),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final insight in entry.value)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: FadeIn(
                        child: InsightCard.fromAnalytics(insight),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  static String _categoryLabel(InsightCategory category) => switch (category) {
        InsightCategory.productivity => AppStrings.productivityInsights,
        InsightCategory.learning => AppStrings.learningInsights,
        InsightCategory.fitness => AppStrings.fitnessInsights,
        InsightCategory.finance => AppStrings.financeInsights,
        InsightCategory.habits => AppStrings.habitInsights,
        InsightCategory.mood => AppStrings.moodInsights,
      };
}
