import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rejabon_ai/core/database/schemas/inbox_item_entity.dart';
import 'package:rejabon_ai/core/database/schemas/milestone_entity.dart';
import 'package:rejabon_ai/core/database/schemas/time_log_entity.dart';
import 'package:rejabon_ai/core/providers/core_providers.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/repositories/inbox_repository.dart';
import 'package:rejabon_ai/core/repositories/milestone_repository.dart';
import 'package:rejabon_ai/core/repositories/time_log_repository.dart';
import 'package:rejabon_ai/features/capture/domain/capture_processing_service.dart';
import 'package:rejabon_ai/features/capture/domain/inbox_triage_service.dart';
import 'package:rejabon_ai/features/time_tracking/domain/time_analytics_service.dart';
import 'package:rejabon_ai/features/time_tracking/domain/time_tracker_notifier.dart';
import 'package:rejabon_ai/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:rejabon_ai/features/timeline/domain/life_timeline_service.dart';

final inboxRepositoryProvider = Provider((ref) {
  return InboxRepository(ref.watch(isarServiceProvider).isar);
});

final timeLogRepositoryProvider = Provider((ref) {
  return TimeLogRepository(ref.watch(isarServiceProvider).isar);
});

final milestoneRepositoryProvider = Provider((ref) {
  return MilestoneRepository(ref.watch(isarServiceProvider).isar);
});

final inboxProvider = StreamProvider<List<InboxItemEntity>>((ref) {
  return ref.watch(inboxRepositoryProvider).watchPending();
});

final timeLogsProvider = StreamProvider<List<TimeLogEntity>>((ref) {
  return ref.watch(timeLogRepositoryProvider).watchAll();
});

final milestonesProvider = StreamProvider<List<MilestoneEntity>>((ref) {
  return ref.watch(milestoneRepositoryProvider).watchAll();
});

final captureProcessingServiceProvider =
    Provider<CaptureProcessingService>((ref) {
  return const CaptureProcessingService();
});

final inboxTriageServiceProvider = Provider<InboxTriageService>((ref) {
  return InboxTriageService(
    taskRepository: ref.watch(taskRepositoryProvider),
    habitRepository: ref.watch(habitRepositoryProvider),
    goalRepository: ref.watch(goalRepositoryProvider),
    noteRepository: ref.watch(noteRepositoryProvider),
    inboxRepository: ref.watch(inboxRepositoryProvider),
  );
});

final timeAnalyticsServiceProvider = Provider<TimeAnalyticsService>((ref) {
  return const TimeAnalyticsService();
});

final timePeriodProvider = StateProvider<TimePeriod>((ref) => TimePeriod.week);

final timeAnalyticsProvider = FutureProvider<TimeAnalyticsReport>((ref) async {
  ref.watch(timeLogsProvider);
  ref.watch(studySessionsProvider);
  ref.watch(workoutsProvider);
  final period = ref.watch(timePeriodProvider);

  return ref.watch(timeAnalyticsServiceProvider).compute(
        timeLogs: await ref.watch(timeLogRepositoryProvider).getAll(),
        studySessions: await ref.watch(studyRepositoryProvider).getAllSessions(),
        workouts: await ref.watch(workoutRepositoryProvider).getAll(),
        period: period,
      );
});

final timeTrackerProvider =
    StateNotifierProvider<TimeTrackerNotifier, ActiveTimerSession>((ref) {
  return TimeTrackerNotifier(
    timeLogRepository: ref.watch(timeLogRepositoryProvider),
    workoutRepository: ref.watch(workoutRepositoryProvider),
    studyRepository: ref.watch(studyRepositoryProvider),
  );
});

final lifeTimelineServiceProvider = Provider<LifeTimelineService>((ref) {
  return const LifeTimelineService();
});

final lifeTimelineProvider = FutureProvider<List<TimelineEvent>>((ref) async {
  ref.watch(milestonesProvider);
  ref.watch(goalsProvider);
  ref.watch(tasksProvider);
  ref.watch(habitsProvider);
  ref.watch(studySessionsProvider);
  ref.watch(workoutsProvider);
  ref.watch(timeLogsProvider);
  ref.watch(inboxProvider);

  final achievements = await ref.watch(achievementsProvider.future);
  return ref.watch(lifeTimelineServiceProvider).build(
        milestones: await ref.watch(milestoneRepositoryProvider).getAll(),
        goals: await ref.watch(goalRepositoryProvider).getAll(),
        achievements: achievements,
        habits: await ref.watch(habitRepositoryProvider).getAll(),
        tasks: await ref.watch(taskRepositoryProvider).getAll(),
        studySessions: await ref.watch(studyRepositoryProvider).getAllSessions(),
        workouts: await ref.watch(workoutRepositoryProvider).getAll(),
        timeLogs: await ref.watch(timeLogRepositoryProvider).getAll(),
        inboxItems: await ref.watch(inboxRepositoryProvider).getAll(),
      );
});
