import 'package:isar/isar.dart';

part 'challenge_entity.g.dart';

/// Musobaqa moduli — streak va progress kuzatuvi.
@collection
class ChallengeEntity {
  Id id = Isar.autoIncrement;

  /// early_wake_7 | english_30 | workout_14 | spending_30 | custom
  @Index()
  late String typeId;

  late String title;

  String emoji = '🏆';

  late int targetDays;

  int currentDay = 0;

  List<DateTime> completedDates = [];

  late DateTime startedAt;

  DateTime? completedAt;

  bool isActive = true;

  ChallengeEntity();

  ChallengeEntity.create({
    required this.typeId,
    required this.title,
    this.emoji = '🏆',
    required this.targetDays,
    this.currentDay = 0,
    List<DateTime>? completedDates,
    DateTime? startedAt,
    this.completedAt,
    this.isActive = true,
  })  : completedDates = completedDates ?? [],
        startedAt = startedAt ?? DateTime.now();

  double get progress =>
      targetDays > 0 ? (currentDay / targetDays).clamp(0.0, 1.0) : 0;

  bool get isCompleted => completedAt != null || currentDay >= targetDays;

  Map<String, dynamic> toJson() => {
        'id': id,
        'typeId': typeId,
        'title': title,
        'emoji': emoji,
        'targetDays': targetDays,
        'currentDay': currentDay,
        'completedDates':
            completedDates.map((d) => d.toIso8601String()).toList(),
        'startedAt': startedAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'isActive': isActive,
      };

  static ChallengeEntity fromJson(Map<String, dynamic> json) {
    final entity = ChallengeEntity.create(
      typeId: json['typeId'] as String,
      title: json['title'] as String,
      emoji: json['emoji'] as String? ?? '🏆',
      targetDays: json['targetDays'] as int,
      currentDay: json['currentDay'] as int? ?? 0,
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
