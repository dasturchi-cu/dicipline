import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/constants/app_categories.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/repositories/task_repository.dart';

import '../helpers/isar_test_helper.dart';

void main() {
  late TestIsarHandle handle;
  late TaskRepository repository;

  setUpAll(() async {
    await ensureIsarCoreInitialized();
  });

  setUp(() async {
    handle = await openTestIsar();
    repository = TaskRepository(handle.isar);
  });

  tearDown(() async {
    await closeTestIsar(handle);
  });

  test('create persists task and getById returns it', () async {
    final task = await repository.create(title: 'Test vazifa');

    expect(task.id, greaterThan(0));
    final loaded = await repository.getById(task.id);
    expect(loaded?.title, 'Test vazifa');
    expect(loaded?.isCompleted, isFalse);
  });

  test('filterByCategory and filterByPriority', () async {
    await repository.create(
      title: 'A',
      category: AppCategories.taskWork,
      priority: 2,
    );
    await repository.create(
      title: 'B',
      category: AppCategories.taskGeneral,
      priority: 0,
    );

    final work = await repository.filterByCategory(AppCategories.taskWork);
    expect(work, hasLength(1));
    expect(work.first.title, 'A');

    final high = await repository.filterByPriority(2);
    expect(high, hasLength(1));
    expect(high.first.title, 'A');
  });

  test('toggleComplete flips completion', () async {
    final task = await repository.create(title: 'Toggle me');
    final toggled = await repository.toggleComplete(task.id);

    expect(toggled?.isCompleted, isTrue);
    final again = await repository.toggleComplete(task.id);
    expect(again?.isCompleted, isFalse);
  });

  test('delete removes task', () async {
    final task = await repository.create(title: 'Delete me');
    final deleted = await repository.delete(task.id);

    expect(deleted, isTrue);
    expect(await repository.getById(task.id), isNull);
  });

  test('getOverdue returns incomplete tasks before today', () async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await repository.create(
      title: 'Kechikkan',
      dueDate: yesterday,
    );
    await repository.create(
      title: 'Bajarilgan kechikkan',
      dueDate: yesterday,
      isCompleted: true,
    );
    await repository.create(
      title: 'Kelajak',
      dueDate: DateTime.now().add(const Duration(days: 2)),
    );

    final overdue = await repository.getOverdue();
    expect(overdue, hasLength(1));
    expect(overdue.first.title, 'Kechikkan');
  });

  test('watchAll emits created tasks', () async {
    final values = <List<TaskEntity>>[];
    final sub = repository.watchAll().listen(values.add);

    await repository.create(title: 'Stream task');
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(values, isNotEmpty);
    expect(values.last.any((t) => t.title == 'Stream task'), isTrue);
    await sub.cancel();
  });
}

// Placeholder so `isNot(isarAutoIncrementPlaceholder)` reads clearly; id > 0 after save.
const isarAutoIncrementPlaceholder = 0;



