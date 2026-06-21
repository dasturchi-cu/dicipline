import 'package:isar/isar.dart';

part 'note_entity.g.dart';

@collection
class NoteEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String title;

  late String emoji;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String content;

  List<String> tags = [];

  /// note | link | learning | audio_ref
  late String itemType;

  String? sourceUrl;

  late String category;

  List<String> lifeAreaIds = [];

  late bool isFavorite;

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;

  NoteEntity();

  NoteEntity.create({
    required this.title,
    this.emoji = '',
    required this.content,
    List<String>? tags,
    this.itemType = 'note',
    this.sourceUrl,
    this.category = 'umumiy',
    this.lifeAreaIds = const [],
    this.isFavorite = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'emoji': emoji,
        'content': content,
        'tags': tags,
        'itemType': itemType,
        'sourceUrl': sourceUrl,
        'category': category,
        'lifeAreaIds': lifeAreaIds,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static NoteEntity fromJson(Map<String, dynamic> json) {
    final entity = NoteEntity.create(
      title: json['title'] as String,
      emoji: json['emoji'] as String? ?? '',
      content: json['content'] as String,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      itemType: json['itemType'] as String? ?? 'note',
      sourceUrl: json['sourceUrl'] as String?,
      category: json['category'] as String? ?? 'umumiy',
      lifeAreaIds:
          (json['lifeAreaIds'] as List<dynamic>?)?.cast<String>() ?? [],
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
