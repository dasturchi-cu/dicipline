import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/features/intervention/domain/coach_intervention_service.dart';

final coachInterventionServiceProvider =
    Provider<CoachInterventionService>((ref) {
  return const CoachInterventionService();
});

final avoidanceSignalProvider = Provider<AvoidanceSignal?>((ref) {
  final tasks = ref.watch(tasksProvider).valueOrNull ?? [];
  return ref.watch(coachInterventionServiceProvider).detect(tasks: tasks);
});
