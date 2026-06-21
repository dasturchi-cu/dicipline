import '../../../core/database/schemas/task_entity.dart';
import '../../../core/utils/date_format.dart';

/// Prokrastinatsiya signali.
class AvoidanceSignal {
  const AvoidanceSignal({
    required this.taskId,
    required this.taskTitle,
    required this.daysOverdue,
    required this.message,
  });

  final int taskId;
  final String taskTitle;
  final int daysOverdue;
  final String message;
}

/// Kechikkan vazifalar va qochish naqshlarini aniqlaydi.
class CoachInterventionService {
  const CoachInterventionService();

  AvoidanceSignal? detect({
    required List<TaskEntity> tasks,
    DateTime? asOf,
  }) {
    final today = AppDateFormat.dateOnly(asOf ?? DateTime.now());
    TaskEntity? worst;
    var maxDays = 0;

    for (final t in tasks) {
      if (t.isCompleted || t.dueDate == null) continue;
      final due = AppDateFormat.dateOnly(t.dueDate!);
      if (!due.isBefore(today)) continue;
      final days = today.difference(due).inDays;
      if (days > maxDays) {
        maxDays = days;
        worst = t;
      }
    }

    if (worst == null || maxDays < 2) return null;

    final message = maxDays >= 5
        ? '"${worst.title}" ${maxDays} kundan beri kutilmoqda — fokus rejimini sinab ko\'ring.'
        : maxDays >= 3
            ? '"${worst.title}" uzoq vaqt kutilmoqda — 2 daqiqalik qadam bilan boshlang.'
            : '"${worst.title}" kechikmoqda — bugun bajarishga harakat qiling.';

    return AvoidanceSignal(
      taskId: worst.id,
      taskTitle: worst.title,
      daysOverdue: maxDays,
      message: message,
    );
  }
}
