import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../ai_planning/domain/life_score_service.dart';
import '../../ai_planning/domain/models/plan_models.dart';

/// Simulyatsiya stsenariysi.
class SimulationScenario {
  const SimulationScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.taskMultiplier,
    required this.habitMultiplier,
  });

  final String id;
  final String title;
  final String description;
  final double taskMultiplier;
  final double habitMultiplier;
}

/// Simulyatsiya natijasi.
class SimulationResult {
  const SimulationResult({
    required this.scenario,
    required this.currentScore,
    required this.projectedScore,
    required this.delta,
    required this.weeksToGoal,
    required this.insight,
  });

  final SimulationScenario scenario;
  final int currentScore;
  final int projectedScore;
  final int delta;
  final int? weeksToGoal;
  final String insight;
}

/// Kelajak simulyatori — "what-if" hisob-kitob.
class FutureSimulatorService {
  FutureSimulatorService({LifeScoreService? lifeScoreService})
      : _lifeScore = lifeScoreService ?? LifeScoreService();

  final LifeScoreService _lifeScore;

  static const scenarios = [
    SimulationScenario(
      id: 'maintain',
      title: 'Hozirgi ritm',
      description: 'O\'zgarishsiz davom etsangiz',
      taskMultiplier: 1.0,
      habitMultiplier: 1.0,
    ),
    SimulationScenario(
      id: 'boost',
      title: '+30% intizom',
      description: 'Vazifa va odatlarni 30% ko\'paytirsangiz',
      taskMultiplier: 1.3,
      habitMultiplier: 1.3,
    ),
    SimulationScenario(
      id: 'slump',
      title: '-30% pasayish',
      description: 'Faollik 30% tushsa',
      taskMultiplier: 0.7,
      habitMultiplier: 0.7,
    ),
    SimulationScenario(
      id: 'habit_90',
      title: '90 kun odat',
      description: 'Odatni 90 kun davom ettirsangiz',
      taskMultiplier: 1.0,
      habitMultiplier: 1.5,
    ),
    SimulationScenario(
      id: 'stop_study',
      title: 'O\'qishni to\'xtatsangiz',
      description: 'Ta\'lim faolligi to\'xtasa',
      taskMultiplier: 0.5,
      habitMultiplier: 0.6,
    ),
    SimulationScenario(
      id: 'sleep_plus_1h',
      title: '+1 soat uyqu',
      description: 'Uyqu va tiklanish 1 soat yaxshilansa',
      taskMultiplier: 1.1,
      habitMultiplier: 1.15,
    ),
  ];

  SimulationResult simulate({
    required SimulationScenario scenario,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required LifeScoreBreakdown currentBreakdown,
    List<dynamic> finance = const [],
    List<dynamic> workouts = const [],
    List<dynamic> studySessions = const [],
  }) {
    final current = currentBreakdown.overall;

    // Discipline proxy: task + habit completion rates scaled
    final projectedDiscipline = _scaled(
      currentBreakdown.discipline,
      (scenario.taskMultiplier + scenario.habitMultiplier) / 2,
    );

    final projected = _clamp(
      ((projectedDiscipline +
                  currentBreakdown.health +
                  currentBreakdown.learning +
                  currentBreakdown.finance +
                  currentBreakdown.sleep +
                  currentBreakdown.goals) /
              6)
          .round(),
    );

    final delta = projected - current;

    int? weeksToGoal;
    if (goals.isNotEmpty && delta > 0) {
      final avgProgress =
          goals.map((g) => g.progress).reduce((a, b) => a + b) / goals.length;
      if (avgProgress < 100) {
        weeksToGoal = ((100 - avgProgress) / (delta / 4).clamp(0.5, 10)).ceil();
      }
    }

    final insight = switch (scenario.id) {
      'boost' =>
        delta > 5
            ? 'Intizomingizni oshirsangiz, 4 haftada hayot balli +$delta bo\'lishi mumkin.'
            : 'Yengil yaxshilanish kuzatiladi — barqarorlik muhim.',
      'slump' =>
        delta < -5
            ? 'Faollik tushsa hayot balli $delta ga kamayishi mumkin. Ehtiyot bo\'ling.'
            : 'Kichik pasayish — tezda qayta tiklanish mumkin.',
      'habit_90' =>
        delta > 0
            ? 'Bu odatni 90 kun davom ettirsangiz, hayot balli +$delta ga oshishi va streak mustahkamlanishi mumkin.'
            : '90 kunlik odat barqarorlik beradi — kichik, lekin doimiy o\'sish.',
      'stop_study' =>
        delta < 0
            ? 'O\'qishni hozir to\'xtatsangiz, 4 haftada hayot balli $delta ga tushishi mumkin.'
            : 'Ta\'lim faolligi pasayishi o\'rganish maqsadlarini sekinlashtiradi.',
      'sleep_plus_1h' =>
        delta > 0
            ? 'Uyqu 1 soat yaxshilansa, samaradorlik +$delta ballga oshishi mumkin.'
            : 'Yaxshi uyqu kayfiyat va intizomni sezilarli yaxshilaydi.',
      _ => 'Hozirgi ritmda barqaror rivojlanish davom etadi.',
    };

    return SimulationResult(
      scenario: scenario,
      currentScore: current,
      projectedScore: projected,
      delta: delta,
      weeksToGoal: weeksToGoal,
      insight: insight,
    );
  }

  List<SimulationResult> simulateAll({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required LifeScoreBreakdown breakdown,
  }) {
    return scenarios
        .map((s) => simulate(
              scenario: s,
              tasks: tasks,
              habits: habits,
              goals: goals,
              currentBreakdown: breakdown,
            ))
        .toList();
  }

  int _scaled(int base, double multiplier) =>
      _clamp((base * multiplier).round());

  int _clamp(int v) => v.clamp(0, 100);
}
