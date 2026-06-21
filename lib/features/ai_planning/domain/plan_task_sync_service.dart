import '../../../core/database/schemas/plan_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/repositories/plan_repository.dart';
import '../../../core/repositories/task_repository.dart';

bool _sameMinute(DateTime a, DateTime b) =>
    a.year == b.year &&
    a.month == b.month &&
    a.day == b.day &&
    a.hour == b.hour &&
    a.minute == b.minute;

/// Reja bandlari ↔ vazifalar sinxronizatsiyasi.
class PlanTaskSyncService {
  PlanTaskSyncService(this._tasks, this._plans);

  final TaskRepository _tasks;
  final PlanRepository _plans;

  Future<void> syncPlanToTasks(PlanEntity plan) async {
    final existing = await _tasks.getAll();

    for (final item in plan.items) {
      if (item.isCompleted) continue;

      final alreadyLinked = existing.any(
        (task) =>
            task.title == item.title &&
            task.dueDate != null &&
            _sameMinute(task.dueDate!, item.startTime),
      );
      if (alreadyLinked) continue;

      final task = TaskEntity.create(
        title: item.title,
        emoji: item.emoji,
        dueDate: item.startTime,
        priority: 1,
        category: item.category,
      );
      await _tasks.save(task);
    }
  }

  Future<void> syncTaskCompletionToPlan(TaskEntity task) async {
    if (!task.isCompleted || task.dueDate == null) return;

    final plan = await _plans.getForDate(task.dueDate!);
    if (plan == null) return;

    for (var i = 0; i < plan.items.length; i++) {
      final item = plan.items[i];
      if (item.isCompleted) continue;
      if (item.title == task.title &&
          _sameMinute(item.startTime, task.dueDate!)) {
        await _plans.toggleItemComplete(plan.id, i);
        break;
      }
    }
  }
}
