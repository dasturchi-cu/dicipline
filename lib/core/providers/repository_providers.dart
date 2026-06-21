import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_strings.dart';
import '../database/schemas/calendar_event_entity.dart';
import '../database/schemas/document_entity.dart';
import '../database/schemas/finance_transaction_entity.dart';
import '../database/schemas/goal_entity.dart';
import '../database/schemas/habit_entity.dart';
import '../database/schemas/journal_entry_entity.dart';
import '../database/schemas/note_entity.dart';
import '../database/schemas/plan_entity.dart';
import '../database/schemas/study_session_entity.dart';
import '../database/schemas/study_subject_entity.dart';
import '../database/schemas/task_entity.dart';
import '../database/schemas/workout_entity.dart';
import '../repositories/repositories.dart';
import '../theme/app_colors.dart';
import '../../features/ai_coach/domain/ai_coach_service.dart';
import '../../features/gamification/domain/achievement_service.dart';
import 'core_providers.dart';

export '../constants/app_categories.dart';
export '../repositories/repositories.dart';

/// Moliya kategoriyalari (O'zbek).
const financeIncomeCategories = [
  'Maosh',
  'Bonus',
  'Investitsiya',
  'Boshqa daromad',
];

const financeExpenseCategories = [
  'Oziq-ovqat',
  'Transport',
  'Uy-joy',
  'Ko\'ngilochar',
  'Sog\'liq',
  'Ta\'lim',
  'Boshqa xarajat',
];

// ── Repository providers ──────────────────────────────────────────────────────

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(isarServiceProvider).isar);
});

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(ref.watch(isarServiceProvider).isar);
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository(ref.watch(isarServiceProvider).isar);
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository(ref.watch(isarServiceProvider).isar);
});

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(ref.watch(isarServiceProvider).isar);
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository(ref.watch(isarServiceProvider).isar);
});

final studyRepositoryProvider = Provider<StudyRepository>((ref) {
  return StudyRepository(ref.watch(isarServiceProvider).isar);
});

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepository(ref.watch(isarServiceProvider).isar);
});

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepository(ref.watch(isarServiceProvider).isar);
});

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepository(ref.watch(isarServiceProvider).isar);
});

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepository(ref.watch(isarServiceProvider).isar);
});

// ── Reactive stream providers ───────────────────────────────────────────────

final tasksProvider = StreamProvider<List<TaskEntity>>((ref) {
  return ref.watch(taskRepositoryProvider).watchAll();
});

final habitsProvider = StreamProvider<List<HabitEntity>>((ref) {
  return ref.watch(habitRepositoryProvider).watchAll();
});

final goalsProvider = StreamProvider<List<GoalEntity>>((ref) {
  return ref.watch(goalRepositoryProvider).watchAll();
});

final notesProvider = StreamProvider<List<NoteEntity>>((ref) {
  return ref.watch(noteRepositoryProvider).watchAll();
});

final journalProvider = StreamProvider<List<JournalEntryEntity>>((ref) {
  return ref.watch(journalRepositoryProvider).watchAll();
});

final workoutsProvider = StreamProvider<List<WorkoutEntity>>((ref) {
  return ref.watch(workoutRepositoryProvider).watchAll();
});

final studySubjectsProvider = StreamProvider<List<StudySubjectEntity>>((ref) {
  return ref.watch(studyRepositoryProvider).watchAllSubjects();
});

final studySessionsProvider = StreamProvider<List<StudySessionEntity>>((ref) {
  return ref.watch(studyRepositoryProvider).watchAllSessions();
});

final financeTransactionsProvider =
    StreamProvider<List<FinanceTransactionEntity>>((ref) {
  return ref.watch(financeRepositoryProvider).watchAll();
});

final calendarEventsProvider = StreamProvider<List<CalendarEventEntity>>((ref) {
  return ref.watch(calendarRepositoryProvider).watchAll();
});

final documentsProvider = StreamProvider<List<DocumentEntity>>((ref) {
  return ref.watch(documentRepositoryProvider).watchAll();
});

final plansProvider = StreamProvider<List<PlanEntity>>((ref) {
  return ref.watch(planRepositoryProvider).watchAll();
});

final todayPlanProvider = StreamProvider<PlanEntity?>((ref) {
  return ref.watch(planRepositoryProvider).watchForDate(DateTime.now());
});

final upcomingPlanProvider = StreamProvider<PlanEntity?>((ref) {
  return ref.watch(planRepositoryProvider).watchAll().map((plans) {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final candidates = plans
        .where((p) {
          final d = DateTime(p.planDate.year, p.planDate.month, p.planDate.day);
          return !d.isBefore(todayNorm) && p.items.isNotEmpty;
        })
        .toList()
      ..sort((a, b) => a.planDate.compareTo(b.planDate));
    return candidates.isEmpty ? null : candidates.first;
  });
});

final planForDateProvider = StreamProvider.family<PlanEntity?, DateTime>((ref, date) {
  return ref.watch(planRepositoryProvider).watchForDate(date);
});

final upcomingEventsProvider = StreamProvider<List<CalendarEventEntity>>((ref) {
  return ref.watch(calendarRepositoryProvider).watchUpcomingEvents();
});

final financeBalanceProvider = FutureProvider<FinanceBalance>((ref) {
  return ref.watch(financeRepositoryProvider).getBalance();
});

final habitStatisticsProvider = FutureProvider<HabitStatistics>((ref) {
  return ref.watch(habitRepositoryProvider).getStatistics();
});

final workoutStatisticsProvider = FutureProvider<WorkoutStatistics>((ref) {
  return ref.watch(workoutRepositoryProvider).getStatistics();
});

final studyProgressProvider = FutureProvider<List<StudyProgress>>((ref) {
  return ref.watch(studyRepositoryProvider).getAllProgress();
});

final financeCategoryStatisticsProvider =
    FutureProvider<List<CategoryStatistics>>((ref) {
  return ref.watch(financeRepositoryProvider).getStatisticsByCategory();
});

final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final habitRepo = ref.watch(habitRepositoryProvider);
  final tasks = await ref.watch(taskRepositoryProvider).getAll();
  final habits = await habitRepo.getAll();
  final goals = await ref.watch(goalRepositoryProvider).getAll();
  final journal = await ref.watch(journalRepositoryProvider).getAll();
  return AchievementService.compute(
    tasks: tasks,
    habits: habits,
    goals: goals,
    journal: journal,
    habitRepo: habitRepo,
  );
});

// ── UI helpers ──────────────────────────────────────────────────────────────
// Feedback helpers live in shared/widgets/app_feedback.dart

int habitStreak(HabitEntity habit) {
  final dates = habit.completedDates
      .map((d) => DateTime(d.year, d.month, d.day))
      .toSet();
  if (dates.isEmpty) return 0;

  var current = DateTime.now();
  current = DateTime(current.year, current.month, current.day);
  if (!dates.contains(current)) {
    current = current.subtract(const Duration(days: 1));
  }

  var streak = 0;
  while (dates.contains(current)) {
    streak++;
    current = current.subtract(const Duration(days: 1));
  }
  return streak;
}

String moodEmoji(int mood) {
  return switch (mood) {
    1 => '😢',
    2 => '😕',
    3 => '😐',
    4 => '🙂',
    5 => '😄',
    _ => '😐',
  };
}

String moodLabel(int mood) {
  return switch (mood) {
    1 => AppStrings.moodVeryBad,
    2 => AppStrings.moodBad,
    3 => AppStrings.moodNeutral,
    4 => AppStrings.moodGood,
    5 => AppStrings.moodVeryGood,
    _ => AppStrings.moodNeutral,
  };
}

String taskPriorityLabel(int priority) {
  return switch (priority) {
    0 => AppStrings.priorityLow,
    2 => AppStrings.priorityHigh,
    _ => AppStrings.priorityMedium,
  };
}

Color taskPriorityColor(int priority) {
  return switch (priority) {
    0 => AppColors.success,
    2 => AppColors.error,
    _ => AppColors.warning,
  };
}

List<String> generateAiTips({
  required List<TaskEntity> tasks,
  required List<HabitEntity> habits,
  required List<GoalEntity> goals,
  required List<FinanceTransactionEntity> finance,
  JournalEntryEntity? journalToday,
}) {
  return AiCoachService.generateTipStrings(
    tasks: tasks,
    habits: habits,
    goals: goals,
    finance: finance,
    journalToday: journalToday,
  );
}

