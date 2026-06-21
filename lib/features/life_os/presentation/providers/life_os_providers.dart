import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/features/capture/presentation/providers/capture_providers.dart';
import 'package:rejabon_ai/features/ceo_review/domain/ceo_weekly_review_service.dart';
import 'package:rejabon_ai/features/life_areas/domain/life_area_score_service.dart';
import 'package:rejabon_ai/features/life_direction/domain/life_direction_service.dart';
import 'package:rejabon_ai/features/platform/presentation/providers/platform_providers.dart';
import 'package:rejabon_ai/features/second_brain/domain/second_brain_search_service.dart';

final lifeAreaScoreServiceProvider = Provider<LifeAreaScoreService>((ref) {
  return LifeAreaScoreService(
    habitRepository: ref.watch(habitRepositoryProvider),
  );
});

final lifeDirectionServiceProvider = Provider<LifeDirectionService>((ref) {
  return LifeDirectionService();
});

final ceoWeeklyReviewServiceProvider = Provider<CeoWeeklyReviewService>((ref) {
  return CeoWeeklyReviewService(
    habitRepository: ref.watch(habitRepositoryProvider),
  );
});

final secondBrainSearchServiceProvider =
    Provider<SecondBrainSearchService>((ref) {
  return SecondBrainSearchService();
});

final lifeBalanceProvider = FutureProvider<LifeBalanceReport>((ref) async {
  ref.watch(tasksProvider);
  ref.watch(habitsProvider);
  ref.watch(goalsProvider);
  ref.watch(plansProvider);
  ref.watch(timeLogsProvider);

  final service = ref.watch(lifeAreaScoreServiceProvider);
  return service.compute(
    tasks: await ref.watch(taskRepositoryProvider).getAll(),
    habits: await ref.watch(habitRepositoryProvider).getAll(),
    goals: await ref.watch(goalRepositoryProvider).getAll(),
    plans: await ref.watch(planRepositoryProvider).getAll(),
    workouts: await ref.watch(workoutRepositoryProvider).getAll(),
    studySessions: await ref.watch(studyRepositoryProvider).getAllSessions(),
    finance: await ref.watch(financeRepositoryProvider).getAll(),
    timeLogs: await ref.watch(timeLogRepositoryProvider).getAll(),
  );
});

final lifeDirectionProvider = FutureProvider<LifeDirectionReport>((ref) async {
  ref.watch(tasksProvider);
  ref.watch(habitsProvider);
  ref.watch(goalsProvider);
  ref.watch(monthlyFocusProvider);

  final balance = await ref.watch(lifeBalanceProvider.future);
  final focus = await ref.watch(monthlyFocusRepositoryProvider).getForMonth(
        DateTime.now(),
      );

  return ref.watch(lifeDirectionServiceProvider).evaluate(
        tasks: await ref.watch(taskRepositoryProvider).getAll(),
        habits: await ref.watch(habitRepositoryProvider).getAll(),
        goals: await ref.watch(goalRepositoryProvider).getAll(),
        balance: balance,
        monthlyFocus: focus,
      );
});

final ceoWeeklyReviewProvider = FutureProvider<CeoWeeklyReport>((ref) async {
  ref.watch(tasksProvider);
  ref.watch(habitsProvider);
  ref.watch(goalsProvider);
  ref.watch(plansProvider);

  return ref.watch(ceoWeeklyReviewServiceProvider).generate(
        tasks: await ref.watch(taskRepositoryProvider).getAll(),
        habits: await ref.watch(habitRepositoryProvider).getAll(),
        goals: await ref.watch(goalRepositoryProvider).getAll(),
        finance: await ref.watch(financeRepositoryProvider).getAll(),
        workouts: await ref.watch(workoutRepositoryProvider).getAll(),
        studySessions: await ref.watch(studyRepositoryProvider).getAllSessions(),
        plans: await ref.watch(planRepositoryProvider).getAll(),
      );
});

final brainSearchQueryProvider = StateProvider<String>((ref) => '');

final brainSearchResultsProvider =
    Provider<AsyncValue<List<BrainSearchResult>>>((ref) {
  final query = ref.watch(brainSearchQueryProvider);
  final notesAsync = ref.watch(notesProvider);
  final docsAsync = ref.watch(documentsProvider);
  final tasksAsync = ref.watch(tasksProvider);

  return notesAsync.when(
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
    data: (notes) => docsAsync.when(
      loading: () => const AsyncValue.loading(),
      error: AsyncValue.error,
      data: (docs) => tasksAsync.when(
        loading: () => const AsyncValue.loading(),
        error: AsyncValue.error,
        data: (tasks) {
          final service = ref.watch(secondBrainSearchServiceProvider);
          final results = service.search(
            query: query,
            notes: notes,
            documents: docs,
            tasks: tasks,
          );
          return AsyncValue.data(results);
        },
      ),
    ),
  );
});
