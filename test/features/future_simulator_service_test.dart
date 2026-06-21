import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_simulator_service.dart';
import 'package:rejabon_ai/features/ai_planning/domain/models/plan_models.dart';

void main() {
  group('FutureSimulatorService extended scenarios', () {
    final service = FutureSimulatorService();

    const breakdown = LifeScoreBreakdown(
      overall: 60,
      discipline: 55,
      health: 50,
      learning: 45,
      finance: 50,
      sleep: 40,
      goals: 35,
    );

    test('includes 90-day habit scenario', () {
      final results = service.simulateAll(
        tasks: const [],
        habits: const [],
        goals: const [],
        breakdown: breakdown,
      );

      expect(results.any((r) => r.scenario.id == 'habit_90'), isTrue);
      expect(results.any((r) => r.scenario.id == 'stop_study'), isTrue);
      expect(results.any((r) => r.scenario.id == 'sleep_plus_1h'), isTrue);
    });

    test('habit_90 scenario produces insight text', () {
      final scenario = FutureSimulatorService.scenarios
          .firstWhere((s) => s.id == 'habit_90');
      final result = service.simulate(
        scenario: scenario,
        tasks: const [],
        habits: const [],
        goals: const [],
        currentBreakdown: breakdown,
      );

      expect(result.insight.toLowerCase(), contains('90'));
    });
  });
}
