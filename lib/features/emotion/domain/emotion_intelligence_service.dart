import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../journal/domain/mood_trend_service.dart';
import '../../life_twin/domain/coach_pattern_engine.dart';

/// Emotsional o'lchovlar (0–100).
class EmotionScores {
  const EmotionScores({
    required this.happiness,
    required this.stress,
    required this.motivation,
    required this.energy,
    required this.anxiety,
  });

  final double happiness;
  final double stress;
  final double motivation;
  final double energy;
  final double anxiety;
}

/// Emotsional insight.
class EmotionInsight {
  const EmotionInsight({
    required this.id,
    required this.title,
    required this.body,
    required this.severity,
    required this.actionRoute,
    required this.actionLabel,
  });

  final String id;
  final String title;
  final String body;
  final String severity; // low | medium | high
  final String actionRoute;
  final String actionLabel;
}

/// Emotsional profil + intervensiyalar.
class EmotionProfile {
  const EmotionProfile({
    required this.scores,
    required this.insights,
    required this.burnoutRisk,
    required this.depressionRisk,
    required this.motivationDrop,
  });

  final EmotionScores scores;
  final List<EmotionInsight> insights;
  final bool burnoutRisk;
  final bool depressionRisk;
  final bool motivationDrop;
}

/// Kayfiyat va faollik asosida emotsional tahlil.
class EmotionIntelligenceService {
  EmotionIntelligenceService({
    MoodTrendService? moodTrend,
    CoachPatternEngine? patterns,
  })  : _mood = moodTrend ?? const MoodTrendService(),
        _patterns = patterns ?? const CoachPatternEngine();

  final MoodTrendService _mood;
  final CoachPatternEngine _patterns;

  EmotionProfile analyze({
    required List<JournalEntryEntity> journal,
    required List<TaskEntity> tasks,
  }) {
    final moodReport = _mood.compute(journal);
    final burnout = journal.isNotEmpty && tasks.isNotEmpty
        ? _patterns.detectBurnout(journal: journal, tasks: tasks)
        : null;

    final avg = moodReport.hasSufficientData ? moodReport.average7d : 3.0;
    final happiness = (avg / 5 * 100).clamp(0, 100);
    final stress = moodReport.burnoutRisk
        ? 85.0
        : ((3.0 - avg).clamp(0, 3) / 3 * 100);
    final completed7 = _tasksLast7(tasks);
    final motivation = ((completed7 / 7).clamp(0, 1) * 60 +
            (moodReport.trend == 'up' ? 30 : moodReport.trend == 'down' ? 0 : 15))
        .clamp(0, 100);
    final energy = moodReport.hasSufficientData
        ? ((avg - 1) / 4 * 100).clamp(0, 100)
        : 50.0;
    final anxiety = stress > 60 && happiness < 40 ? 75.0 : stress * 0.5;

    final scores = EmotionScores(
      happiness: happiness.toDouble(),
      stress: stress.toDouble(),
      motivation: motivation.toDouble(),
      energy: energy.toDouble(),
      anxiety: anxiety.toDouble(),
    );

    final insights = <EmotionInsight>[];
    final burnoutRisk = moodReport.burnoutRisk || burnout != null;
    final depressionRisk =
        moodReport.hasSufficientData && moodReport.average7d <= 2.0;
    final motivationDrop =
        moodReport.trend == 'down' && completed7 < 3;

    if (burnoutRisk) {
      insights.add(
        const EmotionInsight(
          id: 'burnout',
          title: 'Burnout xavfi',
          body: 'Kayfiyat va faollik past — dam olish va yengil kun kerak.',
          severity: 'high',
          actionRoute: '/favqulodda',
          actionLabel: 'Yordam olish',
        ),
      );
    }
    if (depressionRisk) {
      insights.add(
        const EmotionInsight(
          id: 'low_mood',
          title: 'Past kayfiyat',
          body: 'Bir necha kun past kayfiyat — kundalik va yengil harakatlar yordam beradi.',
          severity: 'high',
          actionRoute: '/hayot/kundalik',
          actionLabel: 'Kundalik yozish',
        ),
      );
    }
    if (motivationDrop) {
      insights.add(
        const EmotionInsight(
          id: 'motivation_drop',
          title: 'Motivatsiya tushishi',
          body: 'Vazifa bajarish kamaymoqda — bitta kichik g\'alaba qidiring.',
          severity: 'medium',
          actionRoute: '/vazifalar',
          actionLabel: 'Vazifalar',
        ),
      );
    }
    if (moodReport.trend == 'up' && !burnoutRisk) {
      insights.add(
        const EmotionInsight(
          id: 'mood_up',
          title: 'Kayfiyat yaxshilanmoqda',
          body: 'Yaxshi trend — muhim vazifalarni bugun rejalashtiring.',
          severity: 'low',
          actionRoute: '/boshqa/analitika',
          actionLabel: 'Tahlil',
        ),
      );
    }

    return EmotionProfile(
      scores: scores,
      insights: insights,
      burnoutRisk: burnoutRisk,
      depressionRisk: depressionRisk,
      motivationDrop: motivationDrop,
    );
  }

  int _tasksLast7(List<TaskEntity> tasks) {
    final now = DateTime.now();
    var count = 0;
    for (var i = 0; i < 7; i++) {
      final day = DateTime(now.year, now.month, now.day - i);
      count += tasks
          .where((t) =>
              t.isCompleted &&
              t.updatedAt.year == day.year &&
              t.updatedAt.month == day.month &&
              t.updatedAt.day == day.day)
          .length;
    }
    return count;
  }
}
