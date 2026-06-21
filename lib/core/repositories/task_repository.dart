import 'package:isar/isar.dart';

import '../constants/app_categories.dart';
import '../database/schemas/task_entity.dart';

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

class TaskRepository {
  TaskRepository(this._isar);

  final Isar _isar;

  Stream<List<TaskEntity>> watchAll() {
    return _isar.taskEntitys
        .where()
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<TaskEntity>> watchByCategory(String category) {
    return _isar.taskEntitys
        .filter()
        .categoryEqualTo(category)
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<TaskEntity>> watchByPriority(int priority) {
    return _isar.taskEntitys
        .filter()
        .priorityEqualTo(priority)
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<TaskEntity?> getById(int id) {
    return _isar.taskEntitys.get(id);
  }

  Future<List<TaskEntity>> getAll() {
    return _isar.taskEntitys.where().sortByUpdatedAtDesc().findAll();
  }

  Future<List<TaskEntity>> filterByCategory(String category) {
    return _isar.taskEntitys
        .filter()
        .categoryEqualTo(category)
        .sortByUpdatedAtDesc()
        .findAll();
  }

  Future<List<TaskEntity>> filterByPriority(int priority) {
    return _isar.taskEntitys
        .filter()
        .priorityEqualTo(priority)
        .sortByUpdatedAtDesc()
        .findAll();
  }

  Future<List<TaskEntity>> getOverdue() async {
    final today = _normalizeDate(DateTime.now());
    final tasks = await _isar.taskEntitys
        .filter()
        .isCompletedEqualTo(false)
        .dueDateIsNotNull()
        .findAll();
    return tasks
        .where((task) {
          final due = task.dueDate;
          return due != null && _normalizeDate(due).isBefore(today);
        })
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }

  Future<TaskEntity> create({
    required String title,
    String? description,
    bool isCompleted = false,
    int priority = 1,
    String? category,
    DateTime? dueDate,
  }) async {
    final task = TaskEntity.create(
      title: title,
      description: description,
      isCompleted: isCompleted,
      priority: priority,
      category: category ?? AppCategories.taskGeneral,
      dueDate: dueDate,
    );
    await _isar.writeTxn(() async {
      await _isar.taskEntitys.put(task);
    });
    return task;
  }

  Future<TaskEntity> update(TaskEntity task) async {
    task.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.taskEntitys.put(task);
    });
    return task;
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.taskEntitys.delete(id));
  }

  Future<TaskEntity> save(TaskEntity task) => update(task);

  Future<TaskEntity?> toggleComplete(Object taskOrId) async {
    final id = taskOrId is TaskEntity ? taskOrId.id : taskOrId as int;
    final task = await getById(id);
    if (task == null) return null;
    task.isCompleted = !task.isCompleted;
    return update(task);
  }
}
