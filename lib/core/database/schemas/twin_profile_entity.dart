import 'dart:convert';

import 'package:isar/isar.dart';

part 'twin_profile_entity.g.dart';

/// Saqlangan Life Twin shaxsiyat profili (bitta yozuv).
@collection
class TwinProfileEntity {
  Id id = Isar.autoIncrement;

  /// morning_person | night_owl | balanced
  late String chronotype;

  /// steady | burst | inconsistent
  late String productivityStyle;

  /// optimistic | realistic | cautious
  late String goalOrientation;

  /// high | medium | low
  late String habitConsistency;

  /// stable | volatile | improving | declining
  late String moodTrend;

  /// JSON: learnedHabits, learnedGoals, topCategories
  late String traitsJson;

  late int lifeScoreSnapshot;

  @Index()
  late DateTime updatedAt;

  TwinProfileEntity();

  TwinProfileEntity.create({
    required this.chronotype,
    required this.productivityStyle,
    required this.goalOrientation,
    required this.habitConsistency,
    required this.moodTrend,
    required Map<String, dynamic> traits,
    required this.lifeScoreSnapshot,
    DateTime? updatedAt,
  })  : traitsJson = jsonEncode(traits),
        updatedAt = updatedAt ?? DateTime.now();

  @ignore
  Map<String, dynamic> get traits =>
      jsonDecode(traitsJson) as Map<String, dynamic>;

  Map<String, dynamic> toJson() => {
        'id': id,
        'chronotype': chronotype,
        'productivityStyle': productivityStyle,
        'goalOrientation': goalOrientation,
        'habitConsistency': habitConsistency,
        'moodTrend': moodTrend,
        'traitsJson': traitsJson,
        'lifeScoreSnapshot': lifeScoreSnapshot,
        'updatedAt': updatedAt.toIso8601String(),
      };

  static TwinProfileEntity fromJson(Map<String, dynamic> json) {
    final entity = TwinProfileEntity.create(
      chronotype: json['chronotype'] as String,
      productivityStyle: json['productivityStyle'] as String,
      goalOrientation: json['goalOrientation'] as String,
      habitConsistency: json['habitConsistency'] as String,
      moodTrend: json['moodTrend'] as String,
      traits: json['traitsJson'] is String
          ? jsonDecode(json['traitsJson'] as String) as Map<String, dynamic>
          : (json['traits'] as Map<String, dynamic>? ?? {}),
      lifeScoreSnapshot: json['lifeScoreSnapshot'] as int? ?? 0,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    return entity;
  }
}
