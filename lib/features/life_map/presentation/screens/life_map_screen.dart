import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/life_map/domain/life_map_service.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';
import 'package:rejabon_ai/shared/widgets/progress_ring.dart';

/// Life Map — maqsad yo'l xaritasi va xronologiya.
class LifeMapScreen extends ConsumerWidget {
  const LifeMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapAsync = ref.watch(lifeMapDataProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.lifeMap,
      showBackButton: true,
      body: mapAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
        data: (data) => ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            ContentInsets.shellScrollBottom(context),
          ),
          children: [
            _OverallCard(progress: data.overallProgress),
            const SizedBox(height: AppSpacing.md),
            const _CurrentPositionStrip(),
            const SizedBox(height: AppSpacing.lg),
            Text(AppStrings.goalRoadmap,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            if (data.goalRoadmaps.isEmpty)
              Text(AppStrings.noGoalsYet)
            else
              ...data.goalRoadmaps.map((g) => _GoalRoadmapCard(segment: g)),
            const SizedBox(height: AppSpacing.lg),
            Text(AppStrings.progressTimeline,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ...data.progressTimeline.take(10).map(
                  (n) => _TimelineTile(node: n, brightness: brightness),
                ),
            const SizedBox(height: AppSpacing.lg),
            Text(AppStrings.achievementTimeline,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            if (data.achievementTimeline.isEmpty)
              Text(AppStrings.milestonesEmptyDesc)
            else
              ...data.achievementTimeline.take(10).map(
                    (n) => _TimelineTile(node: n, brightness: brightness),
                  ),
          ],
        ),
      ),
    );
  }
}

class _CurrentPositionStrip extends ConsumerWidget {
  const _CurrentPositionStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final osAsync = ref.watch(lifeOsStateProvider);
    final analysisAsync = ref.watch(lifeTwinAnalysisProvider);
    final brightness = Theme.of(context).brightness;

    return osAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (state) {
        final analysis = analysisAsync.valueOrNull;
        return AppCard(
          variant: AppCardVariant.filled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.currentPosition,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Samaradorlik: ${state.productivityScore}/100 · '
                'Maqsad momenti: ${state.goalMomentum.round()}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                state.loopInsight,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary(brightness),
                    ),
              ),
              if (analysis != null && analysis.insights.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  analysis.insights.first.headline,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(analysis.insights.first.body),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _OverallCard extends StatelessWidget {
  const _OverallCard({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.filled,
      child: Row(
        children: [
          ProgressRing(
            progress: progress / 100,
            size: 56,
            strokeWidth: 4,
            child: Text('${progress.round()}%'),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              AppStrings.lifeMapOverall,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalRoadmapCard extends StatelessWidget {
  const _GoalRoadmapCard({required this.segment});

  final GoalRoadmapSegment segment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(segment.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(segment.title,
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                Text('${segment.progress.round()}%'),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
              value: segment.progress / 100,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            if (segment.milestones.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              ...segment.milestones.map(
                (m) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(
                        m.type == 'milestone_done'
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 16,
                        color: m.type == 'milestone_done'
                            ? AppColors.success
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Expanded(child: Text(m.title)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.node, required this.brightness});

  final LifeMapNode node;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(node.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(node.title,
                    style: Theme.of(context).textTheme.titleSmall),
                if (node.description != null)
                  Text(
                    node.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary(brightness),
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
