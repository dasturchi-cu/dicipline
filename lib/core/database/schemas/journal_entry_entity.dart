import 'package:isar/isar.dart';

part 'journal_entry_entity.g.dart';

@collection
class JournalEntryEntity {
  Id id = Isar.autoIncrement;

  /// One entry per calendar day; stored at local midnight UTC offset preserved.
  @Index(unique: true, replace: true)
  late DateTime date;

  late String content;

  /// Mood scale: 1 = very bad, 5 = very good.
  @Index()
  late int mood;

  @Index()
  late DateTime createdAt;

  JournalEntryEntity();

  JournalEntryEntity.create({
    required this.date,
    this.content = '',
    this.mood = 3,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'content': content,
        'mood': mood,
        'createdAt': createdAt.toIso8601String(),
      };

  static JournalEntryEntity fromJson(Map<String, dynamic> json) {
    final entity = JournalEntryEntity.create(
      date: DateTime.parse(json['date'] as String),
      content: json['content'] as String? ?? '',
      mood: json['mood'] as int? ?? 3,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
