/// Life Brain tomonidan chiqariladigan bitta tushuncha.
class LifeInsight {
  const LifeInsight({
    required this.id,
    required this.headline,
    required this.body,
    required this.priority,
    required this.source,
    this.evidence = const [],
    this.confidence = InsightConfidence.medium,
    this.pillar,
    this.loopStage,
    this.actionRoute,
    this.actionLabel,
  });

  final String id;
  final String headline;
  final String body;
  final int priority;
  final InsightSource source;
  final List<String> evidence;
  final InsightConfidence confidence;
  final String? pillar;
  final String? loopStage;
  final String? actionRoute;
  final String? actionLabel;

  String get displayText => body.isNotEmpty ? '$headline. $body' : headline;
}

enum InsightSource { rule, pattern, llm, merged }

enum InsightConfidence { high, medium, low }

String confidenceLabelUz(InsightConfidence c) => switch (c) {
      InsightConfidence.high => 'Yuqori',
      InsightConfidence.medium => 'O\'rta',
      InsightConfidence.low => 'Past',
    };
