import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/gamification/domain/achievement_service.dart';
import '../../features/gamification/presentation/providers/gamification_providers.dart';
import 'app_feedback.dart';

/// Yangi ochilgan yutuqlarni nishonlaydi (doimiy saqlangan).
Future<void> celebrateNewAchievements(
  WidgetRef ref,
  BuildContext context,
) async {
  if (!context.mounted) return;
  ref.invalidate(achievementsProvider);
  final achievements = await ref.read(achievementsProvider.future);
  if (!context.mounted) return;

  final unlockRepo = ref.read(achievementUnlockRepositoryProvider);
  final uncelebrated = await unlockRepo.getUncelebrated();

  for (final unlock in uncelebrated) {
    Achievement? achievement;
    for (final a in achievements) {
      if (a.id == unlock.achievementId) {
        achievement = a;
        break;
      }
    }
    if (achievement == null || !achievement.unlocked) continue;
    if (!context.mounted) return;
    showAchievementSnackBar(
      context,
      emoji: achievement.emoji,
      title: achievement.title,
    );
    await unlockRepo.markCelebrated(unlock.achievementId);
  }
}

void resetAchievementCelebrations() {}
