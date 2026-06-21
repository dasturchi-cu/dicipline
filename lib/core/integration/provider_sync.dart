import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/ai_coach/presentation/providers/ai_coach_provider.dart';
import '../../features/ai_planning/presentation/providers/ai_planning_provider.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';
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
  invalidateDerivedProviders(ref);
}
