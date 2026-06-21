import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/capture/presentation/providers/capture_providers.dart';
import '../../features/gamification/presentation/providers/gamification_providers.dart';
import '../../features/journal/domain/mood_trend_service.dart';
import '../../features/platform/presentation/providers/platform_providers.dart';
import '../providers/repository_providers.dart';
import 'life_context_assembler.dart';
import 'models/coach_context.dart';

final moodTrendServiceProvider = Provider<MoodTrendService>((ref) {
  return const MoodTrendService();
});

final lifeContextAssemblerProvider = Provider<LifeContextAssembler>((ref) {
  return LifeContextAssembler(
    moodTrendService: ref.watch(moodTrendServiceProvider),
  );
});

final moodTrendProvider = Provider<MoodTrendReport>((ref) {
  final journal = ref.watch(journalProvider).valueOrNull ?? [];
  return ref.watch(moodTrendServiceProvider).compute(journal);
});

/// Unified coach context — no dependency on AI coach providers (avoids cycles).
final coachContextProvider = Provider<CoachContext>((ref) {
  final journal = ref.watch(journalProvider).valueOrNull ?? [];
  final tasks = ref.watch(tasksProvider).valueOrNull ?? [];
  final habits = ref.watch(habitsProvider).valueOrNull ?? [];
  final goals = ref.watch(goalsProvider).valueOrNull ?? [];
  final inbox = ref.watch(inboxProvider).valueOrNull ?? [];
  final profile = ref.watch(playerProfileProvider).valueOrNull;
  final memories = ref.watch(aiMemoriesProvider).valueOrNull ?? [];
  final topMemories = memories.take(3).map((m) => m.insight).toList();

  return ref.watch(lifeContextAssemblerProvider).assemble(
        journal: journal,
        tasks: tasks,
        habits: habits,
        goals: goals,
        inbox: inbox,
        rpgLevel: profile?.level ?? 1,
        rpgTotalXp: profile?.totalXp ?? 0,
        topMemories: topMemories,
      );
});

String formatCoachContextBlock(CoachContext context) {
  final today = context.today;
  final mood = context.moodTrend;
  final lines = <String>[
    'Bugun: ${today.tasksDueToday} vazifa, ${today.tasksOverdue} kechikkan',
    'Odatlar: ${today.habitsCompletedToday}/${today.habitsTotal}',
    'Inbox: ${today.inboxPending}',
    'Kayfiyat 7 kun: ${mood.average7d.toStringAsFixed(1)}/5',
    if (mood.insight.isNotEmpty) mood.insight,
    if (context.patternInsight != null) 'Naqsh: ${context.patternInsight}',
    if (context.topMemories.isNotEmpty)
      'Xotira: ${context.topMemories.join("; ")}',
    if (context.goalsAtRisk.isNotEmpty)
      'Maqsad xavfi: ${context.goalsAtRisk.first.goalTitle}',
  ];
  return lines.join('\n');
}
