import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/router/app_router.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/plan_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/theme/app_typography.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/core/utils/display_with_emoji.dart';
import 'package:rejabon_ai/features/ai_planning/presentation/providers/ai_planning_provider.dart';
import 'package:rejabon_ai/features/gamification/domain/achievement_service.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';
import 'package:rejabon_ai/shared/widgets/glass_panel.dart';
import 'package:rejabon_ai/shared/widgets/progress_ring.dart';

class DashboardHeroHeader extends StatelessWidget {
  const DashboardHeroHeader({
    super.key,
    required this.greeting,
    required this.dateLabel,
  });

  final String greeting;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return FadeIn(
      index: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.commandCenter.toUpperCase(),
            style: AppTypography.sectionLabel(brightness).copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            greeting,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            dateLabel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class DashboardStreakCard extends StatelessWidget {
  const DashboardStreakCard({
    super.key,
    required this.streak,
    required this.habitsDone,
    required this.habitsTotal,
  });

  final int streak;
  final int habitsDone;
  final int habitsTotal;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      index: 1,
      child: AppCard(
        variant: AppCardVariant.gradient,
        gradientColors: AppColors.streakGradient,
        onTap: () => context.push('/hayot/odatlar'),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streak',
                    style: AppTypography.statValue(
                      Theme.of(context).brightness,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AppStrings.dayStreak,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                  ),
                ],
              ),
            ),
            if (habitsTotal > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$habitsDone/$habitsTotal',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    AppStrings.todayHabits,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class DashboardMainGoalCard extends StatelessWidget {
  const DashboardMainGoalCard({
    super.key,
    this.goal,
  });

  final GoalEntity? goal;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return FadeIn(
      index: 2,
      child: AppCard(
        variant: AppCardVariant.elevated,
        onTap: goal != null
            ? () => context.push('/hayot/maqsadlar')
            : () => context.push('/hayot/maqsadlar'),
        child: Row(
          children: [
            ProgressRing(
              progress: goal != null ? goal!.progress / 100 : 0,
              size: 64,
              strokeWidth: 5,
              color: AppColors.secondary,
              child: Text(
                goal != null ? '${goal!.progress.round()}%' : '—',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.mainGoal,
                    style: AppTypography.sectionLabel(brightness),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    goal != null
                        ? displayWithEmoji(
                            title: goal!.title,
                            emoji: goal!.emoji,
                          )
                        : AppStrings.noMainGoal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (goal?.targetDate != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppDateFormat.formatDate(goal!.targetDate!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.textSecondary(brightness),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardMomentumRow extends StatelessWidget {
  const DashboardMomentumRow({
    super.key,
    required this.tasksDone,
    required this.tasksTotal,
    required this.habitsProgress,
    required this.balanceLabel,
    required this.balancePositive,
  });

  final int tasksDone;
  final int tasksTotal;
  final double habitsProgress;
  final String balanceLabel;
  final bool balancePositive;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      index: 3,
      child: Row(
        children: [
          Expanded(
            child: _MomentumTile(
              label: AppStrings.todayTasks,
              value: '$tasksDone',
              subtitle: tasksTotal > 0 ? '/ $tasksTotal' : AppStrings.tasksDone,
              progress: tasksTotal > 0 ? tasksDone / tasksTotal : 0,
              color: AppColors.primary,
              onTap: () => context.go('/vazifalar'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _MomentumTile(
              label: AppStrings.momentum,
              value: '${(habitsProgress * 100).round()}%',
              subtitle: AppStrings.todayHabits,
              progress: habitsProgress,
              color: AppColors.secondary,
              onTap: () => context.push('/hayot/odatlar'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _MomentumTile(
              label: AppStrings.balance,
              value: balanceLabel,
              subtitle: null,
              progress: null,
              color: balancePositive ? AppColors.success : AppColors.error,
              compactValue: true,
              onTap: () => context.go('/moliya'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MomentumTile extends StatelessWidget {
  const _MomentumTile({
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
    this.subtitle,
    this.progress,
    this.compactValue = false,
  });

  final String label;
  final String value;
  final String? subtitle;
  final double? progress;
  final Color color;
  final bool compactValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: compactValue
                ? Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    )
                : Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (progress != null) ...[
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: color.withValues(alpha: 0.12),
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DashboardAiPlanningCard extends StatelessWidget {
  const DashboardAiPlanningCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      index: 4,
      child: AppCard(
        variant: AppCardVariant.filled,
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.aiPlanning,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppStrings.voiceToPlanDesc,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class DashboardTodaySchedule extends StatelessWidget {
  const DashboardTodaySchedule({
    super.key,
    required this.plan,
    required this.onTap,
    this.sectionTitle,
  });

  final PlanEntity plan;
  final VoidCallback onTap;
  final String? sectionTitle;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final sorted = List.of(plan.items)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final preview = sorted.take(3).toList();

    return FadeIn(
      index: 5,
      child: AppCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (sectionTitle ?? AppStrings.todaySchedule).toUpperCase(),
              style: AppTypography.sectionLabel(brightness),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final item in preview)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    Text(
                      AppDateFormat.formatTime(item.startTime),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(item.emoji),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: Text(item.title)),
                  ],
                ),
              ),
            if (sorted.length > 3)
              Text(
                '+${sorted.length - 3} ta band',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}

class DashboardLifeScoreCard extends ConsumerWidget {
  const DashboardLifeScoreCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(lifeScoreProvider);

    return scoreAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (score) => FadeIn(
        index: 6,
        child: AppCard(
          onTap: onTap,
          child: Row(
            children: [
              ProgressRing(
                progress: score.overall / 100,
                size: 56,
                strokeWidth: 5,
                child: Text(
                  '${score.overall}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.lifeScore.toUpperCase(),
                      style: AppTypography.sectionLabel(
                        Theme.of(context).brightness,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${AppStrings.scoreDiscipline}: ${score.discipline} · '
                      '${AppStrings.scoreGoals}: ${score.goals}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardTodayPlan extends StatelessWidget {
  const DashboardTodayPlan({
    super.key,
    required this.tasks,
  });

  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return FadeIn(
      index: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.todayPlan.toUpperCase(),
                style: AppTypography.sectionLabel(brightness),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.go('/vazifalar'),
                child: Text(AppStrings.viewAll),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (tasks.isEmpty)
            AppCard(
              variant: AppCardVariant.filled,
              child: Row(
                children: [
                  Icon(
                    Icons.celebration_outlined,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      AppStrings.noTasksDesc,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )
          else
            ...tasks.asMap().entries.map((entry) {
              final task = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key < tasks.length - 1 ? AppSpacing.sm : 0,
                ),
                child: AppCard(
                  onTap: () => context.push('/vazifalar/${task.id}'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + 2,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _priorityColor(task.priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          displayWithEmoji(
                            title: task.title,
                            emoji: task.emoji,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      if (task.dueDate != null)
                        Text(
                          AppDateFormat.formatDate(task.dueDate!),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Color _priorityColor(int priority) => switch (priority) {
        0 => AppColors.priorityLow,
        2 => AppColors.priorityHigh,
        _ => AppColors.priorityMedium,
      };
}

class DashboardAiCard extends StatelessWidget {
  const DashboardAiCard({
    super.key,
    required this.tipText,
    this.actionRoute,
  });

  final String tipText;
  final String? actionRoute;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      index: 5,
      child: GlassPanel(
        onTap: actionRoute != null ? () => context.push(actionRoute!) : null,
        opacity: Theme.of(context).brightness == Brightness.light ? 0.85 : 0.72,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.heroGradientLight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.aiTip.toUpperCase(),
                    style: AppTypography.sectionLabel(
                      Theme.of(context).brightness,
                    ).copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    tipText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary(
                            Theme.of(context).brightness,
                          ),
                        ),
                  ),
                  if (actionRoute != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppStrings.goToAction,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardAchievementsStrip extends StatelessWidget {
  const DashboardAchievementsStrip({
    super.key,
    required this.achievements,
    required this.unlockedCount,
  });

  final List<Achievement> achievements;
  final int unlockedCount;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final recent = achievements
        .where((a) => a.unlocked)
        .take(4)
        .toList();

    return FadeIn(
      index: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.achievements.toUpperCase(),
                style: AppTypography.sectionLabel(brightness),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '$unlockedCount/${achievements.length}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (recent.isEmpty)
            AppCard(
              variant: AppCardVariant.filled,
              child: Text(
                AppStrings.noAchievementsDesc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            SizedBox(
              height: 108,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recent.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final achievement = recent[index];
                  return AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: SizedBox(
                      width: 120,
                      height: 76,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            achievement.emoji,
                            style: const TextStyle(fontSize: 26),
                          ),
                          Text(
                            achievement.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return FadeIn(
      index: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.quickActions.toUpperCase(),
            style: AppTypography.sectionLabel(brightness),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _QuickChip(
                icon: Icons.add_task_rounded,
                label: AppStrings.addTask,
                onTap: () => context.push('/vazifalar/yangi'),
              ),
              _QuickChip(
                icon: Icons.repeat_rounded,
                label: AppStrings.addHabit,
                onTap: () => context.push('/hayot/odatlar'),
              ),
              _QuickChip(
                icon: Icons.remove_circle_outline_rounded,
                label: AppStrings.addExpense,
                onTap: () => context.go('/moliya'),
              ),
              _QuickChip(
                icon: Icons.auto_awesome_rounded,
                label: AppStrings.aiPlanning,
                onTap: () => context.pushOnce('/reja'),
              ),
              _QuickChip(
                icon: Icons.psychology_outlined,
                label: AppStrings.aiCoach,
                onTap: () => context.push('/boshqa/murabbiy'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface(
              Theme.of(context).brightness,
              elevated: true,
            ),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: AppColors.border(
                Theme.of(context).brightness,
                subtle: true,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(label, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
