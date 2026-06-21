import 'package:flutter/material.dart';

import '../database/schemas/goal_entity.dart';
import '../database/schemas/habit_entity.dart';
import '../database/schemas/note_entity.dart';
import '../database/schemas/plan_entity.dart';
import '../database/schemas/task_entity.dart';
import '../database/schemas/time_log_entity.dart';
import '../theme/app_colors.dart';

/// Hayot sohalari — REJABON hayot operatsion tizimi markazi.
class LifeArea {
  const LifeArea({
    required this.id,
    required this.emoji,
    required this.label,
    required this.color,
  });

  final String id;
  final String emoji;
  final String label;
  final Color color;

  static const health = LifeArea(
    id: 'health',
    emoji: '💪',
    label: 'Sog\'liq',
    color: AppColors.fire,
  );

  static const learning = LifeArea(
    id: 'learning',
    emoji: '📚',
    label: 'Ta\'lim',
    color: AppColors.accent,
  );

  static const finance = LifeArea(
    id: 'finance',
    emoji: '💰',
    label: 'Moliya',
    color: AppColors.gold,
  );

  static const family = LifeArea(
    id: 'family',
    emoji: '👨‍👩‍👧',
    label: 'Oila',
    color: AppColors.secondary,
  );

  static const personalGrowth = LifeArea(
    id: 'personal_growth',
    emoji: '🙏',
    label: 'Shaxsiy Rivojlanish',
    color: AppColors.primary,
  );

  static const career = LifeArea(
    id: 'career',
    emoji: '🚀',
    label: 'Karyera',
    color: AppColors.premiumGlow,
  );

  static const all = [
    health,
    learning,
    finance,
    family,
    personalGrowth,
    career,
  ];

  static LifeArea? byId(String id) {
    for (final area in all) {
      if (area.id == id) return area;
    }
    return null;
  }

  static List<String> resolveForTask(TaskEntity task) {
    if (task.lifeAreaIds.isNotEmpty) return task.lifeAreaIds;
    return _inferFromTaskCategory(task.category);
  }

  static List<String> resolveForHabit(HabitEntity habit) {
    if (habit.lifeAreaIds.isNotEmpty) return habit.lifeAreaIds;
    return [personalGrowth.id];
  }

  static List<String> resolveForGoal(GoalEntity goal) {
    if (goal.lifeAreaIds.isNotEmpty) return goal.lifeAreaIds;
    return [personalGrowth.id];
  }

  static List<String> resolveForNote(NoteEntity note) {
    if (note.lifeAreaIds.isNotEmpty) return note.lifeAreaIds;
    if (note.itemType == 'learning') return [learning.id];
    return [personalGrowth.id];
  }

  static List<String> resolveForPlan(PlanEntity plan) {
    if (plan.lifeAreaIds.isNotEmpty) return plan.lifeAreaIds;
    return [personalGrowth.id];
  }

  static List<String> resolveForTimeLog(TimeLogEntity log) {
    return switch (log.sessionType) {
      'workout' => [health.id],
      'study' || 'programming' || 'reading' => [learning.id],
      'focus' => [career.id],
      _ => [personalGrowth.id],
    };
  }

  static List<String> _inferFromTaskCategory(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('sog\'liq') || lower.contains('health')) {
      return [health.id];
    }
    if (lower.contains('ta\'lim') || lower.contains('o\'qish')) {
      return [learning.id];
    }
    if (lower.contains('ish') || lower.contains('karyera')) {
      return [career.id];
    }
    if (lower.contains('moliya') || lower.contains('finance')) {
      return [finance.id];
    }
    if (lower.contains('oila') || lower.contains('shaxsiy')) {
      return [family.id];
    }
    return [personalGrowth.id];
  }
}

/// Soha salomatligi: neglected | balanced | thriving
enum AreaHealth { neglected, balanced, thriving }

String areaHealthLabel(AreaHealth health) => switch (health) {
      AreaHealth.neglected => 'E\'tiborsiz',
      AreaHealth.balanced => 'Barqaror',
      AreaHealth.thriving => 'Rivojlanmoqda',
    };
