import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/features/goal_execution/domain/goal_execution_service.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';

/// Maqsadga bog'langan vazifa bajarilganda progressni yangilaydi.
Future<void> syncGoalProgressFromTask(
  WidgetRef ref,
  TaskEntity task,
) async {
  if (task.goalId == null) return;

  final goalRepo = ref.read(goalRepositoryProvider);
  final goal = await goalRepo.getById(task.goalId!);
  if (goal == null) return;

  final allTasks = await ref.read(taskRepositoryProvider).getAll();
  final linked = allTasks.where((t) => t.goalId == goal.id).toList();
  if (linked.isEmpty) return;

  await ref.read(goalExecutionServiceProvider).syncProgressFromTasks(
        goal: goal,
        linkedTasks: linked,
      );
  ref.invalidate(goalsProvider);
  ref.invalidate(lifeMapDataProvider);
}
