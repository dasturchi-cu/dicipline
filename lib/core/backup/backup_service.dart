import 'dart:convert';

import 'package:isar/isar.dart';
import '../database/schemas/ai_memory_entity.dart';
import '../database/schemas/calendar_event_entity.dart';
import '../database/schemas/challenge_entity.dart';
import '../database/schemas/coach_conversation_entity.dart';
import '../database/schemas/future_letter_entity.dart';
import '../database/schemas/monthly_focus_entity.dart';
import '../database/schemas/document_entity.dart';
import '../database/schemas/finance_transaction_entity.dart';
import '../database/schemas/goal_entity.dart';
import '../database/schemas/habit_entity.dart';
import '../database/schemas/inbox_item_entity.dart';
import '../database/schemas/milestone_entity.dart';
import '../database/schemas/action_plan_entity.dart';
import '../database/schemas/achievement_unlock_entity.dart';
import '../database/schemas/twin_profile_entity.dart';
import '../database/schemas/journal_entry_entity.dart';
import '../database/schemas/player_profile_entity.dart';
import '../database/schemas/quest_entity.dart';
import '../database/schemas/xp_event_entity.dart';
import '../database/schemas/note_entity.dart';
import '../database/schemas/partnership_entity.dart';
import '../database/schemas/friend_challenge_entity.dart';
import '../database/schemas/group_challenge_entity.dart';
import '../database/schemas/referral_entity.dart';
import '../database/schemas/social_settings_entity.dart';
import '../database/schemas/plan_entity.dart';
import '../database/schemas/study_session_entity.dart';
import '../database/schemas/study_subject_entity.dart';
import '../database/schemas/time_log_entity.dart';
import '../database/schemas/task_entity.dart';
import '../database/schemas/vision_board_item_entity.dart';
import '../database/schemas/workout_entity.dart';

class BackupException implements Exception {
  BackupException(this.message);

  final String message;

  @override
  String toString() => 'BackupException: $message';
}

class BackupService {
  BackupService(this._isar);

  static const String currentVersion = '1.2.0';

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
    final monthlyFocus = await _isar.monthlyFocusEntitys.where().findAll();
    final aiMemories = await _isar.aiMemoryEntitys.where().findAll();
    final challenges = await _isar.challengeEntitys.where().findAll();
    final inbox = await _isar.inboxItemEntitys.where().findAll();
    final timeLogs = await _isar.timeLogEntitys.where().findAll();
    final milestones = await _isar.milestoneEntitys.where().findAll();
    final futureLetters = await _isar.futureLetterEntitys.where().findAll();
    final visionBoard = await _isar.visionBoardItemEntitys.where().findAll();
    final partnerships = await _isar.partnershipEntitys.where().findAll();
    final coachConversations =
        await _isar.coachConversationEntitys.where().findAll();
    final playerProfiles =
        await _isar.playerProfileEntitys.where().findAll();
    final quests = await _isar.questEntitys.where().findAll();
    final xpEvents = await _isar.xpEventEntitys.where().findAll();
    final achievementUnlocks =
        await _isar.achievementUnlockEntitys.where().findAll();
    final twinProfiles = await _isar.twinProfileEntitys.where().findAll();
    final actionPlans = await _isar.actionPlanEntitys.where().findAll();
    final referrals = await _isar.referralEntitys.where().findAll();
    final friendChallenges =
        await _isar.friendChallengeEntitys.where().findAll();
    final groupChallenges =
        await _isar.groupChallengeEntitys.where().findAll();
    final socialSettings =
        await _isar.socialSettingsEntitys.where().findAll();

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
      'monthlyFocus': monthlyFocus.map((e) => e.toJson()).toList(),
      'aiMemories': aiMemories.map((e) => e.toJson()).toList(),
      'challenges': challenges.map((e) => e.toJson()).toList(),
      'inbox': inbox.map((e) => e.toJson()).toList(),
      'timeLogs': timeLogs.map((e) => e.toJson()).toList(),
      'milestones': milestones.map((e) => e.toJson()).toList(),
      'futureLetters': futureLetters.map((e) => e.toJson()).toList(),
      'visionBoard': visionBoard.map((e) => e.toJson()).toList(),
      'partnerships': partnerships.map((e) => e.toJson()).toList(),
      'coachConversations':
          coachConversations.map((e) => e.toJson()).toList(),
      'playerProfiles': playerProfiles.map((e) => e.toJson()).toList(),
      'quests': quests.map((e) => e.toJson()).toList(),
      'xpEvents': xpEvents.map((e) => e.toJson()).toList(),
      'achievementUnlocks':
          achievementUnlocks.map((e) => e.toJson()).toList(),
      'twinProfiles': twinProfiles.map((e) => e.toJson()).toList(),
      'actionPlans': actionPlans.map((e) => e.toJson()).toList(),
      'referrals': referrals.map((e) => e.toJson()).toList(),
      'friendChallenges': friendChallenges.map((e) => e.toJson()).toList(),
      'groupChallenges': groupChallenges.map((e) => e.toJson()).toList(),
      'socialSettings': socialSettings.map((e) => e.toJson()).toList(),
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
    final monthlyFocus =
        _parseList(data['monthlyFocus'], MonthlyFocusEntity.fromJson);
    final aiMemories =
        _parseList(data['aiMemories'], AiMemoryEntity.fromJson);
    final challenges =
        _parseList(data['challenges'], ChallengeEntity.fromJson);
    final inbox = _parseList(data['inbox'], InboxItemEntity.fromJson);
    final timeLogs = _parseList(data['timeLogs'], TimeLogEntity.fromJson);
    final milestones =
        _parseList(data['milestones'], MilestoneEntity.fromJson);
    final futureLetters =
        _parseList(data['futureLetters'], FutureLetterEntity.fromJson);
    final visionBoard =
        _parseList(data['visionBoard'], VisionBoardItemEntity.fromJson);
    final partnerships =
        _parseList(data['partnerships'], PartnershipEntity.fromJson);
    final coachConversations = _parseList(
      data['coachConversations'],
      CoachConversationEntity.fromJson,
    );
    final playerProfiles = _parseList(
      data['playerProfiles'],
      PlayerProfileEntity.fromJson,
    );
    final quests = _parseList(data['quests'], QuestEntity.fromJson);
    final xpEvents = _parseList(data['xpEvents'], XpEventEntity.fromJson);
    final achievementUnlocks = _parseList(
      data['achievementUnlocks'],
      AchievementUnlockEntity.fromJson,
    );
    final twinProfiles =
        _parseList(data['twinProfiles'], TwinProfileEntity.fromJson);
    final actionPlans =
        _parseList(data['actionPlans'], ActionPlanEntity.fromJson);
    final referrals =
        _parseList(data['referrals'], ReferralEntity.fromJson);
    final friendChallenges = _parseList(
      data['friendChallenges'],
      FriendChallengeEntity.fromJson,
    );
    final groupChallenges = _parseList(
      data['groupChallenges'],
      GroupChallengeEntity.fromJson,
    );
    final socialSettings = _parseList(
      data['socialSettings'],
      SocialSettingsEntity.fromJson,
    );

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
      if (monthlyFocus.isNotEmpty) {
        await _isar.monthlyFocusEntitys.putAll(monthlyFocus);
      }
      if (aiMemories.isNotEmpty) {
        await _isar.aiMemoryEntitys.putAll(aiMemories);
      }
      if (challenges.isNotEmpty) {
        await _isar.challengeEntitys.putAll(challenges);
      }
      if (inbox.isNotEmpty) {
        await _isar.inboxItemEntitys.putAll(inbox);
      }
      if (timeLogs.isNotEmpty) {
        await _isar.timeLogEntitys.putAll(timeLogs);
      }
      if (milestones.isNotEmpty) {
        await _isar.milestoneEntitys.putAll(milestones);
      }
      if (futureLetters.isNotEmpty) {
        await _isar.futureLetterEntitys.putAll(futureLetters);
      }
      if (visionBoard.isNotEmpty) {
        await _isar.visionBoardItemEntitys.putAll(visionBoard);
      }
      if (partnerships.isNotEmpty) {
        await _isar.partnershipEntitys.putAll(partnerships);
      }
      if (coachConversations.isNotEmpty) {
        await _isar.coachConversationEntitys.putAll(coachConversations);
      }
      if (playerProfiles.isNotEmpty) {
        await _isar.playerProfileEntitys.putAll(playerProfiles);
      }
      if (quests.isNotEmpty) {
        await _isar.questEntitys.putAll(quests);
      }
      if (xpEvents.isNotEmpty) {
        await _isar.xpEventEntitys.putAll(xpEvents);
      }
      if (achievementUnlocks.isNotEmpty) {
        await _isar.achievementUnlockEntitys.putAll(achievementUnlocks);
      }
      if (twinProfiles.isNotEmpty) {
        await _isar.twinProfileEntitys.putAll(twinProfiles);
      }
      if (actionPlans.isNotEmpty) {
        await _isar.actionPlanEntitys.putAll(actionPlans);
      }
      if (referrals.isNotEmpty) {
        await _isar.referralEntitys.putAll(referrals);
      }
      if (friendChallenges.isNotEmpty) {
        await _isar.friendChallengeEntitys.putAll(friendChallenges);
      }
      if (groupChallenges.isNotEmpty) {
        await _isar.groupChallengeEntitys.putAll(groupChallenges);
      }
      if (socialSettings.isNotEmpty) {
        await _isar.socialSettingsEntitys.putAll(socialSettings);
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
    return version == '1.0.0' || version == '1.1.0' || version == '1.2.0';
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
