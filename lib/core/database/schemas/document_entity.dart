import 'package:isar/isar.dart';

part 'document_entity.g.dart';

@collection
class DocumentEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String title;

  String? description;

  @Index()
  late String type;

  /// pdf | image | audio | link | document
  late String mediaType;

  String? sourceUrl;

  List<String> lifeAreaIds = [];

  late bool isFavorite;

  @Index()
  late DateTime createdAt;

  DocumentEntity();

  DocumentEntity.create({
    required this.title,
    this.description,
    required this.type,
    this.mediaType = 'document',
    this.sourceUrl,
    this.lifeAreaIds = const [],
    this.isFavorite = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type,
        'mediaType': mediaType,
        'sourceUrl': sourceUrl,
        'lifeAreaIds': lifeAreaIds,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
      };

  static DocumentEntity fromJson(Map<String, dynamic> json) {
    final entity = DocumentEntity.create(
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      mediaType: json['mediaType'] as String? ?? 'document',
      sourceUrl: json['sourceUrl'] as String?,
      lifeAreaIds:
          (json['lifeAreaIds'] as List<dynamic>?)?.cast<String>() ?? [],
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
