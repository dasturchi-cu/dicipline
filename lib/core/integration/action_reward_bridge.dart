import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/features/gamification/domain/xp_service.dart';
import 'package:rejabon_ai/features/gamification/presentation/providers/gamification_providers.dart';
import 'ai_memory_sync.dart';
import 'goal_progress_sync.dart';
import 'package:rejabon_ai/shared/widgets/app_feedback.dart';
import 'package:rejabon_ai/shared/widgets/level_up_overlay.dart';
import 'package:rejabon_ai/shared/widgets/xp_reward_overlay.dart';

/// Harakatlardan keyin XP va questlarni yangilaydi.
Future<XpAwardResult?> rewardTaskComplete(
  WidgetRef ref,
  BuildContext context, {
  required int taskId,
}) async {
  final result = await ref.read(xpServiceProvider).awardTaskComplete(taskId);
  if (result != null) {
    final task = await ref.read(taskRepositoryProvider).getById(taskId);
    if (task != null) {
      await syncGoalProgressFromTask(ref, task);
    }
    if (context.mounted) {
      await _afterXpAward(ref, context, result);
    }
  }
  return result;
}

Future<XpAwardResult?> rewardHabitComplete(
  WidgetRef ref,
  BuildContext context, {
  required int habitId,
}) async {
  final result = await ref.read(xpServiceProvider).awardHabitComplete(habitId);
  if (result != null && context.mounted) {
    await _afterXpAward(ref, context, result);
  }
  return result;
}

Future<XpAwardResult?> rewardJournal(
  WidgetRef ref,
  BuildContext context,
) async {
  final result = await ref.read(xpServiceProvider).awardJournal();
  if (result != null && context.mounted) {
    await _afterXpAward(ref, context, result);
  }
  return result;
}

Future<XpAwardResult?> rewardWorkout(
  WidgetRef ref,
  BuildContext context,
) async {
  final result = await ref.read(xpServiceProvider).awardWorkout();
  if (result != null && context.mounted) {
    await _afterXpAward(ref, context, result);
  }
  return result;
}

Future<XpAwardResult?> rewardFinanceLog(
  WidgetRef ref,
  BuildContext context,
) async {
  final result = await ref.read(xpServiceProvider).awardFinanceLog();
  if (result != null && context.mounted) {
    await _afterXpAward(ref, context, result);
  }
  return result;
}

Future<XpAwardResult?> rewardStudy(
  WidgetRef ref,
  BuildContext context, {
  required int minutes,
}) async {
  final result = await ref.read(xpServiceProvider).awardStudy(minutes);
  if (result != null && context.mounted) {
    await _afterXpAward(ref, context, result);
  }
  return result;
}

Future<XpAwardResult?> rewardFocusSession(
  WidgetRef ref,
  BuildContext context,
) async {
  final result = await ref.read(xpServiceProvider).awardFocusSession();
  if (result != null && context.mounted) {
    await _afterXpAward(ref, context, result);
  }
  return result;
}

Future<void> _afterXpAward(
  WidgetRef ref,
  BuildContext context,
  XpAwardResult result,
) async {
  _showXpSnackBar(context, result);
  ref.invalidate(playerProfileProvider);
  ref.invalidate(xpEventsProvider);
  await ref.read(questServiceProvider).verifyAndCompleteQuests();
  ref.invalidate(dailyQuestsProvider);
  await syncAiMemoryThrottled(ref);
}

void _showXpSnackBar(BuildContext context, XpAwardResult result) {
  final statEmoji = StatType.emoji(result.statType);
  showXpRewardOverlay(
    context,
    amount: result.amount,
    statType: result.statType,
    leveledUp: result.leveledUp,
    newLevel: result.newLevel,
  );
  if (result.leveledUp && result.newLevel != null) {
    showLevelUpOverlay(context, level: result.newLevel!);
  }
  showSavedSnackBar(
    context,
    message: '+${result.amount} XP $statEmoji',
  );
}
