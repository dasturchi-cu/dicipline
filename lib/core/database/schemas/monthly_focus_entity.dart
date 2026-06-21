import 'package:isar/isar.dart';

part 'monthly_focus_entity.g.dart';

/// Oylik asosiy maqsad — har oy bitta fokus.
@collection
class MonthlyFocusEntity {
  Id id = Isar.autoIncrement;

  /// Format: "YYYY-MM"
  @Index(unique: true)
  late String monthKey;

  late int goalId;

  late String focusTitle;

  String emoji = '🎯';

  String? focusDescription;

  late DateTime setAt;

  MonthlyFocusEntity();

  MonthlyFocusEntity.create({
    required this.monthKey,
    required this.goalId,
    required this.focusTitle,
    this.emoji = '🎯',
    this.focusDescription,
    DateTime? setAt,
  }) : setAt = setAt ?? DateTime.now();

  static String monthKeyFor(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'monthKey': monthKey,
        'goalId': goalId,
        'focusTitle': focusTitle,
        'emoji': emoji,
        'focusDescription': focusDescription,
        'setAt': setAt.toIso8601String(),
      };

  static MonthlyFocusEntity fromJson(Map<String, dynamic> json) {
    final entity = MonthlyFocusEntity.create(
      monthKey: json['monthKey'] as String,
      goalId: json['goalId'] as int,
      focusTitle: json['focusTitle'] as String,
      emoji: json['emoji'] as String? ?? '🎯',
      focusDescription: json['focusDescription'] as String?,
      setAt: DateTime.parse(json['setAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
