import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/intelligence/intelligence_providers.dart';
import 'package:rejabon_ai/core/theme/design_tokens.dart';
import 'package:rejabon_ai/core/utils/display_with_emoji.dart';
import 'package:rejabon_ai/features/ai_planning/presentation/providers/ai_planning_provider.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/features/retention/presentation/providers/retention_providers.dart';
import 'package:rejabon_ai/shared/widgets/calm_ui.dart';
import 'package:rejabon_ai/shared/widgets/progress_ring.dart';
import 'package:rejabon_ai/shared/widgets/quick_add_sheet.dart';

/// 1 — Kunlik brifing: salom + bitta qator.
class CalmDailyBriefing extends ConsumerWidget {
  const CalmDailyBriefing({super.key, required this.greeting});

  final String greeting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final briefing = ref.watch(dailyBriefingProvider);
    final brightness = Theme.of(context).brightness;
    final line = briefing.priorities.isNotEmpty
        ? briefing.priorities.first
        : briefing.aiAdvice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting 👋',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                height: 1.15,
              ),
        ),
        if (line.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            line,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary(brightness),
                  height: 1.45,
                ),
          ),
        ],
      ],
    );
  }
}

/// 2 — Asosiy maqsad + progress.
class CalmMainGoal extends StatelessWidget {
  const CalmMainGoal({super.key, this.goal});

  final GoalEntity? goal;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalmSectionTitle(title: AppStrings.mainGoal),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: () => context.push('/hayot/maqsadlar'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: goal != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayWithEmoji(
                            title: goal!.title,
                            emoji: goal!.emoji,
                          ),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: LinearProgressIndicator(
                            value: (goal!.progress / 100).clamp(0, 1),
                            minHeight: 6,
                            backgroundColor:
                                AppColors.border(brightness, subtle: true),
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${goal!.progress.round()}%',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    )
                  : Text(
                      AppStrings.noGoalsDesc,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary(brightness),
                          ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 3 — Hayot balli progress ring.
class CalmProgressRing extends ConsumerWidget {
  const CalmProgressRing({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(lifeScoreProvider);
    final brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalmSectionTitle(title: AppStrings.lifeScore),
        scoreAsync.when(
          loading: () => const SizedBox(height: 104),
          error: (_, __) => const SizedBox.shrink(),
          data: (score) => Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.full),
                onTap: () => context.push('/boshqa/analitika'),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    children: [
                      ProgressRing(
                        progress: score.overall / 100,
                        size: 104,
                        strokeWidth: 8,
                        color: AppColors.primary,
                        child: Text(
                          '${score.overall}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        AppStrings.analyticsSubtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary(brightness),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 4 — AI insight (Life Brain + retention).
class CalmAiInsight extends ConsumerWidget {
  const CalmAiInsight({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topInsight = ref.watch(lifeBrainTopInsightProvider);
    final bundleAsync = ref.watch(dailyRetentionBundleProvider);
    final brightness = Theme.of(context).brightness;

    final text = topInsight?.body ??
        bundleAsync.valueOrNull?.dailyInsight ??
        AppStrings.noTipsDesc;
    final route = topInsight?.actionRoute ?? '/boshqa/life-twin';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalmSectionTitle(title: AppStrings.aiRecommendation),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: () => context.push(route),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface(brightness, elevated: true),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.border(brightness, subtle: true),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (topInsight?.headline != null) ...[
                    Text(
                      topInsight!.headline,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                  Text(
                    text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.45,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 5 — Tez harakatlar (4 ta, 1 bosish).
class CalmQuickActions extends StatelessWidget {
  const CalmQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CalmSectionTitle(title: AppStrings.quickActions),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.add_rounded,
                label: AppStrings.quickAdd,
                onTap: () {
                  HapticFeedback.lightImpact();
                  QuickAddSheet.show(context);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickAction(
                icon: Icons.check_circle_outline_rounded,
                label: AppStrings.tasks,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.push('/vazifalar');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.psychology_outlined,
                label: AppStrings.aiCoach,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.push('/boshqa/murabbiy');
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickAction(
                icon: Icons.menu_book_outlined,
                label: AppStrings.journal,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.push('/hayot/kundalik');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Material(
      color: AppColors.surface(brightness, elevated: true),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border(brightness, subtle: true)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
