import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/core/utils/format_money.dart';
import 'package:rejabon_ai/features/ai_coach/presentation/providers/ai_coach_provider.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.goodMorning;
    if (hour < 18) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final habitsAsync = ref.watch(habitsProvider);
    final financeAsync = ref.watch(financeTransactionsProvider);
    final tipsAsync = ref.watch(aiTipsProvider);
    final userName = ref.watch(settingsProvider).userName;

    final isLoading = tasksAsync.isLoading ||
        habitsAsync.isLoading ||
        financeAsync.isLoading;

    if (isLoading) {
      return const ModuleScreen(
        title: AppStrings.dashboard,
        body: AppLoadingState(),
      );
    }

    if (tasksAsync.hasError ||
        habitsAsync.hasError ||
        financeAsync.hasError) {
      return ModuleScreen(
        title: AppStrings.dashboard,
        body: AppErrorState(
          onRetry: () {
            ref.invalidate(tasksProvider);
            ref.invalidate(habitsProvider);
            ref.invalidate(financeTransactionsProvider);
            ref.invalidate(aiTipsProvider);
          },
        ),
      );
    }

    final tasks = tasksAsync.value ?? [];
    final habits = habitsAsync.value ?? [];
    final finance = financeAsync.value ?? [];
    final today = AppDateFormat.dateOnly(DateTime.now());

    final todayTasks = tasks
        .where((t) => !t.isCompleted)
        .where((t) {
          if (t.dueDate == null) return true;
          return AppDateFormat.isSameDay(t.dueDate!, today) ||
              t.dueDate!.isBefore(today.add(const Duration(days: 1)));
        })
        .length;

    final habitsDone = habits
        .where((h) => h.completedDates.any((d) => AppDateFormat.isSameDay(d, today)))
        .length;
    final habitsTotal = habits.length;
    final habitsProgress = habitsTotal > 0 ? habitsDone / habitsTotal : 0.0;
    final balance = FinanceRepository.balance(finance);
    final primaryTip = tipsAsync.valueOrNull?.firstOrNull;

    final greeting =
        userName.isNotEmpty ? '${_greeting()}, $userName!' : '${_greeting()}!';

    return ModuleScreen(
      title: AppStrings.dashboard,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            greeting,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            AppDateFormat.formatDate(DateTime.now()),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.lightTextSecondary
                      : AppColors.darkTextSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.task_alt_rounded,
                  label: AppStrings.todayTasks,
                  value: '$todayTasks',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(
                  icon: Icons.repeat_rounded,
                  label: AppStrings.todayHabits,
                  value: habitsTotal > 0 ? '$habitsDone/$habitsTotal' : '0',
                  color: AppColors.secondary,
                  progress: habitsProgress,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _StatCard(
            icon: Icons.account_balance_wallet_rounded,
            label: AppStrings.balance,
            value: formatMoney(balance),
            color: balance >= 0 ? AppColors.success : AppColors.error,
            fullWidth: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            variant: AppCardVariant.filled,
            onTap: primaryTip?.actionRoute != null
                ? () => context.push(primaryTip!.actionRoute!)
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.psychology_outlined, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.aiTip,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(primaryTip?.displayText ?? AppStrings.noTipsDesc),
                      if (primaryTip?.actionRoute != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          AppStrings.goToAction,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (primaryTip?.actionRoute != null)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.quickActions,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _QuickAction(
                icon: Icons.add_task_rounded,
                label: AppStrings.addTask,
                onTap: () => context.push('/vazifalar/yangi'),
              ),
              _QuickAction(
                icon: Icons.repeat_rounded,
                label: AppStrings.addHabit,
                onTap: () => context.push('/hayot/odatlar'),
              ),
              _QuickAction(
                icon: Icons.remove_circle_outline_rounded,
                label: AppStrings.addExpense,
                onTap: () => context.go('/moliya'),
              ),
              _QuickAction(
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.progress,
    this.fullWidth = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final double? progress;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          if (progress != null) ...[
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: color.withValues(alpha: 0.15),
                color: color,
              ),
            ),
          ],
        ],
      ),
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
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      ),
    );
  }
}
