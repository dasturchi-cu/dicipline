import '../../features/ai_coach/domain/ai_coach_service.dart';
import 'life_brain_facade.dart';
import 'models/coach_context.dart';
import 'models/life_insight.dart';

/// Birlashtirilgan tavsiya — Life Brain + AI Coach.
class UnifiedRecommendation {
  const UnifiedRecommendation({
    required this.id,
    required this.title,
    required this.body,
    required this.priority,
    this.actionRoute,
    this.actionLabel,
    this.source = 'brain',
  });

  final String id;
  final String title;
  final String body;
  final int priority;
  final String? actionRoute;
  final String? actionLabel;
  final String source;
}

/// Prioritet bo'yicha barcha tavsiyalarni birlashtiradi.
class RecommendationEngine {
  const RecommendationEngine({LifeBrainFacade? brain})
      : _brain = brain ?? const LifeBrainFacade();

  final LifeBrainFacade _brain;

  List<UnifiedRecommendation> merge({
    required CoachContext context,
    required List<AiTip> coachTips,
    required List<LifeInsight> brainInsights,
    int limit = 8,
  }) {
    final items = <UnifiedRecommendation>[];

    for (final insight in brainInsights) {
      items.add(
        UnifiedRecommendation(
          id: insight.id,
          title: insight.headline,
          body: insight.body,
          priority: insight.priority,
          actionRoute: insight.actionRoute,
          actionLabel: insight.actionLabel,
          source: 'brain',
        ),
      );
    }

    for (final tip in coachTips) {
      items.add(
        UnifiedRecommendation(
          id: 'coach_${tip.title.hashCode}',
          title: tip.title,
          body: tip.description,
          priority: 68,
          actionRoute: tip.actionRoute,
          source: 'coach',
        ),
      );
    }

    if (context.goalsAtRisk.isNotEmpty) {
      final drift = context.goalsAtRisk.first;
      items.add(
        UnifiedRecommendation(
          id: 'goal_link_${drift.goalTitle.hashCode}',
          title: 'Maqsadga bog\'lang',
          body:
              '"${drift.goalTitle}" uchun bugun bitta vazifa yarating.',
          priority: 74,
          actionRoute: '/vazifalar',
          actionLabel: 'Vazifa qo\'shish',
          source: 'loop',
        ),
      );
    }

    final seen = <String>{};
    final deduped = <UnifiedRecommendation>[];
    items.sort((a, b) => b.priority.compareTo(a.priority));
    for (final item in items) {
      final key = '${item.title}_${item.body.hashCode}';
      if (seen.add(key)) deduped.add(item);
    }
    return deduped.take(limit).toList();
  }

  List<LifeInsight> brainInsights({
    required CoachContext context,
    required List<AiTip> coachTips,
  }) {
    return _brain.generateInsights(context: context, coachTips: coachTips);
  }
}
