import 'dart:convert';

import 'package:isar/isar.dart';
import '../database/schemas/calendar_event_entity.dart';
import '../database/schemas/document_entity.dart';
import '../database/schemas/finance_transaction_entity.dart';
import '../database/schemas/goal_entity.dart';
import '../database/schemas/habit_entity.dart';
import '../database/schemas/journal_entry_entity.dart';
import '../database/schemas/note_entity.dart';
import '../database/schemas/plan_entity.dart';
import '../database/schemas/study_session_entity.dart';
import '../database/schemas/study_subject_entity.dart';
import '../database/schemas/task_entity.dart';
import '../database/schemas/workout_entity.dart';

class BackupException implements Exception {
  BackupException(this.message);

  final String message;

  @override
  String toString() => 'BackupException: $message';
}

class BackupService {
  BackupService(this._isar);

  static const String currentVersion = '1.0.0';

  final Isar _isar;

  Future<Map<String, dynamic>> exportToMap() async {
    final tasks = await _isar.taskEntitys.where().findAll();
    final habits = await _isar.habitEntitys.where().findAll();
    final goals = await _isar.goalEntitys.where().findAll();
    final notes = await _isar.noteEntitys.where().findAll();
    final journal = await _isar.journalEntryEntitys.where().findAll();
    final workouts = await _isar.workoutEntitys.where().findAll();
    final studySubjects = await _isar.studySubjectEntitys.where().findAll();
    final studySessions = await _isar.studySessionEntitys.where().findAll();
    final finance = await _isar.financeTransactionEntitys.where().findAll();
    final events = await _isar.calendarEventEntitys.where().findAll();
    final documents = await _isar.documentEntitys.where().findAll();
    final plans = await _isar.planEntitys.where().findAll();

    return {
      'version': currentVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'tasks': tasks.map((e) => e.toJson()).toList(),
      'habits': habits.map((e) => e.toJson()).toList(),
      'goals': goals.map((e) => e.toJson()).toList(),
      'notes': notes.map((e) => e.toJson()).toList(),
      'journal': journal.map((e) => e.toJson()).toList(),
      'workouts': workouts.map((e) => e.toJson()).toList(),
      'studySubjects': studySubjects.map((e) => e.toJson()).toList(),
      'studySessions': studySessions.map((e) => e.toJson()).toList(),
      'finance': finance.map((e) => e.toJson()).toList(),
      'events': events.map((e) => e.toJson()).toList(),
      'documents': documents.map((e) => e.toJson()).toList(),
      'plans': plans.map((e) => e.toJson()).toList(),
    };
  }

  Future<String> exportToJson({bool pretty = true}) async {
    final data = await exportToMap();
    final encoder = pretty
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();
    return encoder.convert(data);
  }

  Future<void> restoreFromJson(
    String jsonString, {
    bool clearExisting = true,
  }) async {
    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw BackupException('Invalid backup format: root must be an object.');
    }
    await restoreFromMap(decoded, clearExisting: clearExisting);
  }

  Future<void> restoreFromMap(
    Map<String, dynamic> data, {
    bool clearExisting = true,
  }) async {
    _validateBackup(data);

    final tasks = _parseList(data['tasks'], TaskEntity.fromJson);
    final habits = _parseList(data['habits'], HabitEntity.fromJson);
    final goals = _parseList(data['goals'], GoalEntity.fromJson);
    final notes = _parseList(data['notes'], NoteEntity.fromJson);
    final journal =
        _parseList(data['journal'], JournalEntryEntity.fromJson);
    final workouts = _parseList(data['workouts'], WorkoutEntity.fromJson);
    final studySubjects =
        _parseList(data['studySubjects'], StudySubjectEntity.fromJson);
    final studySessions =
        _parseList(data['studySessions'], StudySessionEntity.fromJson);
    final finance =
        _parseList(data['finance'], FinanceTransactionEntity.fromJson);
    final events =
        _parseList(data['events'], CalendarEventEntity.fromJson);
    final documents = _parseList(data['documents'], DocumentEntity.fromJson);
    final plans = _parseList(data['plans'], PlanEntity.fromJson);

    await _isar.writeTxn(() async {
      if (clearExisting) {
        await _isar.clear();
      }

      await _isar.taskEntitys.putAll(tasks);
      await _isar.habitEntitys.putAll(habits);
      await _isar.goalEntitys.putAll(goals);
      await _isar.noteEntitys.putAll(notes);
      await _isar.journalEntryEntitys.putAll(journal);
      await _isar.workoutEntitys.putAll(workouts);
      await _isar.studySubjectEntitys.putAll(studySubjects);
      await _isar.studySessionEntitys.putAll(studySessions);
      await _isar.financeTransactionEntitys.putAll(finance);
      await _isar.calendarEventEntitys.putAll(events);
      await _isar.documentEntitys.putAll(documents);
      if (plans.isNotEmpty) {
        await _isar.planEntitys.putAll(plans);
      }
    });
  }

  void _validateBackup(Map<String, dynamic> data) {
    final version = data['version'];
    if (version is! String || version.isEmpty) {
      throw BackupException('Missing or invalid backup version.');
    }

    if (!_isSupportedVersion(version)) {
      throw BackupException('Unsupported backup version: $version');
    }

    const requiredKeys = [
      'tasks',
      'habits',
      'goals',
      'notes',
      'journal',
      'workouts',
      'studySubjects',
      'studySessions',
      'finance',
      'events',
      'documents',
    ];

    for (final key in requiredKeys) {
      if (data[key] is! List) {
        throw BackupException('Missing or invalid collection: $key');
      }
    }
  }

  bool _isSupportedVersion(String version) {
    return version == '1.0.0';
  }

  List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (value is! List) {
      return [];
    }

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
