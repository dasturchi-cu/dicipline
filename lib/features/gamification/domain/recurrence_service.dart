import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/repositories/task_repository.dart';
import '../../../core/utils/date_format.dart';

DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

/// Takroriy vazifalar — avtomatik nusxa yaratish.
class RecurrenceService {
  RecurrenceService(this._taskRepo);

  final TaskRepository _taskRepo;

  /// Ilova ochilganda yoki kunlik — takroriy vazifalarni yangilaydi.
  Future<void> processRecurringTasks() async {
    final tasks = await _taskRepo.getAll();
    final templates = tasks.where(
      (t) => t.recurrenceType != 'none' && t.recurrenceTemplateId == null,
    );

    for (final template in templates) {
      await _ensureTodayInstance(template, tasks);
    }
  }

  Future<void> _ensureTodayInstance(
    TaskEntity template,
    List<TaskEntity> allTasks,
  ) async {
    final today = _normalize(DateTime.now());

    if (!_shouldOccurOnDate(template, today)) return;

    final hasInstance = allTasks.any((t) {
      if (t.recurrenceTemplateId != template.id) return false;
      if (t.dueDate == null) return AppDateFormat.isSameDay(t.createdAt, today);
      return AppDateFormat.isSameDay(t.dueDate!, today);
    });

    if (hasInstance) return;

    final instance = TaskEntity.create(
      title: template.title,
      emoji: template.emoji,
      description: template.description,
      priority: template.priority,
      category: template.category,
      lifeAreaIds: List.from(template.lifeAreaIds),
      dueDate: today,
      recurrenceType: 'none',
      recurrenceTemplateId: template.id,
    );

    await _taskRepo.save(instance);
  }

  /// Vazifa bajarilganda keyingi takrorlashni rejalashtiradi.
  Future<void> onTaskCompleted(TaskEntity task) async {
    if (task.recurrenceType == 'none' && task.recurrenceTemplateId == null) {
      return;
    }

    final templateId = task.recurrenceTemplateId ?? task.id;
    final template = await _taskRepo.getById(templateId);
    if (template == null || template.recurrenceType == 'none') return;

    final nextDate = _nextOccurrence(template, _normalize(DateTime.now()));
    template.nextRecurrenceDate = nextDate;
    await _taskRepo.save(template);
  }

  bool _shouldOccurOnDate(TaskEntity template, DateTime date) {
    if (template.recurrenceType == 'daily') return true;

    if (template.recurrenceType == 'weekly') {
      if (template.recurrenceDays.isEmpty) {
        return date.weekday == (template.createdAt.weekday);
      }
      return template.recurrenceDays.contains(date.weekday);
    }

    if (template.recurrenceType == 'monthly') {
      return date.day == template.createdAt.day;
    }

    return false;
  }

  DateTime _nextOccurrence(TaskEntity template, DateTime from) {
    var next = from.add(const Duration(days: 1));
    for (var i = 0; i < 366; i++) {
      if (_shouldOccurOnDate(template, next)) return next;
      next = next.add(const Duration(days: 1));
    }
    return from.add(const Duration(days: 1));
  }

  bool isHabitDueToday(HabitEntity habit) {
    final today = DateTime.now();
    final weekday = today.weekday;

    return switch (habit.frequencyType) {
      'daily' => true,
      'weekdays' => weekday >= 1 && weekday <= 5,
      'weekly' => habit.activeDays.isEmpty || habit.activeDays.contains(weekday),
      'custom' => habit.activeDays.isEmpty || habit.activeDays.contains(weekday),
      _ => true,
    };
  }
}
