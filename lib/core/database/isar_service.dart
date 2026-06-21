import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'schemas/calendar_event_entity.dart';
import 'schemas/document_entity.dart';
import 'schemas/finance_transaction_entity.dart';
import 'schemas/goal_entity.dart';
import 'schemas/habit_entity.dart';
import 'schemas/journal_entry_entity.dart';
import 'schemas/note_entity.dart';
import 'schemas/study_session_entity.dart';
import 'schemas/study_subject_entity.dart';
import 'schemas/task_entity.dart';
import 'schemas/workout_entity.dart';

class IsarService {
  IsarService._();

  static final IsarService instance = IsarService._();

  Isar? _isar;

  static const List<CollectionSchema<dynamic>> schemas = [
    TaskEntitySchema,
    HabitEntitySchema,
    GoalEntitySchema,
    NoteEntitySchema,
    JournalEntryEntitySchema,
    WorkoutEntitySchema,
    StudySubjectEntitySchema,
    StudySessionEntitySchema,
    FinanceTransactionEntitySchema,
    CalendarEventEntitySchema,
    DocumentEntitySchema,
  ];

  bool get isOpen => _isar?.isOpen ?? false;

  Isar get isar {
    final database = _isar;
    if (database == null || !database.isOpen) {
      throw StateError(
        'Isar is not open. Call IsarService.instance.open() first.',
      );
    }
    return database;
  }

  Future<Isar> open({String? directory}) async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final dir = directory ?? (await getApplicationDocumentsDirectory()).path;
    _isar = await Isar.open(
      schemas,
      directory: dir,
      name: 'rejabon_ai',
    );
    return _isar!;
  }

  Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
    }
    _isar = null;
  }

  Future<void> clearAll() async {
    final database = isar;
    await database.writeTxn(() async {
      await database.clear();
    });
  }

  static Future<Isar> init() => instance.open();

  static Future<void> dispose() => instance.close();
}
