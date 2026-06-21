import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/utils/date_format.dart';
import '../../future_simulator/domain/future_prediction_engine.dart';
import '../../journal/domain/mood_trend_service.dart';

/// Kunlik AI brifing — ertalab prioritetlar.
class DailyBriefing {
  const DailyBriefing({
    required this.greeting,
    required this.priorities,
    required this.goalProgressLine,
    required this.habitReminders,
    required this.aiAdvice,
    required this.productivityPrediction,
    required this.moodLine,
    required this.streakLine,
  });

  final String greeting;
  final List<String> priorities;
  final String goalProgressLine;
  final List<String> habitReminders;
  final String aiAdvice;
  final String productivityPrediction;
  final String moodLine;
  final String streakLine;
}

/// Har kuni ertalab AI brifing yaratadi.
class DailyBriefingService {
  DailyBriefingService({
    MoodTrendService? moodTrend,
    FuturePredictionEngine? predictionEngine,
  })  : _mood = moodTrend ?? const MoodTrendService(),
        _predictions = predictionEngine ?? FuturePredictionEngine();

  final MoodTrendService _mood;
  final FuturePredictionEngine _predictions;

  DailyBriefing generate({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
    required int longestStreak,
    required int habitsDoneToday,
    required int habitsTotal,
    String userName = '',
    DateTime? asOf,
  }) {
    final now = asOf ?? DateTime.now();
    final today = AppDateFormat.dateOnly(now);
    final hour = now.hour;

    final greeting = _greeting(hour, userName);
    final priorities = _priorities(tasks, today);
    final goalLine = _goalProgress(goals);
    final habitReminders = _habitReminders(habits, habitsDoneToday, habitsTotal);
    final moodReport = _mood.compute(journal, asOf: now);
    final predictions = _predictions.predict(
      goals: goals,
      habits: habits,
      tasks: tasks,
      journal: journal,
    );

    final productivityPrediction = predictions.trends.isNotEmpty
        ? predictions.trends.firstWhere(
            (t) => t.metric == 'productivity',
            orElse: () => predictions.trends.first,
          ).insight
        : 'Bugun barqaror sur\'atda davom eting.';

    final aiAdvice = _advice(
      moodReport: moodReport,
      overdue: tasks.where((t) {
        if (t.isCompleted || t.dueDate == null) return false;
        return AppDateFormat.dateOnly(t.dueDate!).isBefore(today);
      }).length,
      streakRisks: predictions.streakRisks,
    );

    return DailyBriefing(
      greeting: greeting,
      priorities: priorities,
      goalProgressLine: goalLine,
      habitReminders: habitReminders,
      aiAdvice: aiAdvice,
      productivityPrediction: productivityPrediction,
      moodLine: moodReport.hasSufficientData
          ? 'Kayfiyat: ${moodReport.average7d.toStringAsFixed(1)}/5 — ${moodReport.insight}'
          : 'Kayfiyat: kundalik yozing.',
      streakLine: longestStreak > 0
          ? 'Eng uzun ketma-ketlik: $longestStreak kun 🔥'
          : 'Bugun yangi ketma-ketlik boshlang.',
    );
  }

  String _greeting(int hour, String userName) {
    final base = hour < 12
        ? 'Xayrli tong'
        : hour < 18
            ? 'Xayrli kun'
            : 'Xayrli kech';
    return userName.isNotEmpty ? '$base, $userName!' : '$base!';
  }

  List<String> _priorities(List<TaskEntity> tasks, DateTime today) {
    final active = tasks.where((t) => !t.isCompleted).toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    final overdue = active.where((t) {
      if (t.dueDate == null) return false;
      return AppDateFormat.dateOnly(t.dueDate!).isBefore(today);
    });

    final dueToday = active.where((t) {
      if (t.dueDate == null) return false;
      return AppDateFormat.isSameDay(t.dueDate!, today);
    });

    final priorities = <String>[];
    if (overdue.isNotEmpty) {
      priorities.add('⚠️ ${overdue.length} ta muddati o\'tgan vazifa');
    }
    for (final t in dueToday.take(2)) {
      priorities.add('📌 ${t.title}');
    }
    for (final t in active.take(3)) {
      if (priorities.length >= 3) break;
      if (dueToday.contains(t) || overdue.contains(t)) continue;
      priorities.add('• ${t.title}');
    }
    if (priorities.isEmpty) {
      priorities.add('Bugun yangi vazifa yoki odat bilan boshlang.');
    }
    return priorities.take(3).toList();
  }

  String _goalProgress(List<GoalEntity> goals) {
    final active = goals.where((g) => g.progress < 100).toList();
    if (active.isEmpty) {
      return goals.isEmpty
          ? 'Maqsad qo\'ying — yo\'nalish aniq bo\'ladi.'
          : 'Barcha maqsadlar bajarildi! 🎉';
    }
    active.sort((a, b) => b.progress.compareTo(a.progress));
    final top = active.first;
    return '"${top.title}" — ${top.progress.round()}% bajarildi';
  }

  List<String> _habitReminders(
    List<HabitEntity> habits,
    int done,
    int total,
  ) {
    if (habits.isEmpty) {
      return ['Birinchi odatni yarating — kichik qadam katta natija.'];
    }
    if (done >= total) {
      return ['Barcha odatlar bugun bajarildi! ✅'];
    }
    final pending = habits.where((h) {
      final today = AppDateFormat.dateOnly(DateTime.now());
      return !h.completedDates.any((d) => AppDateFormat.isSameDay(d, today));
    }).take(3);
    return pending.map((h) => '🔁 ${h.name}').toList();
  }

  String _advice({
    required MoodTrendReport moodReport,
    required int overdue,
    required List<StreakRiskPrediction> streakRisks,
  }) {
    if (moodReport.burnoutRisk) {
      return 'Kayfiyat past — bugun yengil rejim va dam olish muhim.';
    }
    if (overdue >= 3) {
      return 'Ko\'p vazifa to\'plangan — bittasini tanlab yoping, keyin davom eting.';
    }
    if (streakRisks.isNotEmpty && streakRisks.first.riskScore > 0.6) {
      return '${streakRisks.first.habitName}: streak xavfi — bugun bajaring!';
    }
    if (moodReport.trend == 'up') {
      return 'Kayfiyatingiz yaxshilanmoqda — muhim vazifalarni bugun rejalashtiring.';
    }
    return 'Kichik qadamlar katta natija beradi — bitta vazifa bilan boshlang.';
  }
}
