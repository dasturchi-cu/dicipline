import '../../features/ai_coach/domain/ai_coach_service.dart';
import 'models/coach_context.dart';
import 'models/life_insight.dart';

/// Barcha insight oqimlarini birlashtiradi — Life OS markazi.
class LifeBrainFacade {
  const LifeBrainFacade();

  /// Barcha manbalardan prioritetlangan insightlar.
  List<LifeInsight> generateInsights({
    required CoachContext context,
    required List<AiTip> coachTips,
  }) {
    final insights = <LifeInsight>[];

    final burnout = context.burnout;
    if (burnout != null) {
      insights.add(
        LifeInsight(
          id: 'burnout_${burnout.level}',
          headline: 'Dam olish vaqti',
          body: burnout.message,
          priority: 100,
          source: InsightSource.pattern,
          confidence: InsightConfidence.high,
          pillar: 'health',
          loopStage: 'reflect',
          actionRoute: '/hayot/kundalik',
          actionLabel: 'Kundalik yozish',
        ),
      );
    }

    if (context.moodTrend.burnoutRisk && burnout == null) {
      insights.add(
        LifeInsight(
          id: 'mood_burnout_risk',
          headline: 'Kayfiyat past',
          body: context.moodTrend.insight,
          priority: 90,
          source: InsightSource.pattern,
          evidence: [
            '7 kunlik o\'rtacha: ${context.moodTrend.average7d.toStringAsFixed(1)}/5',
          ],
          confidence: InsightConfidence.medium,
          pillar: 'health',
          loopStage: 'reflect',
          actionRoute: '/hayot/kundalik',
        ),
      );
    }

    for (final drift in context.goalsAtRisk.take(1)) {
      insights.add(
        LifeInsight(
          id: 'goal_drift_${drift.goalTitle.hashCode}',
          headline: 'Maqsad harakatsiz',
          body:
              '"${drift.goalTitle}" ${drift.progress.round()}% — ${drift.daysInactive} kundan beri sekin. Kichik qadam qo\'ying.',
          priority: 75,
          source: InsightSource.rule,
          evidence: [
            'Progress: ${drift.progress.round()}%',
          ],
          confidence: InsightConfidence.high,
          pillar: 'goals',
          loopStage: 'plan',
          actionRoute: '/hayot/maqsadlar',
          actionLabel: 'Maqsadlarni ko\'rish',
        ),
      );
    }

    for (final memory in context.topMemories.take(2)) {
      insights.add(
        LifeInsight(
          id: 'memory_${memory.hashCode}',
          headline: 'AI eslaydi',
          body: memory,
          priority: 72,
          source: InsightSource.pattern,
          confidence: InsightConfidence.high,
          pillar: 'memory',
          loopStage: 'reflect',
          actionRoute: '/boshqa/xotira',
          actionLabel: 'Xotira',
        ),
      );
    }

    final today = context.today;
    if (today.tasksOverdue > 0) {
      insights.add(
        LifeInsight(
          id: 'tasks_overdue',
          headline: 'Muddati o\'tgan vazifalar',
          body: '${today.tasksOverdue} ta vazifa muddati o\'tgan. Bugun bittasini yoping.',
          priority: 65,
          source: InsightSource.rule,
          confidence: InsightConfidence.high,
          pillar: 'discipline',
          loopStage: 'act',
          actionRoute: '/vazifalar',
          actionLabel: 'Vazifalar',
        ),
      );
    }

    if (today.inboxPending >= 3) {
      insights.add(
        LifeInsight(
          id: 'inbox_backlog',
          headline: 'Inbox to\'lib qolgan',
          body: '${today.inboxPending} ta element kutmoqda. Tez qayta ishlang.',
          priority: 55,
          source: InsightSource.rule,
          confidence: InsightConfidence.high,
          pillar: 'capture',
          loopStage: 'act',
          actionRoute: '/boshqa/inbox',
          actionLabel: 'Inbox',
        ),
      );
    }

    for (final tip in coachTips) {
      insights.add(
        LifeInsight(
          id: 'coach_${tip.title.hashCode}',
          headline: tip.title,
          body: tip.description,
          priority: 70,
          source: InsightSource.rule,
          confidence: InsightConfidence.high,
          actionRoute: tip.actionRoute,
          loopStage: 'act',
        ),
      );
    }

    final patternInsight = context.patternInsight;
    if (patternInsight != null && patternInsight.isNotEmpty) {
      insights.add(
        LifeInsight(
          id: 'pattern_primary',
          headline: 'Naqsh aniqlandi',
          body: patternInsight,
          priority: 60,
          source: InsightSource.pattern,
          confidence: InsightConfidence.medium,
          pillar: 'analytics',
          loopStage: 'reflect',
          actionRoute: '/boshqa/analitika',
          actionLabel: 'Tahlilni ko\'rish',
        ),
      );
    }

    final dayProfile = context.dayPerformance;
    if (dayProfile != null && dayProfile.bestDayRate > 0) {
      insights.add(
        LifeInsight(
          id: 'day_of_week',
          headline: 'Eng samarali kun',
          body:
              '${dayProfile.bestDay} — vazifalarning ${(dayProfile.bestDayRate * 100).round()}%',
          priority: 40,
          source: InsightSource.pattern,
          confidence: InsightConfidence.medium,
          pillar: 'analytics',
          loopStage: 'plan',
        ),
      );
    }

    if (insights.isEmpty) {
      insights.add(
        LifeInsight(
          id: 'default_encourage',
          headline: 'Yaxshi boshlanish',
          body: 'Bugun bitta vazifa yoki odat bilan kichik qadam qo\'ying.',
          priority: 10,
          source: InsightSource.rule,
          confidence: InsightConfidence.high,
          actionRoute: '/vazifalar',
          loopStage: 'act',
        ),
      );
    }

    insights.sort((a, b) => b.priority.compareTo(a.priority));
    return insights;
  }

  /// Dashboard uchun eng muhim bitta insight.
  LifeInsight? topInsight({
    required CoachContext context,
    required List<AiTip> coachTips,
  }) {
    final all = generateInsights(context: context, coachTips: coachTips);
    return all.isEmpty ? null : all.first;
  }
}
