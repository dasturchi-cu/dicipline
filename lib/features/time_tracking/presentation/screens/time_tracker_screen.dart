import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/content_insets.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/module_screen.dart';
import '../../domain/time_tracker_notifier.dart';
import '../../../capture/presentation/providers/capture_providers.dart';

class TimeTrackerScreen extends ConsumerWidget {
  const TimeTrackerScreen({super.key});

  static const _types = [
    ('study', '📚', 'Ta\'lim'),
    ('programming', '💻', 'Dasturlash'),
    ('workout', '💪', 'Mashq'),
    ('focus', '🎯', 'Fokus'),
    ('reading', '📖', 'O\'qish'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timeTrackerProvider);
    final notifier = ref.read(timeTrackerProvider.notifier);
    final brightness = Theme.of(context).brightness;

    final hours = timer.elapsedSeconds ~/ 3600;
    final minutes = (timer.elapsedSeconds % 3600) ~/ 60;
    final seconds = timer.elapsedSeconds % 60;
    final display =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return ModuleScreen(
      title: AppStrings.timeTracking,
      showBackButton: true,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          ContentInsets.shellScrollBottom(context),
        ),
        children: [
          AppCard(
            variant: AppCardVariant.outlined,
            child: Column(
              children: [
                Text(
                  display,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  timer.label.isNotEmpty ? timer.label : AppStrings.selectSession,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary(brightness),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.sessionType,
            style: AppTypography.sectionLabel(brightness),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _types.map((t) {
              final selected = timer.sessionType == t.$1;
              return ChoiceChip(
                selected: selected,
                label: Text('${t.$2} ${t.$3}'),
                onSelected: timer.state == TimerState.idle
                    ? (_) => notifier.selectType(t.$1, label: t.$3)
                    : null,
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: AppStrings.timerStart,
                  onPressed: timer.state == TimerState.running
                      ? null
                      : notifier.start,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: AppStrings.timerPause,
                  variant: AppButtonVariant.secondary,
                  onPressed: timer.state == TimerState.running
                      ? notifier.pause
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: AppStrings.timerStop,
            variant: AppButtonVariant.ghost,
            onPressed: timer.state == TimerState.idle
                ? null
                : () async {
                    final secs = await notifier.stop();
                    ref.invalidate(timeLogsProvider);
                    ref.invalidate(timeAnalyticsProvider);
                    if (context.mounted && secs > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${AppStrings.sessionSaved} (${(secs / 60).round()} min)',
                          ),
                        ),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
