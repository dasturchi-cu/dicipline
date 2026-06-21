import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/repositories/goal_repository.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../../core/repositories/journal_repository.dart';
import '../../../core/repositories/task_repository.dart';
import '../../../features/briefing/domain/daily_briefing_service.dart';
import '../../../features/emotion/domain/emotion_intelligence_service.dart';

/// Kunlik brifing va emotsional intervensiya bildirishnomalari.
class RetentionNotificationHelper {
  RetentionNotificationHelper({
    required NotificationService notifications,
    required TaskRepository taskRepo,
    required HabitRepository habitRepo,
    required GoalRepository goalRepo,
    required JournalRepository journalRepo,
    DailyBriefingService? briefingService,
    EmotionIntelligenceService? emotionService,
  })  : _notifications = notifications,
        _taskRepo = taskRepo,
        _habitRepo = habitRepo,
        _goalRepo = goalRepo,
        _journalRepo = journalRepo,
        _briefing = briefingService ?? DailyBriefingService(),
        _emotion = emotionService ?? EmotionIntelligenceService();

  final NotificationService _notifications;
  final TaskRepository _taskRepo;
  final HabitRepository _habitRepo;
  final GoalRepository _goalRepo;
  final JournalRepository _journalRepo;
  final DailyBriefingService _briefing;
  final EmotionIntelligenceService _emotion;

  static const briefingId = 9001;
  static const emotionId = 9006;
  static const letterUnlockId = 9007;
  static const _emotionPushKey = 'last_emotion_push_date';

  /// Ertalab 7:00 — kunlik brifing matni bilan.
  Future<void> scheduleMorningBriefing({
    required bool enabled,
    required String userName,
    int hour = 7,
    int minute = 0,
  }) async {
    await _notifications.cancel(briefingId);
    if (!enabled) return;

    final tasks = await _taskRepo.getAll();
    final habits = await _habitRepo.getAll();
    final goals = await _goalRepo.getAll();
    final journal = await _journalRepo.getAll();
    final streak = habits.isEmpty
        ? 0
        : habits
            .map((h) => _habitRepo.calculateStreak(h))
            .fold(0, (a, b) => a > b ? a : b);
    final habitsDone = habits.where((h) {
      final today = DateTime.now();
      return h.completedDates.any((d) =>
          d.year == today.year && d.month == today.month && d.day == today.day);
    }).length;

    final briefing = _briefing.generate(
      tasks: tasks,
      habits: habits,
      goals: goals,
      journal: journal,
      longestStreak: streak,
      habitsDoneToday: habitsDone,
      habitsTotal: habits.length,
      userName: userName,
    );

    final priority = briefing.priorities.isNotEmpty
        ? briefing.priorities.first
        : briefing.aiAdvice;

    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _notifications.schedule(
      id: briefingId,
      title: '☀️ ${briefing.greeting}',
      body: priority.length > 120 ? '${priority.substring(0, 117)}...' : priority,
      scheduledDate: scheduled,
      payload: '/',
    );
  }

  /// Burnout/xavf aniqlanganda (kuniga 1 marta).
  Future<void> maybeNotifyEmotionIntervention({required bool enabled}) async {
    if (!enabled) return;

    final prefs = await SharedPreferences.getInstance();
    final todayKey = _todayKey();
    if (prefs.getString(_emotionPushKey) == todayKey) return;

    final journal = await _journalRepo.getAll();
    final tasks = await _taskRepo.getAll();
    final profile = _emotion.analyze(journal: journal, tasks: tasks);

    if (!profile.burnoutRisk &&
        !profile.depressionRisk &&
        !profile.motivationDrop) {
      return;
    }

    final insight = profile.insights.isNotEmpty
        ? profile.insights.first
        : null;
    final title = insight?.title ?? 'O\'zingizga g\'amxo\'rlik qiling 💙';
    final body = insight?.body ??
        'Bugun yengil rejim — bitta kichik qadam kifoya.';

    await _notifications.show(
      id: emotionId,
      title: title,
      body: body,
      payload: insight?.actionRoute ?? '/favqulodda',
    );
    await prefs.setString(_emotionPushKey, todayKey);
  }

  /// Kelajak xati ochildi.
  Future<void> notifyLetterUnlocked({
    required String horizonLabel,
    required int letterId,
  }) async {
    await _notifications.show(
      id: letterUnlockId,
      title: '📬 Xatingiz ochildi!',
      body: '$horizonLabel oldin yozgan xatingiz tayyor.',
      payload: '/hayot/xat/$letterId',
    );
  }

  String _todayKey() {
    final n = DateTime.now();
    return '${n.year}-${n.month}-${n.day}';
  }
}
