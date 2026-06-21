import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/theme/app_typography.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/platform/presentation/providers/platform_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

/// AI xotirasi — doimiy o'rganilgan naqshlar.
class AiMemoryScreen extends ConsumerWidget {
  const AiMemoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoriesAsync = ref.watch(aiMemoriesProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.aiMemory,
      showBackButton: true,
      body: memoriesAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          onRetry: () => ref.invalidate(aiMemoriesProvider),
        ),
        data: (memories) {
          if (memories.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  AppStrings.aiMemoryEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          final grouped = <String, List<dynamic>>{};
          for (final m in memories) {
            grouped.putIfAbsent(m.category, () => []).add(m);
          }

          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              ContentInsets.shellScrollBottom(context),
            ),
            children: [
              FadeIn(
                child: Text(
                  AppStrings.aiMemoryDesc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary(brightness),
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              for (final entry in grouped.entries) ...[
                Text(
                  _categoryLabel(entry.key).toUpperCase(),
                  style: AppTypography.sectionLabel(brightness),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final memory in entry.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memory.insight,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Ishonch: ${(memory.confidence * 100).round()}% · ${memory.referenceCount} marta',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        },
      ),
    );
  }

  static String _categoryLabel(String category) => switch (category) {
        'habits' => AppStrings.habits,
        'goals' => AppStrings.goals,
        'mood' => AppStrings.mood,
        'learning' => AppStrings.study,
        'fitness' => AppStrings.workout,
        'finance' => AppStrings.finance,
        _ => AppStrings.productivityInsights,
      };
}
