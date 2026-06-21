import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/action_plan_entity.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/ai_planning/presentation/providers/ai_planning_provider.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

/// AI Action Engine — jadval, reja va tiklanish.
class ActionEngineScreen extends ConsumerWidget {
  const ActionEngineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(actionPlansProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.actionEngine,
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: AppStrings.runAnalysis,
          onPressed: () => _runAnalysis(ref),
        ),
      ],
      body: plansAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
        data: (plans) => ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            ContentInsets.shellScrollBottom(context),
          ),
          children: [
            Text(
              AppStrings.actionEngineDesc,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary(brightness),
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: AppStrings.runAnalysis,
              onPressed: () => _runAnalysis(ref),
              icon: Icons.auto_fix_high_rounded,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (plans.isEmpty)
              Text(AppStrings.noActionPlans)
            else
              ...plans.map((p) => _PlanCard(plan: p, ref: ref)),
          ],
        ),
      ),
    );
  }

  Future<void> _runAnalysis(WidgetRef ref) async {
    final profile = await ref.read(lifeTwinProfileProvider.future);
    final breakdown = await ref.read(lifeScoreProvider.future);
    await ref.read(actionEngineServiceProvider).runFullAnalysis(
          profile: profile,
          breakdown: breakdown,
          tasks: await ref.read(taskRepositoryProvider).getAll(),
          habits: await ref.read(habitRepositoryProvider).getAll(),
          goals: await ref.read(goalRepositoryProvider).getAll(),
          journal: await ref.read(journalRepositoryProvider).getAll(),
        );
    ref.invalidate(actionPlansProvider);
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.ref});

  final ActionPlanEntity plan;
  final WidgetRef ref;

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
                Icon(_iconForType(plan.planType), color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(plan.title,
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                _StatusChip(status: plan.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(plan.summary),
            const SizedBox(height: AppSpacing.sm),
            ...plan.actions.take(4).map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• ${a['title']}: ${a['description']}'),
                  ),
                ),
            if (plan.status == 'pending') ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  if (plan.planType == 'schedule_adjust')
                    Expanded(
                      child: AppButton(
                        label: AppStrings.applyPlan,
                        variant: AppButtonVariant.secondary,
                        onPressed: () async {
                          await ref
                              .read(actionEngineServiceProvider)
                              .applySchedulePlan(plan);
                          ref.invalidate(actionPlansProvider);
                        },
                      ),
                    ),
                  if (plan.planType == 'schedule_adjust')
                    const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: plan.planType == 'schedule_adjust'
                          ? AppStrings.dismissPlan
                          : AppStrings.markDone,
                      variant: AppButtonVariant.ghost,
                      onPressed: () async {
                        final repo = ref.read(actionPlanRepositoryProvider);
                        if (plan.planType == 'schedule_adjust') {
                          await repo.markDismissed(plan);
                        } else {
                          await repo.markApplied(plan);
                        }
                        ref.invalidate(actionPlansProvider);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _iconForType(String type) => switch (type) {
        'schedule_adjust' => Icons.schedule_rounded,
        'plan_rebuild' => Icons.event_note_rounded,
        'recovery' => Icons.spa_rounded,
        _ => Icons.lightbulb_rounded,
      };
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'applied' => AppColors.success,
      'dismissed' => AppColors.textSecondary(Theme.of(context).brightness),
      _ => AppColors.warning,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(status, style: TextStyle(fontSize: 11, color: color)),
    );
  }
}
