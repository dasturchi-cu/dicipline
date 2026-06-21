import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/theme/design_tokens.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/ai_planning/presentation/providers/ai_planning_provider.dart';
import 'package:rejabon_ai/features/analytics/presentation/widgets/analytics_insights_tab.dart';
import 'package:rejabon_ai/features/journal/presentation/widgets/mood_trend_chart.dart';
import 'package:rejabon_ai/core/intelligence/intelligence_providers.dart';
import 'package:rejabon_ai/features/retention/presentation/providers/retention_providers.dart';
import 'package:rejabon_ai/features/time_tracking/presentation/widgets/time_analytics_tab.dart';
import 'package:rejabon_ai/shared/widgets/life_heatmap.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';
import 'package:rejabon_ai/shared/widgets/progress_ring.dart';

/// Birlashtirilgan analitika — 3 tab: umumiy, kayfiyat, batafsil.
class AnalyticsHubScreen extends ConsumerWidget {
  const AnalyticsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: ModuleScreen(
        title: AppStrings.analyticsHub,
        showBackButton: true,
        body: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary(
                Theme.of(context).brightness,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: AppStrings.analyticsOverview),
                Tab(text: AppStrings.moodInsights),
                Tab(text: AppStrings.analyticsDetails),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _OverviewTab(ref: ref),
                  _MoodTab(ref: ref),
                  const _DetailsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = this.ref.watch(lifeScoreProvider);
    return scoreAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
      data: (score) => ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          ContentInsets.shellScrollBottom(context),
        ),
        children: [
          Center(
            child: ProgressRing(
              progress: score.overall / 100,
              size: 112,
              strokeWidth: 7,
              child: Text(
                '${score.overall}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ScoreRow(label: AppStrings.scoreHealth, value: score.health),
          _ScoreRow(label: AppStrings.scoreLearning, value: score.learning),
          _ScoreRow(label: AppStrings.scoreDiscipline, value: score.discipline),
          _ScoreRow(label: AppStrings.scoreGoals, value: score.goals),
          _ScoreRow(label: AppStrings.scoreFinance, value: score.finance),
          _ScoreRow(label: AppStrings.scoreSleep, value: score.sleep),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.lifeHeatmap,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const LifeHeatmapWidget(),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(AppStrings.lifeAreas),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/hayot/sohalar'),
          ),
        ],
      ),
    );
  }
}

class _MoodTab extends ConsumerWidget {
  const _MoodTab({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mood = this.ref.watch(moodTrendProvider);
    final emotion = this.ref.watch(emotionProfileProvider);
    final brightness = Theme.of(context).brightness;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        ContentInsets.shellScrollBottom(context),
      ),
      children: [
        MoodTrendChart(report: mood),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppStrings.emotionIntelligence,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...emotion.insights.take(3).map(
              (i) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(i.title),
                subtitle: Text(
                  i.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: () => context.push(i.actionRoute),
                ),
              ),
            ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(AppStrings.journal),
          subtitle: Text(
            AppStrings.noJournalDesc,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary(brightness),
                ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => context.push('/hayot/kundalik'),
        ),
      ],
    );
  }
}

class _DetailsTab extends StatelessWidget {
  const _DetailsTab();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary(
              Theme.of(context).brightness,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: AppStrings.timeAnalytics),
              Tab(text: AppStrings.analytics),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                TimeAnalyticsTab(),
                AnalyticsInsightsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            '$value',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary(brightness),
                ),
          ),
        ],
      ),
    );
  }
}
