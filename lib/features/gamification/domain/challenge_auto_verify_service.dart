import '../../../core/database/schemas/challenge_entity.dart';
import '../../../core/database/schemas/finance_transaction_entity.dart';
import '../../../core/database/schemas/plan_entity.dart';
import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';
import '../../../core/repositories/challenge_repository.dart';
import '../../../core/repositories/finance_repository.dart';
import '../../../core/repositories/plan_repository.dart';
import '../../../core/repositories/study_repository.dart';
import '../../../core/repositories/workout_repository.dart';

DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Musobaqalarni haqiqiy ma'lumotlar bilan avtomatik tekshiradi.
class ChallengeAutoVerifyService {
  ChallengeAutoVerifyService({
    required ChallengeRepository challengeRepo,
    required WorkoutRepository workoutRepo,
    required StudyRepository studyRepo,
    required FinanceRepository financeRepo,
    required PlanRepository planRepo,
  })  : _challenges = challengeRepo,
        _workouts = workoutRepo,
        _study = studyRepo,
        _finance = financeRepo,
        _plans = planRepo;

  final ChallengeRepository _challenges;
  final WorkoutRepository _workouts;
  final StudyRepository _study;
  final FinanceRepository _finance;
  final PlanRepository _plans;

  Future<List<ChallengeEntity>> verifyAll() async {
    final active = await _challenges.getActive();
    if (active.isEmpty) return [];

    final workouts = await _workouts.getAll();
    final sessions = await _study.getAllSessions();
    final finance = await _finance.getAll();
    final plans = await _plans.getAll();

    final updated = <ChallengeEntity>[];
    for (final challenge in active) {
      final verified = await _verifyChallenge(
        challenge,
        workouts: workouts,
        sessions: sessions,
        finance: finance,
        plans: plans,
      );
      if (verified != null) updated.add(verified);
    }
    return updated;
  }

  Future<ChallengeEntity?> _verifyChallenge(
    ChallengeEntity challenge, {
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> sessions,
    required List<FinanceTransactionEntity> finance,
    required List<PlanEntity> plans,
  }) async {
    final today = _normalize(DateTime.now());
    final alreadyDone = challenge.completedDates.any((d) => _sameDay(d, today));
    if (alreadyDone) return null;

    final verified = switch (challenge.typeId) {
      'workout_14' => _hasWorkoutToday(workouts, today),
      'english_30' => _hasStudyToday(sessions, today, minMinutes: 20),
      'spending_30' => _hasFinanceLogToday(finance, today),
      'early_wake_7' => _hasEarlyWakeToday(plans, today),
      _ => false,
    };

    if (!verified) return null;

    challenge.completedDates.add(today);
    challenge.currentDay = challenge.completedDates.length;

    if (challenge.currentDay >= challenge.targetDays) {
      challenge.completedAt = DateTime.now();
      challenge.isActive = false;
    }

    return _challenges.update(challenge);
  }

  bool _hasWorkoutToday(List<WorkoutEntity> workouts, DateTime today) {
    return workouts.any((w) => _sameDay(_normalize(w.date), today));
  }

  bool _hasStudyToday(
    List<StudySessionEntity> sessions,
    DateTime today, {
    required int minMinutes,
  }) {
    final minutes = sessions
        .where((s) => _sameDay(_normalize(s.date), today))
        .fold(0, (sum, s) => sum + s.durationMinutes);
    return minutes >= minMinutes;
  }

  bool _hasFinanceLogToday(
    List<FinanceTransactionEntity> finance,
    DateTime today,
  ) {
    return finance.any((tx) => _sameDay(_normalize(tx.date), today));
  }

  bool _hasEarlyWakeToday(List<PlanEntity> plans, DateTime today) {
    for (final plan in plans) {
      if (!_sameDay(_normalize(plan.planDate), today)) continue;
      final earlyItems = plan.items.where(
        (item) =>
            item.isCompleted &&
            (item.startTime.hour < 10 ||
                item.title.toLowerCase().contains('tur') ||
                item.title.toLowerCase().contains('erta')),
      );
      if (earlyItems.isNotEmpty) return true;
    }
    return false;
  }
}
