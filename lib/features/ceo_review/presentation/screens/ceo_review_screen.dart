import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/integration/ai_memory_sync.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/content_insets.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/fade_in.dart';
import '../../../../shared/widgets/module_screen.dart';
import 'package:rejabon_ai/features/life_os/presentation/providers/life_os_providers.dart';

class CeoReviewScreen extends ConsumerWidget {
  const CeoReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(ceoWeeklyReviewProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.ceoWeeklyReview,
      showBackButton: true,
      body: reportAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          onRetry: () => ref.invalidate(ceoWeeklyReviewProvider),
        ),
        data: (report) {
          if (!report.hasSufficientData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  AppStrings.ceoInsufficientData,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await syncAiMemoryOnReview(ref);
              ref.invalidate(ceoWeeklyReviewProvider);
            },
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.ceoWeeklyReview,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.textSecondary(brightness),
                              ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${AppDateFormat.formatDate(report.weekStart)} — '
                          '${AppDateFormat.formatDate(report.weekEnd)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          '${report.overallScore}',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                        ),
                        Text(
                          AppStrings.overallScore,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary(brightness),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (report.wins.isNotEmpty) ...[
                  _Section(title: AppStrings.ceoWins, items: report.wins),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (report.failures.isNotEmpty) ...[
                  _Section(title: AppStrings.ceoFailures, items: report.failures),
                  const SizedBox(height: AppSpacing.md),
                ],
                _Section(
                  title: AppStrings.ceoProgress,
                  items: report.progressNotes,
                ),
                const SizedBox(height: AppSpacing.md),
                if (report.weaknesses.isNotEmpty)
                  _Section(
                    title: AppStrings.ceoWeaknesses,
                    items: report.weaknesses,
                  ),
                const SizedBox(height: AppSpacing.md),
                _Section(
                  title: AppStrings.habits,
                  items: report.habitNotes,
                ),
                const SizedBox(height: AppSpacing.md),
                _Section(title: AppStrings.goals, items: report.goalNotes),
                const SizedBox(height: AppSpacing.md),
                _Section(
                  title: AppStrings.study,
                  items: report.learningNotes,
                ),
                const SizedBox(height: AppSpacing.md),
                _Section(
                  title: AppStrings.workout,
                  items: report.healthNotes,
                ),
                const SizedBox(height: AppSpacing.md),
                _Section(
                  title: AppStrings.ceoRecommendations,
                  items: report.recommendations,
                ),
                if (report.actions.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppStrings.ceoFocusAreas.toUpperCase(),
                    style: AppTypography.sectionLabel(brightness),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: report.actions
                        .map(
                          (a) => ActionChip(
                            avatar: Icon(a.icon, size: 18),
                            label: Text(a.label),
                            onPressed: () => context.push(a.route),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (report.focusAreas.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppStrings.ceoFocusAreas.toUpperCase(),
                    style: AppTypography.sectionLabel(brightness),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: report.focusAreas
                        .map(
                          (a) => Chip(
                            avatar: Text(a.emoji),
                            label: Text(a.label),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTypography.sectionLabel(brightness),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
