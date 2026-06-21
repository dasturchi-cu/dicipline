import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/theme/app_typography.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/features/ai_coach/presentation/providers/ai_coach_provider.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';
import 'package:rejabon_ai/shared/widgets/hub_module_card.dart';

class MoreHubScreen extends ConsumerWidget {
  const MoreHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    final eventsAsync = ref.watch(calendarEventsProvider);
    final docsAsync = ref.watch(documentsProvider);
    final tipsAsync = ref.watch(aiTipsProvider);

    if (notesAsync.isLoading || eventsAsync.isLoading) {
      return const Scaffold(
        body: SafeArea(child: AppLoadingState()),
      );
    }

    if (notesAsync.hasError || eventsAsync.hasError) {
      return Scaffold(
        body: SafeArea(
          child: AppErrorState(
            onRetry: () {
              ref.invalidate(notesProvider);
              ref.invalidate(calendarEventsProvider);
            },
          ),
        ),
      );
    }

    final notes = notesAsync.value ?? [];
    final events = eventsAsync.value ?? [];
    final docs = docsAsync.value ?? [];
    final tips = tipsAsync.valueOrNull ?? [];
    final now = DateTime.now();

    final upcoming = events
        .where((e) => e.startTime.isAfter(now.subtract(const Duration(hours: 1))))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final nextEvent = upcoming.isEmpty ? null : upcoming.first;
    final tipCount = tips.length;

    final brightness = Theme.of(context).brightness;
    final bottomPad = MediaQuery.paddingOf(context).bottom + 88;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          children: [
            FadeIn(
              index: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.moreHub.toUpperCase(),
                    style: AppTypography.sectionLabel(brightness).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppStrings.moreHubSubtitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            HubModuleCard(
              index: 0,
              title: AppStrings.aiPlanning,
              subtitle: AppStrings.voiceToPlanDesc,
              icon: Icons.event_note_rounded,
              accentColor: AppColors.accent,
              gradient: AppColors.heroGradientLight,
              onTap: () => context.push('/reja'),
            ),
            const SizedBox(height: AppSpacing.sm),
            HubModuleCard(
              index: 1,
              title: AppStrings.aiCoach,
              subtitle: tipCount > 0
                  ? '$tipCount ${AppStrings.dailyRecommendations.toLowerCase()}'
                  : AppStrings.noTipsDesc,
              icon: Icons.auto_awesome_rounded,
              accentColor: AppColors.primary,
              gradient: AppColors.heroGradientLight,
              badge: tipCount > 0 ? '$tipCount' : null,
              onTap: () => context.push('/boshqa/murabbiy'),
            ),
            const SizedBox(height: AppSpacing.sm),
            HubModuleCard(
              index: 2,
              title: AppStrings.notes,
              subtitle: notes.isEmpty
                  ? AppStrings.noNotesDesc
                  : '${notes.length} ${AppStrings.notes.toLowerCase()}',
              icon: Icons.sticky_note_2_rounded,
              accentColor: AppColors.gold,
              badge: notes.isNotEmpty ? '${notes.length}' : null,
              onTap: () => context.push('/boshqa/eslatmalar'),
            ),
            const SizedBox(height: AppSpacing.sm),
            HubModuleCard(
              index: 3,
              title: AppStrings.calendar,
              subtitle: nextEvent != null
                  ? '${AppStrings.nextEvent}: ${nextEvent.title} · ${AppDateFormat.formatDateTime(nextEvent.startTime)}'
                  : AppStrings.noUpcomingEvents,
              icon: Icons.calendar_month_rounded,
              accentColor: AppColors.accent,
              badge: events.isNotEmpty ? '${events.length}' : null,
              onTap: () => context.push('/boshqa/kalendar'),
            ),
            const SizedBox(height: AppSpacing.sm),
            HubModuleCard(
              index: 4,
              title: AppStrings.documents,
              subtitle: docs.isEmpty
                  ? AppStrings.noDocumentsDesc
                  : '${docs.length} ${AppStrings.documents.toLowerCase()}',
              icon: Icons.folder_rounded,
              accentColor: AppColors.secondary,
              onTap: () => context.push('/boshqa/hujjatlar'),
            ),
            const SizedBox(height: AppSpacing.sm),
            HubModuleCard(
              index: 5,
              title: AppStrings.settings,
              subtitle: AppStrings.preferences,
              icon: Icons.tune_rounded,
              accentColor: AppColors.textSecondary(brightness),
              onTap: () => context.push('/boshqa/sozlamalar'),
            ),
            SizedBox(height: bottomPad),
          ],
        ),
      ),
    );
  }
}
