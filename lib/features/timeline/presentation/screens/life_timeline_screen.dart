import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/content_insets.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/fade_in.dart';
import '../../../../shared/widgets/module_screen.dart';
import '../../../capture/presentation/providers/capture_providers.dart';
import '../../../timeline/domain/life_timeline_service.dart';

class LifeTimelineScreen extends ConsumerWidget {
  const LifeTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(lifeTimelineProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.lifeTimeline,
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.emoji_events_outlined),
          tooltip: AppStrings.achievementTimeline,
          onPressed: () => context.push('/hayot/yutuqlar'),
        ),
      ],
      body: timelineAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          onRetry: () => ref.invalidate(lifeTimelineProvider),
        ),
        data: (events) {
          if (events.isEmpty) {
            return AppEmptyState(
              icon: Icons.timeline_rounded,
              title: AppStrings.timelineEmpty,
              description: AppStrings.timelineEmptyDesc,
            );
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              ContentInsets.shellScrollBottom(context),
            ),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final event = events[index];
              return FadeIn(
                child: AppCard(
                  onTap: event.route != null
                      ? () => context.push(event.route!)
                      : null,
                  child: Row(
                    children: [
                      Text(event.emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              event.subtitle,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              AppDateFormat.formatDate(event.date),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
