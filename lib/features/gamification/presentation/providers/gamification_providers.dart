import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/notifications/notification_service.dart';
import 'package:rejabon_ai/core/notifications/re_engagement_notification_service.dart';
import 'package:rejabon_ai/core/providers/core_providers.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/repositories/achievement_unlock_repository.dart';
import 'package:rejabon_ai/core/repositories/player_profile_repository.dart';
import 'package:rejabon_ai/core/repositories/quest_repository.dart';
import 'package:rejabon_ai/core/repositories/xp_event_repository.dart';
import 'package:rejabon_ai/features/gamification/domain/achievement_service.dart';
import 'package:rejabon_ai/features/gamification/domain/challenge_auto_verify_service.dart';
import 'package:rejabon_ai/features/gamification/domain/quest_service.dart';
import 'package:rejabon_ai/features/gamification/domain/recurrence_service.dart';
import 'package:rejabon_ai/features/gamification/domain/xp_service.dart';
import 'package:rejabon_ai/features/platform/presentation/providers/platform_providers.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';

// ── Repository providers ─────────────────────────────────────────────────────

final playerProfileRepositoryProvider = Provider<PlayerProfileRepository>((ref) {
  return PlayerProfileRepository(ref.watch(isarServiceProvider).isar);
});

final xpEventRepositoryProvider = Provider<XpEventRepository>((ref) {
  return XpEventRepository(ref.watch(isarServiceProvider).isar);
});

final achievementUnlockRepositoryProvider =
    Provider<AchievementUnlockRepository>((ref) {
  return AchievementUnlockRepository(ref.watch(isarServiceProvider).isar);
});

final questRepositoryProvider = Provider<QuestRepository>((ref) {
  return QuestRepository(ref.watch(isarServiceProvider).isar);
});

// ── Service providers ────────────────────────────────────────────────────────

final xpServiceProvider = Provider<XpService>((ref) {
  return XpService(
    profileRepo: ref.watch(playerProfileRepositoryProvider),
    eventRepo: ref.watch(xpEventRepositoryProvider),
  );
});

final questServiceProvider = Provider<QuestService>((ref) {
  return QuestService(
    questRepo: ref.watch(questRepositoryProvider),
    xpService: ref.watch(xpServiceProvider),
    taskRepo: ref.watch(taskRepositoryProvider),
    habitRepo: ref.watch(habitRepositoryProvider),
    journalRepo: ref.watch(journalRepositoryProvider),
    workoutRepo: ref.watch(workoutRepositoryProvider),
    studyRepo: ref.watch(studyRepositoryProvider),
    financeRepo: ref.watch(financeRepositoryProvider),
  );
});

final recurrenceServiceProvider = Provider<RecurrenceService>((ref) {
  return RecurrenceService(ref.watch(taskRepositoryProvider));
});

final challengeAutoVerifyServiceProvider =
    Provider<ChallengeAutoVerifyService>((ref) {
  return ChallengeAutoVerifyService(
    challengeRepo: ref.watch(challengeRepositoryProvider),
    workoutRepo: ref.watch(workoutRepositoryProvider),
    studyRepo: ref.watch(studyRepositoryProvider),
    financeRepo: ref.watch(financeRepositoryProvider),
    planRepo: ref.watch(planRepositoryProvider),
  );
});

final reEngagementNotificationServiceProvider =
    Provider<ReEngagementNotificationService>((ref) {
  return ReEngagementNotificationService(
    notifications: NotificationService.instance,
    taskRepo: ref.watch(taskRepositoryProvider),
    habitRepo: ref.watch(habitRepositoryProvider),
  );
});

final achievementServiceProvider = Provider<AchievementService>((ref) {
  return AchievementService(
    unlockRepo: ref.watch(achievementUnlockRepositoryProvider),
    habitRepo: ref.watch(habitRepositoryProvider),
  );
});

// ── Data providers ───────────────────────────────────────────────────────────

final playerProfileProvider = StreamProvider((ref) {
  return ref.watch(playerProfileRepositoryProvider).watchProfile();
});

final xpEventsProvider = StreamProvider((ref) {
  return ref.watch(xpEventRepositoryProvider).watchRecent(limit: 30);
});

final dailyQuestsProvider = StreamProvider((ref) {
  return ref.watch(questRepositoryProvider).watchActiveForDate(DateTime.now());
});

final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  ref.watch(tasksProvider);
  ref.watch(habitsProvider);
  ref.watch(goalsProvider);
  ref.watch(journalProvider);
  ref.watch(playerProfileProvider);

  ref.watch(studySessionsProvider);

  final profile =
      await ref.watch(playerProfileRepositoryProvider).getOrCreate();
  final completedQuests =
      await ref.watch(questRepositoryProvider).countCompleted();
  final sessions =
      await ref.watch(studyRepositoryProvider).getAllSessions();
  final totalStudyMinutes =
      sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);

  return ref.watch(achievementServiceProvider).computeAndSync(
        tasks: await ref.watch(taskRepositoryProvider).getAll(),
        habits: await ref.watch(habitRepositoryProvider).getAll(),
        goals: await ref.watch(goalRepositoryProvider).getAll(),
        journal: await ref.watch(journalRepositoryProvider).getAll(),
        playerLevel: profile.level,
        completedQuests: completedQuests,
        totalStudyMinutes: totalStudyMinutes,
      );
});

/// Ilova ochilganda barcha fon xizmatlarini ishga tushiradi.
Future<void> runDailyBootstrap(WidgetRef ref) async {
  await ref.read(recurrenceServiceProvider).processRecurringTasks();
  await ref.read(questServiceProvider).verifyAndCompleteQuests();
  await ref.read(challengeAutoVerifyServiceProvider).verifyAll();

  final settings = ref.read(settingsProvider);
  await ref.read(reEngagementNotificationServiceProvider).scheduleAll(
        enabled: settings.notificationEnabled,
      );

  ref.invalidate(playerProfileProvider);
  ref.invalidate(dailyQuestsProvider);
  ref.invalidate(achievementsProvider);
}

/// XP mukofoti + provayderlarni yangilash.
Future<XpAwardResult?> awardXpAndRefresh(
  WidgetRef ref, {
  required String statType,
  required int amount,
  required String source,
  String? sourceId,
  String? description,
  bool oncePerDay = false,
}) async {
  final result = await ref.read(xpServiceProvider).award(
        statType: statType,
        amount: amount,
        source: source,
        sourceId: sourceId,
        description: description,
        oncePerDay: oncePerDay,
      );

  if (result != null) {
    ref.invalidate(playerProfileProvider);
    ref.invalidate(xpEventsProvider);
    ref.invalidate(achievementsProvider);
    await ref.read(questServiceProvider).verifyAndCompleteQuests();
    ref.invalidate(dailyQuestsProvider);
  }

  return result;
}
