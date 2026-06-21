import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/repository_providers.dart';
import 'app_feedback.dart';

/// Unlocked achievements celebrated this session.
final _celebratedAchievementIds = <String>{};
var _initialized = false;

Future<void> celebrateNewAchievements(
  WidgetRef ref,
  BuildContext context,
) async {
  if (!context.mounted) return;
  ref.invalidate(achievementsProvider);
  final achievements = await ref.read(achievementsProvider.future);
  if (!context.mounted) return;

  if (!_initialized) {
    for (final achievement in achievements.where((a) => a.unlocked)) {
      _celebratedAchievementIds.add(achievement.id);
    }
    _initialized = true;
    return;
  }

  for (final achievement in achievements) {
    if (!achievement.unlocked) continue;
    if (_celebratedAchievementIds.contains(achievement.id)) continue;
    _celebratedAchievementIds.add(achievement.id);
    if (!context.mounted) return;
    showAchievementSnackBar(
      context,
      emoji: achievement.emoji,
      title: achievement.title,
    );
  }
}

void resetAchievementCelebrations() {
  _celebratedAchievementIds.clear();
  _initialized = false;
}
