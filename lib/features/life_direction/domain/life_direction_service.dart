import '../../../core/constants/life_areas.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/monthly_focus_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../life_areas/domain/life_area_score_service.dart';

/// Hayot yo'nalishi — uzoq muddatli maqsadlarga moslik.
class LifeDirectionInsight {
  const LifeDirectionInsight({
    required this.message,
    this.areaId,
    this.alignmentScore,
  });

  final String message;
  final String? areaId;
  final int? alignmentScore;
}

class LifeDirectionReport {
  const LifeDirectionReport({
    required this.insights,
    required this.hasSufficientData,
    required this.alignmentScore,
  });

  final List<LifeDirectionInsight> insights;
  final bool hasSufficientData;
  final int alignmentScore;
}

DateTime _norm(DateTime d) => DateTime(d.year, d.month, d.day);

class LifeDirectionService {
  LifeDirectionService();

  static const _minWeeklyActions = 5;

  LifeDirectionReport evaluate({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required LifeBalanceReport balance,
    MonthlyFocusEntity? monthlyFocus,
    DateTime? asOf,
  }) {
    final today = _norm(asOf ?? DateTime.now());
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    final weekTasks = tasks.where((t) {
      final d = _norm(t.updatedAt);
      return !d.isBefore(weekStart) && !d.isAfter(today);
    }).toList();

    final weekCompleted = weekTasks.where((t) => t.isCompleted).length;
    final weekHabitDays = habits.fold<int>(0, (sum, h) {
      return sum +
          h.completedDates
              .where((d) => !d.isBefore(weekStart) && !d.isAfter(today))
              .length;
    });

    final actionCount = weekCompleted + weekHabitDays;
    if (actionCount < _minWeeklyActions && goals.isEmpty) {
      return const LifeDirectionReport(
        insights: [
          LifeDirectionInsight(
            message:
                'Ko\'proq ma\'lumot to\'plangandan so\'ng tavsiyalar paydo bo\'ladi.',
          ),
        ],
        hasSufficientData: false,
        alignmentScore: 0,
      );
    }

    final insights = <LifeDirectionInsight>[];
    var alignment = 50;

    if (monthlyFocus != null) {
      GoalEntity? focusGoal;
      for (final g in goals) {
        if (g.id == monthlyFocus.goalId) {
          focusGoal = g;
          break;
        }
      }
      if (focusGoal != null) {
        final focusAreas = LifeArea.resolveForGoal(focusGoal);
        final focusTaskDone = weekTasks
            .where((t) =>
                t.isCompleted &&
                LifeArea.resolveForTask(t).any(focusAreas.contains))
            .length;
        if (focusTaskDone > 0) {
          alignment += 20;
          insights.add(
            LifeDirectionInsight(
              message:
                  'Bugungi harakatlaringiz asosiy maqsadingizga qisman mos kelmoqda.',
              areaId: focusAreas.firstOrNull,
              alignmentScore: alignment,
            ),
          );
        } else if (weekTasks.isNotEmpty) {
          insights.add(
            const LifeDirectionInsight(
              message:
                  'Bu hafta asosiy maqsad yo\'nalishida kamroq harakat qilindi.',
            ),
          );
          alignment -= 10;
        }
      }
    }

    for (final areaScore in balance.areaScores) {
      if (areaScore.area.id == LifeArea.learning.id &&
          areaScore.tasksTotal + areaScore.timeInvestedMinutes < 30) {
        insights.add(
          LifeDirectionInsight(
            message:
                'Bu hafta ta\'lim maqsadlariga yetarli vaqt ajratilmadi.',
            areaId: LifeArea.learning.id,
          ),
        );
      }
      if (areaScore.area.id == LifeArea.health.id &&
          areaScore.health == AreaHealth.thriving) {
        insights.add(
          LifeDirectionInsight(
            message: 'Sport va sog\'liq yo\'nalishida progress yaxshi.',
            areaId: LifeArea.health.id,
          ),
        );
        alignment += 15;
      }
      if (areaScore.health == AreaHealth.neglected &&
          areaScore.tasksTotal == 0 &&
          areaScore.habitsTotal == 0) {
        insights.add(
          LifeDirectionInsight(
            message:
                '${areaScore.area.emoji} ${areaScore.area.label} sohasi e\'tiborsiz qolmoqda.',
            areaId: areaScore.area.id,
          ),
        );
        alignment -= 5;
      }
    }

    final topGoals = goals.where((g) => g.progress < 100).toList()
      ..sort((a, b) => b.progress.compareTo(a.progress));
    if (topGoals.isNotEmpty && topGoals.first.progress >= 50) {
      alignment += 10;
      insights.add(
        LifeDirectionInsight(
          message:
              '"${topGoals.first.title}" maqsadiga yaxshi yaqinlashyapsiz (${topGoals.first.progress.round()}%).',
        ),
      );
    }

    if (insights.isEmpty) {
      insights.add(
        const LifeDirectionInsight(
          message: 'Harakatlaringiz barqaror. Asosiy maqsadga e\'tibor bering.',
        ),
      );
    }

    return LifeDirectionReport(
      insights: insights.take(4).toList(),
      hasSufficientData: true,
      alignmentScore: alignment.clamp(0, 100),
    );
  }
}
