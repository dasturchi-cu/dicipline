import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/features/ai_coach/presentation/providers/ai_coach_provider.dart';
import 'package:rejabon_ai/core/intelligence/intelligence_providers.dart';
import 'package:rejabon_ai/features/retention/presentation/providers/retention_providers.dart';
import '../../features/ai_planning/presentation/providers/ai_planning_provider.dart';
import '../../features/gamification/presentation/providers/gamification_providers.dart';
import '../../features/capture/presentation/providers/capture_providers.dart';
import '../../features/life_os/presentation/providers/life_os_providers.dart';
import '../../features/phase2/presentation/providers/phase2_providers.dart';
import '../../features/platform/presentation/providers/platform_providers.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';
import '../notifications/retention_notification_providers.dart';
import '../notifications/calendar_notification_helper.dart';
import '../notifications/plan_notification_helper.dart';
import '../providers/core_providers.dart';
import '../providers/repository_providers.dart';

/// AI tavsiyalar, hayot balli, hisobotlar va yutuqlarni yangilaydi.
void invalidateDerivedProviders(WidgetRef ref) {
  ref.invalidate(aiTipsProvider);
  ref.invalidate(lifeScoreProvider);
  ref.invalidate(dailyReviewProvider);
  ref.invalidate(weeklyReviewProvider);
  ref.invalidate(rescheduleSuggestionsProvider);
  ref.invalidate(achievementsProvider);
  ref.invalidate(analyticsInsightsProvider);
  ref.invalidate(lifeBalanceProvider);
  ref.invalidate(lifeDirectionProvider);
  ref.invalidate(ceoWeeklyReviewProvider);
  ref.invalidate(inboxProvider);
  ref.invalidate(timeLogsProvider);
  ref.invalidate(timeAnalyticsProvider);
  ref.invalidate(lifeTimelineProvider);
  ref.invalidate(milestonesProvider);
  ref.invalidate(playerProfileProvider);
  ref.invalidate(dailyQuestsProvider);
  ref.invalidate(xpEventsProvider);
  ref.invalidate(moodTrendProvider);
  ref.invalidate(coachContextProvider);
  ref.invalidate(lifeBrainInsightsProvider);
  ref.invalidate(lifeBrainTopInsightProvider);
  ref.invalidate(dailyBriefingProvider);
  ref.invalidate(lifeHeatmapProvider);
  ref.invalidate(emotionProfileProvider);
  ref.invalidate(memoryContextProvider);
  invalidatePhase2Providers(ref);
}

/// Reja bilan bog'liq provayderlarni yangilaydi.
void invalidatePlanProviders(WidgetRef ref, {DateTime? planDate}) {
  ref.invalidate(plansProvider);
  ref.invalidate(todayPlanProvider);
  ref.invalidate(upcomingPlanProvider);
  if (planDate != null) {
    ref.invalidate(planForDateProvider(planDate));
  }
  invalidateDerivedProviders(ref);
}

/// Kalendar va reja bildirishnomalarini qayta rejalashtiradi.
Future<void> syncAllNotifications(WidgetRef ref) async {
  final settings = ref.read(settingsProvider);
  if (!settings.notificationEnabled) {
    await ref.read(notificationServiceProvider).cancelAll();
    return;
  }
  final events = await ref.read(calendarRepositoryProvider).getAll();
  await ref.read(calendarNotificationHelperProvider).rescheduleAll(
        notificationsEnabled: true,
        events: events,
      );
  final plans = await ref.read(planRepositoryProvider).getAll();
  await ref.read(planNotificationHelperProvider).rescheduleAll(
        notificationsEnabled: true,
        leadMinutes: settings.notificationLeadMinutes,
        plans: plans,
      );
  await ref.read(reEngagementNotificationServiceProvider).scheduleAll(
        enabled: settings.notificationEnabled,
      );
  await scheduleRetentionNotifications(ref);
}

/// O'tkazib yuborilgan reja bandlarini belgilaydi.
Future<void> refreshMissedPlanState(WidgetRef ref) async {
  await ref.read(planRepositoryProvider).markMissedItems(DateTime.now());
  ref.invalidate(rescheduleSuggestionsProvider);
  ref.invalidate(todayPlanProvider);
  ref.invalidate(planForDateProvider(DateTime.now()));
}

/// Barcha ma'lumot va AI provayderlarini yangilaydi (backup tiklash).
void invalidateAllDataProviders(WidgetRef ref) {
  ref.invalidate(tasksProvider);
  ref.invalidate(habitsProvider);
  ref.invalidate(goalsProvider);
  ref.invalidate(notesProvider);
  ref.invalidate(journalProvider);
  ref.invalidate(workoutsProvider);
  ref.invalidate(studySubjectsProvider);
  ref.invalidate(studySessionsProvider);
  ref.invalidate(financeTransactionsProvider);
  ref.invalidate(calendarEventsProvider);
  ref.invalidate(documentsProvider);
  ref.invalidate(plansProvider);
  ref.invalidate(todayPlanProvider);
  ref.invalidate(upcomingPlanProvider);
  ref.invalidate(upcomingEventsProvider);
  ref.invalidate(financeBalanceProvider);
  ref.invalidate(habitStatisticsProvider);
  ref.invalidate(workoutStatisticsProvider);
  ref.invalidate(studyProgressProvider);
  ref.invalidate(financeCategoryStatisticsProvider);
  ref.invalidate(monthlyFocusProvider);
  ref.invalidate(aiMemoriesProvider);
  ref.invalidate(activeChallengesProvider);
  ref.invalidate(analyticsInsightsProvider);
  ref.invalidate(aiMemoryInsightsProvider);
  ref.invalidate(yesterdayReviewProvider);
  ref.invalidate(lifeBalanceProvider);
  ref.invalidate(lifeDirectionProvider);
  ref.invalidate(ceoWeeklyReviewProvider);
  ref.invalidate(inboxProvider);
  ref.invalidate(timeLogsProvider);
  ref.invalidate(timeAnalyticsProvider);
  ref.invalidate(lifeTimelineProvider);
  ref.invalidate(milestonesProvider);
  ref.invalidate(playerProfileProvider);
  ref.invalidate(dailyQuestsProvider);
  invalidateDerivedProviders(ref);
}
