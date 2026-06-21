import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/note_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../journal/domain/mood_trend_service.dart';
import '../../life_twin/domain/coach_pattern_engine.dart';

/// Favqulodda rejim javobi.
class EmergencyResponse {
  const EmergencyResponse({
    required this.motivation,
    required this.smallActions,
    required this.recoverySteps,
    required this.positiveReflection,
    required this.urgencyLevel,
  });

  final String motivation;
  final List<String> smallActions;
  final List<String> recoverySteps;
  final String positiveReflection;
  final String urgencyLevel;
}

/// "Yomon his qilyapman" — darhol yordam.
class EmergencyModeService {
  EmergencyModeService({
    CoachPatternEngine? patterns,
    MoodTrendService? moodTrend,
  })  : _patterns = patterns ?? const CoachPatternEngine(),
        _mood = moodTrend ?? const MoodTrendService();

  final CoachPatternEngine _patterns;
  final MoodTrendService _mood;

  EmergencyResponse generate({
    required List<JournalEntryEntity> journal,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required int completedTasksTotal,
    required int longestStreak,
  }) {
    final moodReport = _mood.compute(journal);
    final burnout = journal.isNotEmpty && tasks.isNotEmpty
        ? _patterns.detectBurnout(journal: journal, tasks: tasks)
        : null;

    final urgency = burnout != null || moodReport.burnoutRisk
        ? 'high'
        : moodReport.hasSufficientData && moodReport.average7d <= 2
            ? 'medium'
            : 'low';

    final motivation = _motivation(urgency, longestStreak, completedTasksTotal);
    final actions = _smallActions(habits, tasks);
    final recovery = _recoverySteps(urgency);
    final reflection = _positiveReflection(
      completedTasksTotal: completedTasksTotal,
      longestStreak: longestStreak,
      goals: goals,
    );

    return EmergencyResponse(
      motivation: motivation,
      smallActions: actions,
      recoverySteps: recovery,
      positiveReflection: reflection,
      urgencyLevel: urgency,
    );
  }

  String _motivation(String urgency, int streak, int tasksDone) {
    return switch (urgency) {
      'high' =>
        'Hozir og\'ir bo\'lishi mumkin — bu vaqtinchalik. Siz $tasksDone ta vazifa bajargansiz. Dam olish ham kuch.',
      'medium' =>
        'Kayfiyat o\'zgarishi tabiiy. $streak kunlik ketma-ketlik sizda bor — bu kuchli qism.',
      _ =>
        'Har bir kun yangi imkoniyat. Bugun faqat bitta kichik qadam yetarli.',
    };
  }

  List<String> _smallActions(List<HabitEntity> habits, List<TaskEntity> tasks) {
    return [
      '3 marta chuqur nafas oling — hozir.',
      '1 stakan suv iching.',
      if (habits.isNotEmpty)
        'Eng oson odat: "${habits.first.name}" — 2 daqiqa.',
      'Telefonni 10 daqiqa chetda qo\'ying.',
      'Bitta vazifani tanlang — faqat 5 daqiqa.',
    ].take(4).toList();
  }

  List<String> _recoverySteps(String urgency) {
    if (urgency == 'high') {
      return [
        'Bugun reja emas — tiklanish kuni.',
        '30 daqiqa yurish yoki musiqa.',
        'Kundalikga 3 ta gap yozing.',
        'Ertaga yengil reja — 2 ta vazifa max.',
      ];
    }
    return [
      'Bugun faqat 2 ta muhim vazifa.',
      'Kechqurun 10 daqiqa refleksiya.',
      'Ertalab 5 daqiqa reja.',
    ];
  }

  String _positiveReflection({
    required int completedTasksTotal,
    required int longestStreak,
    required List<GoalEntity> goals,
  }) {
    if (longestStreak >= 7) {
      return 'Siz $longestStreak kun ketma-ketlik qilgan ekansiz — bu sizda bor kuch.';
    }
    if (completedTasksTotal >= 10) {
      return '$completedTasksTotal ta vazifa bajargansiz — siz harakat qiluvchisiz.';
    }
    if (goals.isNotEmpty) {
      return '"${goals.first.title}" maqsadi sizda bor — bu allaqachon katta qadam.';
    }
    return 'Bugun yordam so\'rashingiz — bu ham kuchli qadam.';
  }
}
