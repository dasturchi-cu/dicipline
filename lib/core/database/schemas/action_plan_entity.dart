import 'dart:convert';

import 'package:isar/isar.dart';

part 'action_plan_entity.g.dart';

/// AI Action Engine tomonidan yaratilgan reja.
@collection
class ActionPlanEntity {
  Id id = Isar.autoIncrement;

  /// schedule_adjust | plan_rebuild | recovery | intervention
  @Index()
  late String planType;

  late String title;

  late String summary;

  /// JSON: [{title, description, priority, dueDate?}]
  late String actionsJson;

  /// pending | applied | dismissed
  @Index()
  late String status;

  late DateTime createdAt;

  DateTime? appliedAt;

  ActionPlanEntity();

  ActionPlanEntity.create({
    required this.planType,
    required this.title,
    required this.summary,
    required List<Map<String, dynamic>> actions,
    this.status = 'pending',
    DateTime? createdAt,
    this.appliedAt,
  })  : actionsJson = jsonEncode(actions),
        createdAt = createdAt ?? DateTime.now();

  @ignore
  List<Map<String, dynamic>> get actions {
    final decoded = jsonDecode(actionsJson);
    if (decoded is! List) return [];
    return decoded.cast<Map<String, dynamic>>();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'planType': planType,
        'title': title,
        'summary': summary,
        'actionsJson': actionsJson,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'appliedAt': appliedAt?.toIso8601String(),
      };

  static ActionPlanEntity fromJson(Map<String, dynamic> json) {
    final entity = ActionPlanEntity.create(
      planType: json['planType'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      actions: json['actionsJson'] is String
          ? (jsonDecode(json['actionsJson'] as String) as List)
              .cast<Map<String, dynamic>>()
          : (json['actions'] as List<dynamic>?)
                  ?.cast<Map<String, dynamic>>() ??
              [],
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
      appliedAt: json['appliedAt'] != null
          ? DateTime.parse(json['appliedAt'] as String)
          : null,
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    return entity;
  }
}
