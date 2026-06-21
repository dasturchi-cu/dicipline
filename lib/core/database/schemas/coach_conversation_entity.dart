import 'package:isar/isar.dart';

part 'coach_conversation_entity.g.dart';

/// AI murabbiy suhbati — Life Twin chat tarixi.
@collection
class CoachConversationEntity {
  Id id = Isar.autoIncrement;

  /// user | coach
  @Index()
  late String role;

  late String message;

  @Index()
  late DateTime timestamp;

  /// text | voice
  late String inputType;

  /// daily_checkin | voice_chat | weekly_review | twin_insight
  String? contextType;

  CoachConversationEntity();

  CoachConversationEntity.create({
    required this.role,
    required this.message,
    this.inputType = 'text',
    this.contextType,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'inputType': inputType,
        'contextType': contextType,
      };

  static CoachConversationEntity fromJson(Map<String, dynamic> json) {
    final entity = CoachConversationEntity.create(
      role: json['role'] as String,
      message: json['message'] as String,
      inputType: json['inputType'] as String? ?? 'text',
      contextType: json['contextType'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    return entity;
  }
}
