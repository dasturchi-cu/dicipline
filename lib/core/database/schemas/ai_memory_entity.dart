import 'package:isar/isar.dart';

part 'ai_memory_entity.g.dart';

/// AI xotirasi — foydalanuvchi haqida o'rganilgan naqshlar.
@collection
class AiMemoryEntity {
  Id id = Isar.autoIncrement;

  /// goals | habits | learning | fitness | finance | productivity
  @Index()
  late String category;

  late String insight;

  /// 0.0 – 1.0 ishonch darajasi
  late double confidence;

  @Index()
  late DateTime createdAt;

  late DateTime lastReferencedAt;

  int referenceCount = 0;

  AiMemoryEntity();

  AiMemoryEntity.create({
    required this.category,
    required this.insight,
    this.confidence = 0.8,
    DateTime? createdAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastReferencedAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'insight': insight,
        'confidence': confidence,
        'createdAt': createdAt.toIso8601String(),
        'lastReferencedAt': lastReferencedAt.toIso8601String(),
        'referenceCount': referenceCount,
      };

  static AiMemoryEntity fromJson(Map<String, dynamic> json) {
    final entity = AiMemoryEntity.create(
      category: json['category'] as String,
      insight: json['insight'] as String,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.8,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    entity.lastReferencedAt =
        DateTime.parse(json['lastReferencedAt'] as String);
    entity.referenceCount = json['referenceCount'] as int? ?? 0;
    return entity;
  }
}
