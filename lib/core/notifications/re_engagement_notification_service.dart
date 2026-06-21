import '../../../core/notifications/notification_service.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../../core/repositories/task_repository.dart';

/// Qayta jalb qilish bildirishnomalari — streak, vazifa, kechki tekshiruv.
class ReEngagementNotificationService {
  ReEngagementNotificationService({
    required NotificationService notifications,
    required TaskRepository taskRepo,
    required HabitRepository habitRepo,
  })  : _notifications = notifications,
        _taskRepo = taskRepo,
        _habitRepo = habitRepo;

  final NotificationService _notifications;
  final TaskRepository _taskRepo;
  final HabitRepository _habitRepo;

  static const streakRiskId = 9002;
  static const eveningId = 9003;
  static const questId = 9004;
  // morningId 9001 — RetentionNotificationHelper.scheduleMorningBriefing

  /// Barcha qayta jalb qilish bildirishnomalarini rejalashtiradi.
  Future<void> scheduleAll({required bool enabled}) async {
    await _notifications.cancel(streakRiskId);
    await _notifications.cancel(eveningId);
    await _notifications.cancel(questId);

    if (!enabled) return;

    final now = DateTime.now();

    // Kechqurun 20:00 — streak xavfi
    var streakCheck = DateTime(now.year, now.month, now.day, 20, 0);
    if (streakCheck.isBefore(now)) {
      streakCheck = streakCheck.add(const Duration(days: 1));
    }
    await _scheduleStreakReminder(streakCheck);

    // Kechqurun 21:30 — kunlik xulosa
    var evening = DateTime(now.year, now.month, now.day, 21, 30);
    if (evening.isBefore(now)) {
      evening = evening.add(const Duration(days: 1));
    }
    await _notifications.schedule(
      id: eveningId,
      title: 'Kun yakuni 🌙',
      body: 'Bugungi yutuqlaringizni ko\'rib chiqing.',
      scheduledDate: evening,
      payload: '/qahramon',
    );
  }

  Future<void> _scheduleStreakReminder(DateTime when) async {
    final habits = await _habitRepo.getAll();
    final incomplete = habits.where((h) => !h.completedDates.any((d) {
          final today = DateTime.now();
          return d.year == today.year &&
              d.month == today.month &&
              d.day == today.day;
        }));

    if (incomplete.isEmpty) return;

    await _notifications.schedule(
      id: streakRiskId,
      title: 'Streak xavfi! 🔥',
      body:
          '${incomplete.length} ta odat hali bajarilmagan. Streakni saqlang!',
      scheduledDate: when,
      payload: '/hayot/odatlar',
    );
  }

  /// Kechiktirilgan vazifalar uchun darhol ogohlantirish.
  Future<void> notifyOverdueTasks() async {
    final overdue = await _taskRepo.getOverdue();
    if (overdue.isEmpty) return;

    await _notifications.show(
      id: 9005,
      title: 'Kechikkan vazifalar ⏰',
      body: '${overdue.length} ta vazifa muddatidan o\'tgan.',
      payload: '/vazifalar',
    );
  }
}
