import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/integration/action_reward_bridge.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/focus/domain/pomodoro_notifier.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';
import 'package:rejabon_ai/shared/widgets/progress_ring.dart';

/// Fokus rejimi — Pomodoro 25/5 + XP mukofoti.
class FocusModeScreen extends ConsumerWidget {
  const FocusModeScreen({super.key});

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoro = ref.watch(pomodoroProvider);
    final notifier = ref.read(pomodoroProvider.notifier);
    final brightness = Theme.of(context).brightness;

    final phaseLabel = switch (pomodoro.phase) {
      PomodoroPhase.focus => AppStrings.focusPhase,
      PomodoroPhase.breakTime => AppStrings.breakPhase,
      PomodoroPhase.idle => AppStrings.focusReady,
    };

    final progress = pomodoro.phase == PomodoroPhase.focus
        ? 1 - pomodoro.secondsRemaining / PomodoroNotifier.focusSeconds
        : pomodoro.phase == PomodoroPhase.breakTime
            ? 1 - pomodoro.secondsRemaining / PomodoroNotifier.breakSeconds
            : 0.0;

    return ModuleScreen(
      title: AppStrings.focusMode,
      showBackButton: true,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
          ContentInsets.shellScrollBottom(context),
        ),
        child: Column(
          children: [
            Text(
              phaseLabel.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: AppSpacing.xl),
            ProgressRing(
              progress: progress.clamp(0.0, 1.0),
              size: 220,
              strokeWidth: 12,
              color: pomodoro.phase == PomodoroPhase.breakTime
                  ? AppColors.success
                  : AppColors.primary,
              child: Text(
                _formatTime(pomodoro.secondsRemaining),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '${AppStrings.pomodoroCompleted}: ${pomodoro.completedPomodoros}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary(brightness),
                  ),
            ),
            const Spacer(),
            if (pomodoro.phase == PomodoroPhase.idle) ...[
              AppButton(
                label: AppStrings.startFocus,
                onPressed: notifier.startFocus,
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: pomodoro.isRunning ? notifier.pause : notifier.resume,
                      child: Text(
                        pomodoro.isRunning
                            ? AppStrings.timerPause
                            : AppStrings.timerStart,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: AppStrings.timerStop,
                      onPressed: () async {
                        final completed = notifier.stop();
                        if (completed == true && context.mounted) {
                          await rewardFocusSession(ref, context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              if (pomodoro.phase == PomodoroPhase.breakTime &&
                  !pomodoro.isRunning) ...[
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: AppStrings.skipBreak,
                  variant: AppButtonVariant.ghost,
                  onPressed: () {
                    notifier.stop();
                    notifier.startFocus();
                  },
                ),
              ],
            ],
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => context.push('/vazifalar'),
              child: Text(AppStrings.viewAll),
            ),
          ],
        ),
      ),
    );
  }
}
