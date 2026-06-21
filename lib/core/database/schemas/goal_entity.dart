import 'package:isar/isar.dart';

part 'goal_entity.g.dart';

@embedded
class MilestoneEmbedded {
  late String title;
  late bool isCompleted;

  MilestoneEmbedded();

  MilestoneEmbedded.create({
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
      };

  static MilestoneEmbedded fromJson(Map<String, dynamic> json) {
    return MilestoneEmbedded.create(
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

@collection
class GoalEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String title;

  late String emoji;

  String? description;

  /// Progress percentage from 0 to 100.
  late double progress;

  List<MilestoneEmbedded> milestones = [];

  /// Hayot sohalari
  List<String> lifeAreaIds = [];

  /// Uzoq muddat: 5y, 1y, 3m, 1m yoki null (kundalik)
  String? horizon;

  /// Yuqori darajadagi maqsad bog'lanishi
  int? parentGoalId;

  @Index()
  DateTime? targetDate;

  @Index()
  late DateTime createdAt;

  GoalEntity();

  GoalEntity.create({
    required this.title,
    this.emoji = '',
    this.description,
    this.progress = 0,
    List<MilestoneEmbedded>? milestones,
    this.lifeAreaIds = const [],
    this.horizon,
    this.parentGoalId,
    this.targetDate,
    DateTime? createdAt,
  })  : milestones = milestones ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'emoji': emoji,
        'description': description,
        'progress': progress,
        'milestones': milestones.map((m) => m.toJson()).toList(),
        'lifeAreaIds': lifeAreaIds,
        'horizon': horizon,
        'parentGoalId': parentGoalId,
        'targetDate': targetDate?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  static GoalEntity fromJson(Map<String, dynamic> json) {
    final entity = GoalEntity.create(
      title: json['title'] as String,
      emoji: json['emoji'] as String? ?? '',
      description: json['description'] as String?,
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((e) => MilestoneEmbedded.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lifeAreaIds:
          (json['lifeAreaIds'] as List<dynamic>?)?.cast<String>() ?? [],
      horizon: json['horizon'] as String?,
      parentGoalId: json['parentGoalId'] as int?,
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
