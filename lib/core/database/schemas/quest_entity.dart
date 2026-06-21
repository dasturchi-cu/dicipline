import 'package:isar/isar.dart';

part 'quest_entity.g.dart';

/// Kunlik/haftalik vazifa (quest).
@collection
class QuestEntity {
  Id id = Isar.autoIncrement;

  /// daily | weekly
  @Index()
  late String questType;

  /// tasks_3 | habits_all | journal | study_5 | workout | finance_log
  @Index()
  late String questId;

  late String title;

  late String description;

  /// discipline | health | knowledge | wealth | social | spiritual
  late String statReward;

  late int xpReward;

  /// auto | manual
  late String verificationType;

  /// JSON qoida: {"entity":"task","field":"completedToday","min":3}
  String? verificationRule;

  @Index()
  late DateTime startDate;

  @Index()
  late DateTime endDate;

  bool completed = false;

  DateTime? completedAt;

  QuestEntity();

  QuestEntity.create({
    required this.questType,
    required this.questId,
    required this.title,
    required this.description,
    required this.statReward,
    required this.xpReward,
    this.verificationType = 'auto',
    this.verificationRule,
    required this.startDate,
    required this.endDate,
    this.completed = false,
    this.completedAt,
  });

  double get progress => completed ? 1.0 : 0.0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'questType': questType,
        'questId': questId,
        'title': title,
        'description': description,
        'statReward': statReward,
        'xpReward': xpReward,
        'verificationType': verificationType,
        'verificationRule': verificationRule,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'completed': completed,
        'completedAt': completedAt?.toIso8601String(),
      };

  static QuestEntity fromJson(Map<String, dynamic> json) {
    final entity = QuestEntity.create(
      questType: json['questType'] as String,
      questId: json['questId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      statReward: json['statReward'] as String,
      xpReward: json['xpReward'] as int,
      verificationType: json['verificationType'] as String? ?? 'auto',
      verificationRule: json['verificationRule'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    return entity;
  }
}
