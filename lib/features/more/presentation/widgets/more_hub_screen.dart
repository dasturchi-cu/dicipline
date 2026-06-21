import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/design_tokens.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/capture/presentation/providers/capture_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/calm_ui.dart';
import 'package:rejabon_ai/shared/widgets/hub_module_card.dart';

/// Boshqa markazi — asosiy modullar + Life OS + yig'iladigan qo'shimcha.
class MoreHubScreen extends ConsumerWidget {
  const MoreHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxProvider);
    final eventsAsync = ref.watch(calendarEventsProvider);

    if (inboxAsync.isLoading || eventsAsync.isLoading) {
      return const Scaffold(body: SafeArea(child: AppLoadingState()));
    }

    final inboxCount = inboxAsync.value?.length ?? 0;
    final events = eventsAsync.value ?? [];
    final now = DateTime.now();
    final upcoming = events
        .where((e) => e.startTime.isAfter(now.subtract(const Duration(hours: 1))))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final nextEvent = upcoming.isEmpty ? null : upcoming.first;

    final brightness = Theme.of(context).brightness;
    final bottomPad = ContentInsets.shellScrollBottom(context);

    Widget gap() => const SizedBox(height: AppSpacing.sm);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
          ),
          children: [
            CalmPageHeader(
              title: AppStrings.moreHub,
              subtitle: AppStrings.moreHubMvpSubtitle,
            ),
            const CalmSectionTitle(title: AppStrings.quickActions),
            HubModuleCard(
              index: 0,
              title: AppStrings.aiCoach,
              subtitle: AppStrings.aiAdvice,
              icon: Icons.psychology_rounded,
              accentColor: AppColors.accent,
              onTap: () => context.push('/boshqa/murabbiy'),
            ),
            gap(),
            HubModuleCard(
              index: 1,
              title: AppStrings.smartInbox,
              subtitle: inboxCount > 0
                  ? '$inboxCount kutmoqda'
                  : AppStrings.inboxEmptyDesc,
              icon: Icons.inbox_rounded,
              accentColor: AppColors.fire,
              badge: inboxCount > 0 ? '$inboxCount' : null,
              onTap: () => context.push('/boshqa/inbox'),
            ),
            gap(),
            HubModuleCard(
              index: 2,
              title: AppStrings.analyticsHub,
              subtitle: AppStrings.analyticsSubtitle,
              icon: Icons.insights_rounded,
              accentColor: AppColors.moduleAnalytics,
              onTap: () => context.push('/boshqa/analitika'),
            ),
            gap(),
            HubModuleCard(
              index: 3,
              title: AppStrings.secondBrain,
              subtitle: AppStrings.secondBrainDesc,
              icon: Icons.psychology_alt_rounded,
              accentColor: AppColors.primary,
              onTap: () => context.push('/boshqa/ikkinchi-miya'),
            ),
            gap(),
            HubModuleCard(
              index: 4,
              title: AppStrings.focusMode,
              subtitle: AppStrings.pomodoroCompleted,
              icon: Icons.center_focus_strong_rounded,
              accentColor: AppColors.gold,
              onTap: () => context.push('/boshqa/fokus'),
            ),
            gap(),
            HubModuleCard(
              index: 5,
              title: AppStrings.calendar,
              subtitle: nextEvent != null
                  ? '${AppStrings.nextEvent}: ${nextEvent.title}'
                  : AppStrings.noUpcomingEvents,
              icon: Icons.calendar_month_rounded,
              accentColor: AppColors.accent,
              onTap: () => context.push('/boshqa/kalendar'),
            ),
            const SizedBox(height: AppSpacing.lg),
            CalmSectionTitle(title: AppStrings.moreHubLifeOs),
            HubModuleCard(
              index: 6,
              title: AppStrings.lifeTwin,
              subtitle: AppStrings.lifeTwinDesc,
              icon: Icons.psychology_alt_rounded,
              accentColor: AppColors.primary,
              onTap: () => context.push('/boshqa/life-twin'),
            ),
            gap(),
            HubModuleCard(
              index: 7,
              title: AppStrings.decisionAssistant,
              subtitle: AppStrings.decisionDesc,
              icon: Icons.help_outline_rounded,
              accentColor: AppColors.accent,
              onTap: () => context.push('/boshqa/qaror-yordam'),
            ),
            gap(),
            HubModuleCard(
              index: 8,
              title: AppStrings.actionEngine,
              subtitle: AppStrings.actionEngineDesc,
              icon: Icons.auto_fix_high_rounded,
              accentColor: AppColors.fire,
              onTap: () => context.push('/boshqa/action-engine'),
            ),
            gap(),
            HubModuleCard(
              index: 9,
              title: AppStrings.lifeMap,
              subtitle: AppStrings.lifeMapOverall,
              icon: Icons.map_rounded,
              accentColor: AppColors.gold,
              onTap: () => context.push('/boshqa/life-map'),
            ),
            const SizedBox(height: AppSpacing.lg),
            CalmExpandableSection(
              title: AppStrings.moreHubAdvanced,
              children: [
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.navCharacter,
                  subtitle: AppStrings.characterStats,
                  icon: Icons.shield_outlined,
                  accentColor: AppColors.primary,
                  onTap: () => context.push('/qahramon'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.achievements,
                  subtitle: AppStrings.shareAchievement,
                  icon: Icons.emoji_events_outlined,
                  accentColor: AppColors.gold,
                  onTap: () => context.push('/qahramon/yutuqlar'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.challenges,
                  subtitle: AppStrings.challenges,
                  icon: Icons.emoji_events_rounded,
                  accentColor: AppColors.fire,
                  onTap: () => context.push('/boshqa/musobaqalar'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.ceoWeeklyReview,
                  subtitle: AppStrings.weeklyReport,
                  icon: Icons.summarize_rounded,
                  accentColor: AppColors.secondary,
                  onTap: () => context.push('/boshqa/ceo-hisobot'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.settings,
                  subtitle: AppStrings.preferences,
                  icon: Icons.tune_rounded,
                  accentColor: AppColors.textSecondary(brightness),
                  onTap: () => context.push('/boshqa/sozlamalar'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.notes,
                  subtitle: AppStrings.notes,
                  icon: Icons.sticky_note_2_rounded,
                  accentColor: AppColors.moduleNote,
                  onTap: () => context.push('/boshqa/eslatmalar'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.documents,
                  subtitle: AppStrings.noDocumentsDesc,
                  icon: Icons.folder_rounded,
                  accentColor: AppColors.textSecondary(brightness),
                  onTap: () => context.push('/boshqa/hujjatlar'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.voiceCoach,
                  subtitle: AppStrings.voiceCoachDesc,
                  icon: Icons.mic_rounded,
                  accentColor: AppColors.accent,
                  onTap: () => context.push('/boshqa/murabbiy/ovoz'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.aiPlanning,
                  subtitle: AppStrings.voiceToPlanDesc,
                  icon: Icons.event_note_rounded,
                  accentColor: AppColors.accent,
                  onTap: () => context.push('/reja'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.futureSimulator,
                  subtitle: AppStrings.simulationDesc,
                  icon: Icons.timeline_rounded,
                  accentColor: AppColors.secondary,
                  onTap: () => context.push('/hayot/simulyator'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.aiMemory,
                  subtitle: AppStrings.aiMemoryDesc,
                  icon: Icons.memory_rounded,
                  accentColor: AppColors.primary,
                  onTap: () => context.push('/boshqa/xotira'),
                ),
              ],
            ),
            SizedBox(height: bottomPad),
          ],
        ),
      ),
    );
  }
}
