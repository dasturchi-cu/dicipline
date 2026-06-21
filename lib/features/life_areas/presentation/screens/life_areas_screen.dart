import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/life_areas.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/content_insets.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/fade_in.dart';
import '../../../../shared/widgets/module_screen.dart';
import '../../../../shared/widgets/progress_ring.dart';
import '../../../life_areas/domain/life_area_score_service.dart';
import 'package:rejabon_ai/features/life_os/presentation/providers/life_os_providers.dart';

class LifeAreasScreen extends ConsumerWidget {
  const LifeAreasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(lifeBalanceProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.lifeAreas,
      showBackButton: true,
      body: balanceAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          onRetry: () => ref.invalidate(lifeBalanceProvider),
        ),
        data: (report) {
          if (!report.hasSufficientData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  AppStrings.lifeAreasInsufficientData,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(lifeBalanceProvider),
            color: AppColors.primary,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                ContentInsets.shellScrollBottom(context),
              ),
              children: [
                FadeIn(
                  child: AppCard(
                    variant: AppCardVariant.outlined,
                    child: Row(
                      children: [
                        ProgressRing(
                          progress: report.overallScore / 100,
                          size: 72,
                          strokeWidth: 6,
                          color: AppColors.primary,
                          child: Text(
                            '${report.overallScore}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.lifeBalanceScore,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '${report.thrivingAreas.length} rivojlanmoqda · '
                                '${report.neglectedAreas.length} e\'tiborsiz',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary(brightness),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.areaProgress,
                  style: AppTypography.sectionLabel(brightness),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final score in report.areaScores)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _AreaScoreCard(score: score),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AreaScoreCard extends StatelessWidget {
  const _AreaScoreCard({required this.score});

  final LifeAreaScore score;

  @override
  Widget build(BuildContext context) {
    final healthColor = switch (score.health) {
      AreaHealth.thriving => AppColors.success,
      AreaHealth.balanced => AppColors.warning,
      AreaHealth.neglected => AppColors.error,
    };

    return AppCard(
      variant: AppCardVariant.outlined,
      child: Row(
        children: [
          Text(score.area.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  score.area.label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  areaHealthLabel(score.health),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: healthColor,
                      ),
                ),
                if (score.tasksTotal > 0)
                  Text(
                    '${score.tasksCompleted}/${score.tasksTotal} vazifa',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
              ],
            ),
          ),
          Text(
            '${score.score}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: score.area.color,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
