import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/intelligence/coach_context_providers.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../domain/ai_coach_service.dart';

final aiCoachServiceProvider = Provider<AiCoachService>((ref) {
  return AiCoachService(
    taskRepository: ref.watch(taskRepositoryProvider),
    habitRepository: ref.watch(habitRepositoryProvider),
    goalRepository: ref.watch(goalRepositoryProvider),
    financeRepository: ref.watch(financeRepositoryProvider),
    journalRepository: ref.watch(journalRepositoryProvider),
    planRepository: ref.watch(planRepositoryProvider),
    aiService: ref.watch(aiServiceProvider),
  );
});

final aiTipsProvider = FutureProvider<List<AiTip>>((ref) async {
  final service = ref.watch(aiCoachServiceProvider);
  final context = ref.watch(coachContextProvider);
  return service.generateRecommendations(
    coachContextBlock: formatCoachContextBlock(context),
  );
});

final aiTipsRefreshProvider = Provider<void Function()>((ref) {
  return () => ref.invalidate(aiTipsProvider);
});
