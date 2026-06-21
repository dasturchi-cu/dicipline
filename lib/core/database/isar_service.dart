import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'schemas/ai_memory_entity.dart';
import 'schemas/achievement_unlock_entity.dart';
import 'schemas/app_meta.dart';
import 'schemas/calendar_event_entity.dart';
import 'schemas/challenge_entity.dart';
import 'schemas/document_entity.dart';
import 'schemas/finance_transaction_entity.dart';
import 'schemas/goal_entity.dart';
import 'schemas/habit_entity.dart';
import 'schemas/monthly_focus_entity.dart';
import 'schemas/inbox_item_entity.dart';
import 'schemas/milestone_entity.dart';
import 'schemas/journal_entry_entity.dart';
import 'schemas/note_entity.dart';
import 'schemas/plan_entity.dart';
import 'schemas/player_profile_entity.dart';
import 'schemas/quest_entity.dart';
import 'schemas/study_session_entity.dart';
import 'schemas/study_subject_entity.dart';
import 'schemas/time_log_entity.dart';
import 'schemas/task_entity.dart';
import 'schemas/workout_entity.dart';
import 'schemas/xp_event_entity.dart';
import 'schemas/action_plan_entity.dart';
import 'schemas/twin_profile_entity.dart';
import 'schemas/future_letter_entity.dart';
import 'schemas/referral_entity.dart';
import 'schemas/friend_challenge_entity.dart';
import 'schemas/group_challenge_entity.dart';
import 'schemas/social_settings_entity.dart';
import 'schemas/partnership_entity.dart';
import 'schemas/coach_conversation_entity.dart';
import 'schemas/vision_board_item_entity.dart';
import 'migrations/database_migration_service.dart';

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
    PlanEntitySchema,
    MonthlyFocusEntitySchema,
    AiMemoryEntitySchema,
    ChallengeEntitySchema,
    InboxItemEntitySchema,
    TimeLogEntitySchema,
    MilestoneEntitySchema,
    AppMetaSchema,
    PlayerProfileEntitySchema,
    XpEventEntitySchema,
    AchievementUnlockEntitySchema,
    QuestEntitySchema,
    FutureLetterEntitySchema,
    PartnershipEntitySchema,
    CoachConversationEntitySchema,
    TwinProfileEntitySchema,
    ActionPlanEntitySchema,
    ReferralEntitySchema,
    FriendChallengeEntitySchema,
    GroupChallengeEntitySchema,
    SocialSettingsEntitySchema,
    VisionBoardItemEntitySchema,
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
    await DatabaseMigrationService(_isar!).migrate();
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
