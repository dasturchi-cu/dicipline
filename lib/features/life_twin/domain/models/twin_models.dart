/// Life Twin tushunchasi — shaxsiy, ma'lumotga asoslangan.
class TwinInsight {
  const TwinInsight({
    required this.id,
    required this.category,
    required this.headline,
    required this.body,
    required this.confidence,
    this.evidence = const [],
  });

  final String id;
  final String category;
  final String headline;
  final String body;
  final double confidence;
  final List<String> evidence;
}

/// Life Twin tavsiyasi — amal bilan.
class TwinRecommendation {
  const TwinRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.actionRoute,
    this.actionLabel,
    this.actionType,
  });

  final String id;
  final String title;
  final String description;
  final int priority;
  final String? actionRoute;
  final String? actionLabel;
  /// execute_plan | focus | journal | goal | habit
  final String? actionType;
}

/// To'liq Life Twin tahlili.
class LifeTwinAnalysis {
  const LifeTwinAnalysis({
    required this.insights,
    required this.recommendations,
    required this.peakHoursLabel,
    required this.learningStyle,
    required this.strengths,
    required this.weaknesses,
  });

  final List<TwinInsight> insights;
  final List<TwinRecommendation> recommendations;
  final String peakHoursLabel;
  final String learningStyle;
  final List<String> strengths;
  final List<String> weaknesses;
}
