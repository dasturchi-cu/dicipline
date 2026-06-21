import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/repositories/goal_repository.dart';
import 'package:rejabon_ai/core/repositories/plan_repository.dart';
import 'package:rejabon_ai/core/repositories/task_repository.dart';
import 'package:rejabon_ai/features/goal_execution/domain/goal_execution_service.dart';
import '../helpers/isar_test_helper.dart';

void main() {
  group('GoalExecutionService', () {
    late TestIsarHandle handle;
    late GoalExecutionService service;

    setUp(() async {
      handle = await openTestIsar();
      service = GoalExecutionService(
        goalRepo: GoalRepository(handle.isar),
        taskRepo: TaskRepository(handle.isar),
        planRepo: PlanRepository(handle.isar),
      );
    });

    tearDown(() => closeTestIsar(handle));

    test('creates IELTS milestones and linked tasks', () async {
      final goal = GoalEntity.create(title: 'IELTS 7.0', progress: 0);
      await GoalRepository(handle.isar).save(goal);

      final plan = await service.executeGoal(goal: goal);

      expect(plan.milestonesCreated, greaterThan(0));
      expect(plan.tasksCreated, greaterThan(0));
      expect(plan.summary, contains('IELTS 7.0'));

      final saved = await GoalRepository(handle.isar).getById(goal.id);
      expect(saved!.milestones, isNotEmpty);
      expect(saved.progress, greaterThanOrEqualTo(5));

      final tasks = await TaskRepository(handle.isar).getAll();
      expect(tasks.any((t) => t.goalId == goal.id), isTrue);
    });
  });
}
