import 'package:rejabon_ai/core/intelligence/models/coach_context.dart';
import 'package:rejabon_ai/features/ai_planning/domain/models/plan_models.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_prediction_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/models/twin_models.dart';

/// Kunlik retention paketi — ertaga qaytish sababi.
class DailyRetentionBundle {
  const DailyRetentionBundle({
    required this.dailyInsight,
    required this.dailyPrediction,
    required this.coachingLine,
    required this.progressLine,
    required this.rewardHint,
    required this.streakHint,
    required this.returnReason,
  });

  final String dailyInsight;
  final String dailyPrediction;
  final String coachingLine;
  final String progressLine;
  final String rewardHint;
  final String streakHint;
  final String returnReason;
}

/// Har kuni foydalanuvchini qaytarish uchun kontent yig'uvchi.
class DailyRetentionEngine {
  DailyRetentionBundle buildDailyBundle({
    required LifeTwinAnalysis twinAnalysis,
    required FuturePredictions predictions,
    required LifeScoreBreakdown breakdown,
    required int playerLevel,
    required int dailyXpEarned,
    required CoachContext coachContext,
  }) {
    final insight = twinAnalysis.insights.isNotEmpty
        ? twinAnalysis.insights.first.body
        : 'Bugun bitta kichik qadam kifoya.';

    final prediction = predictions.goalPredictions.isNotEmpty
        ? predictions.goalPredictions.first.insight
        : predictions.trends.isNotEmpty
            ? predictions.trends.first.insight
            : 'Barqaror sur\'atda davom eting.';

    final coaching = twinAnalysis.recommendations.isNotEmpty
        ? twinAnalysis.recommendations.first.description
        : coachContext.headlineInsight ?? 'Murabbiy tayyor.';

    final progress =
        'Hayot balli ${breakdown.overall}/100 · Daraja $playerLevel · Bugun +$dailyXpEarned XP';

    final rewardHint = dailyXpEarned >= 50
        ? 'Bugun ajoyib XP — streakni saqlang!'
        : 'Yana ${50 - dailyXpEarned} XP — kunlik mukofotga yaqin.';

    final streakHint = coachContext.today.habitsCompletedToday > 0
        ? '${coachContext.today.habitsCompletedToday} odat bajarildi — streak mustahkamlanmoqda.'
        : 'Bugun bitta odat — streak boshlang.';

    final returnReason = _returnReason(twinAnalysis, breakdown);

    return DailyRetentionBundle(
      dailyInsight: insight,
      dailyPrediction: prediction,
      coachingLine: coaching,
      progressLine: progress,
      rewardHint: rewardHint,
      streakHint: streakHint,
      returnReason: returnReason,
    );
  }

  String _returnReason(LifeTwinAnalysis twin, LifeScoreBreakdown breakdown) {
    if (twin.recommendations.isNotEmpty) {
      return 'Ertaga: ${twin.recommendations.first.title}';
    }
    if (breakdown.overall < 60) {
      return 'Ertaga: samaradorlikni oshirish imkoniyati bor.';
    }
    return 'Ertaga: yangi AI insight va bashorat tayyor.';
  }
}
