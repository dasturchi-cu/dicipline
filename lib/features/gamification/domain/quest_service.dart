import '../../../core/database/schemas/finance_transaction_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/quest_entity.dart';
import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';
import '../../../core/repositories/finance_repository.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../../core/repositories/journal_repository.dart';
import '../../../core/repositories/quest_repository.dart';
import '../../../core/repositories/study_repository.dart';
import '../../../core/repositories/task_repository.dart';
import '../../../core/repositories/workout_repository.dart';
import '../../../core/utils/date_format.dart';
import 'models/rpg_models.dart';
import 'xp_service.dart';

DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

/// Kunlik va haftalik questlar — avtomatik yaratish va tekshirish.
class QuestService {
  QuestService({
    required QuestRepository questRepo,
    required XpService xpService,
    required TaskRepository taskRepo,
    required HabitRepository habitRepo,
    required JournalRepository journalRepo,
    required WorkoutRepository workoutRepo,
    required StudyRepository studyRepo,
    required FinanceRepository financeRepo,
  })  : _questRepo = questRepo,
        _xpService = xpService,
        _taskRepo = taskRepo,
        _habitRepo = habitRepo,
        _journalRepo = journalRepo,
        _workoutRepo = workoutRepo,
        _studyRepo = studyRepo,
        _financeRepo = financeRepo;

  final QuestRepository _questRepo;
  final XpService _xpService;
  final TaskRepository _taskRepo;
  final HabitRepository _habitRepo;
  final JournalRepository _journalRepo;
  final WorkoutRepository _workoutRepo;
  final StudyRepository _studyRepo;
  final FinanceRepository _financeRepo;

  /// Bugun va shu hafta uchun questlarni yaratadi.
  Future<void> ensureQuestsForToday() async {
    final today = _normalize(DateTime.now());
    await _questRepo.deleteExpiredBefore(today.subtract(const Duration(days: 30)));

    for (final template in QuestTemplates.daily) {
      final existing = await _questRepo.findQuest(
        questType: 'daily',
        questId: template.id,
        startDate: today,
      );
      if (existing == null) {
        await _questRepo.save(
          QuestEntity.create(
            questType: 'daily',
            questId: template.id,
            title: template.title,
            description: template.description,
            statReward: template.statReward,
            xpReward: template.xpReward,
            verificationType: template.verificationType,
            startDate: today,
            endDate: today,
          ),
        );
      }
    }

    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    for (final template in QuestTemplates.weekly) {
      final existing = await _questRepo.findQuest(
        questType: 'weekly',
        questId: template.id,
        startDate: weekStart,
      );
      if (existing == null) {
        await _questRepo.save(
          QuestEntity.create(
            questType: 'weekly',
            questId: template.id,
            title: template.title,
            description: template.description,
            statReward: template.statReward,
            xpReward: template.xpReward,
            verificationType: template.verificationType,
            startDate: weekStart,
            endDate: weekEnd,
          ),
        );
      }
    }
  }

  /// Barcha faol questlarni tekshiradi va bajarilganlariga XP beradi.
  Future<List<QuestEntity>> verifyAndCompleteQuests() async {
    await ensureQuestsForToday();
    final today = _normalize(DateTime.now());
    final quests = await _questRepo.getActiveForDate(today);
    final completed = <QuestEntity>[];

    final tasks = await _taskRepo.getAll();
    final habits = await _habitRepo.getAll();
    final journalToday = await _journalRepo.getToday();
    final workouts = await _workoutRepo.getAll();
    final sessions = await _studyRepo.getAllSessions();
    final finance = await _financeRepo.getAll();

    final journalEntries = await _journalRepo.getAll();
    final journalDaysInWeek = journalEntries.where((e) {
      if (e.content.trim().isEmpty) return false;
      final d = _normalize(e.date);
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      return !d.isBefore(weekStart) && !d.isAfter(today);
    }).length;

    for (final quest in quests) {
      if (quest.completed) continue;
      final done = _isQuestComplete(
        quest,
        tasks: tasks,
        habits: habits,
        journalToday: journalToday,
        workouts: workouts,
        sessions: sessions,
        finance: finance,
        journalDaysInWeek: journalDaysInWeek,
      );
      if (done) {
        await _questRepo.complete(quest);
        await _xpService.awardQuest(
          quest.xpReward,
          quest.statReward,
          quest.questId,
        );
        completed.add(quest);
      }
    }

    return completed;
  }

  bool _isQuestComplete(
    QuestEntity quest, {
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required JournalEntryEntity? journalToday,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> sessions,
    required List<FinanceTransactionEntity> finance,
    required int journalDaysInWeek,
  }) {
    final today = _normalize(DateTime.now());
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    return switch (quest.questId) {
      'tasks_3' => _tasksCompletedToday(tasks, today) >= 3,
      'habits_all' =>
        habits.isNotEmpty && _habitsCompletedToday(habits, today) == habits.length,
      'journal' =>
        journalToday != null && journalToday.content.trim().isNotEmpty,
      'workouts_5' => _workoutsInRange(workouts, weekStart, today) >= 5,
      'study_120' => _studyMinutesInRange(sessions, weekStart, today) >= 120,
      'journal_5' => journalDaysInWeek >= 5,
      _ => false,
    };
  }

  int _tasksCompletedToday(List<TaskEntity> tasks, DateTime today) {
    return tasks.where((t) {
      if (!t.isCompleted) return false;
      return AppDateFormat.isSameDay(t.updatedAt, today);
    }).length;
  }

  int _habitsCompletedToday(List<HabitEntity> habits, DateTime today) {
    return habits.where((h) {
      return h.completedDates.any((d) => AppDateFormat.isSameDay(d, today));
    }).length;
  }

  int _workoutsInRange(
    List<WorkoutEntity> workouts,
    DateTime start,
    DateTime end,
  ) {
    return workouts.where((w) {
      final d = _normalize(w.date);
      return !d.isBefore(start) && !d.isAfter(end);
    }).length;
  }

  int _studyMinutesInRange(
    List<StudySessionEntity> sessions,
    DateTime start,
    DateTime end,
  ) {
    return sessions.where((s) {
      final d = _normalize(s.date);
      return !d.isBefore(start) && !d.isAfter(end);
    }).fold(0, (sum, s) => sum + s.durationMinutes);
  }
}
