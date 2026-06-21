import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/database/schemas/twin_profile_entity.dart';
import 'package:rejabon_ai/core/repositories/habit_repository.dart';
import 'package:rejabon_ai/features/life_twin/domain/coach_pattern_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/models/twin_models.dart';
import 'package:rejabon_ai/features/life_twin/domain/twin_profile_engine.dart';

/// Raqamli ikki — o'rganish, naqshlar va shaxsiy tavsiyalar.
class LifeTwinEngine {
  LifeTwinEngine({
    CoachPatternEngine? patterns,
    TwinProfileEngine? profileEngine,
    HabitRepository? habitRepo,
  })  : _patterns = patterns ?? const CoachPatternEngine(),
        _profileEngine = profileEngine ?? const TwinProfileEngine(),
        _habitRepo = habitRepo;

  final CoachPatternEngine _patterns;
  final TwinProfileEngine _profileEngine;
  final HabitRepository? _habitRepo;

  LifeTwinAnalysis analyze({
    required LifeTwinProfile profile,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
    TwinProfileEntity? storedProfile,
  }) {
    final computed = _profileEngine.compute(
      tasks: tasks,
      habits: habits,
      goals: goals,
      journal: journal,
    );
    final dayProfile = _patterns.analyzeDayOfWeek(tasks);
    final peakHours = _peakHoursLabel(tasks);
    final learningStyle = _learningStyle(tasks, habits, journal);
    final strengths = _strengths(computed, profile);
    final weaknesses = _weaknesses(computed, profile, tasks, habits);

    final insights = <TwinInsight>[
      ..._patternInsights(dayProfile, peakHours, computed, tasks),
      ..._moodInsights(journal, tasks),
      ..._habitInsights(habits, computed),
      ..._goalInsights(goals),
    ];

    final recommendations = _recommendations(
      profile: profile,
      computed: computed,
      peakHours: peakHours,
      learningStyle: learningStyle,
      tasks: tasks,
      habits: habits,
      goals: goals,
    );

    insights.sort((a, b) => b.confidence.compareTo(a.confidence));
    recommendations.sort((a, b) => b.priority.compareTo(a.priority));

    return LifeTwinAnalysis(
      insights: insights.take(8).toList(),
      recommendations: recommendations.take(6).toList(),
      peakHoursLabel: peakHours,
      learningStyle: learningStyle,
      strengths: strengths,
      weaknesses: weaknesses,
    );
  }

  String _peakHoursLabel(List<TaskEntity> tasks) {
    final completed = tasks.where((t) => t.isCompleted).toList();
    if (completed.length < 5) return '09:00–12:00 (standart)';

    final hourCounts = List.filled(24, 0);
    for (final t in completed) {
      hourCounts[t.updatedAt.hour]++;
    }
    var bestStart = 9;
    var bestCount = 0;
    for (var h = 6; h <= 20; h++) {
      final window = hourCounts[h] +
          (h + 1 < 24 ? hourCounts[h + 1] : 0) +
          (h + 2 < 24 ? hourCounts[h + 2] : 0);
      if (window > bestCount) {
        bestCount = window;
        bestStart = h;
      }
    }
    final end = (bestStart + 3).clamp(0, 23);
    return '${bestStart.toString().padLeft(2, '0')}:00–${end.toString().padLeft(2, '0')}:00';
  }

  String _learningStyle(
    List<TaskEntity> tasks,
    List<HabitEntity> habits,
    List<JournalEntryEntity> journal,
  ) {
    final studyHabits = habits.where((h) {
      final n = h.name.toLowerCase();
      return n.contains('o\'qish') ||
          n.contains('study') ||
          n.contains('ielts') ||
          n.contains('ingliz');
    }).length;

    final weekendStudy = journal.where((j) {
      final d = j.date.weekday;
      return (d == DateTime.saturday || d == DateTime.sunday) &&
          j.content.toLowerCase().contains('o\'q');
    }).length;
    final weekdayStudy = journal.length - weekendStudy;

    if (studyHabits >= 2 && weekdayStudy > weekendStudy) {
      return 'daily_sessions';
    }
    if (weekendStudy > weekdayStudy * 1.5) {
      return 'weekend_cramming';
    }
    return 'mixed';
  }

  List<String> _strengths(
    ComputedTwinProfile computed,
    LifeTwinProfile profile,
  ) {
    final s = <String>[];
    if (computed.habitConsistency == 'high') {
      s.add('Kuchli odat intizomi');
    }
    if (computed.taskCompletionRate >= 0.6) {
      s.add('Yuqori vazifa bajarish');
    }
    if (computed.chronotype == 'morning_person') {
      s.add('Ertalabki energiya');
    }
    if (profile.lifeScore >= 70) s.add('Barqaror hayot balli');
    if (s.isEmpty) s.add('O\'sish potensiali yuqori');
    return s;
  }

  List<String> _weaknesses(
    ComputedTwinProfile computed,
    LifeTwinProfile profile,
    List<TaskEntity> tasks,
    List<HabitEntity> habits,
  ) {
    final w = <String>[];
    if (computed.habitConsistency == 'low') {
      w.add('Odat barqarorligi past');
    }
    if (profile.burnout != null) w.add('Burnout xavfi');
    final overdue = tasks.where((t) {
      if (t.isCompleted || t.dueDate == null) return false;
      return t.dueDate!.isBefore(DateTime.now());
    }).length;
    if (overdue >= 3) w.add('Kechikkan vazifalar');
    if (habits.isEmpty) w.add('Odatlar yo\'q');
    return w;
  }

  List<TwinInsight> _patternInsights(
    DayPerformanceProfile dayProfile,
    String peakHours,
    ComputedTwinProfile computed,
    List<TaskEntity> tasks,
  ) {
    final insights = <TwinInsight>[
      TwinInsight(
        id: 'peak_hours',
        category: 'productivity',
        headline: 'Eng samarali vaqt',
        body: 'Siz $peakHours oralig\'ida eng yaxshi natija ko\'rsatasiz.',
        confidence: tasks.where((t) => t.isCompleted).length >= 10 ? 0.9 : 0.65,
        evidence: ['${dayProfile.bestDay}: ${(dayProfile.bestDayRate * 100).round()}%'],
      ),
    ];

    if (computed.productivityStyle == 'burst') {
      insights.add(
        const TwinInsight(
          id: 'burst_style',
          category: 'personality',
          headline: 'Portlash uslubi',
          body:
              'Siz kunlar bo\'yicha faol bo\'lib, keyin dam olasiz. Kichik kunlik sessiyalar yaxshiroq ishlaydi.',
          confidence: 0.82,
        ),
      );
    }

    if (computed.chronotype == 'morning_person') {
      insights.add(
        const TwinInsight(
          id: 'morning_chronotype',
          category: 'personality',
          headline: 'Ertalabki odam',
          body: 'Ertalabki o\'qish va murakkab vazifalar sizga mos.',
          confidence: 0.85,
        ),
      );
    }

    return insights;
  }

  List<TwinInsight> _moodInsights(
    List<JournalEntryEntity> journal,
    List<TaskEntity> tasks,
  ) {
    final corr = _patterns.analyzeMoodProductivity(
      journal: journal,
      tasks: tasks,
    );
    if (journal.length < 3) return [];

    return [
      TwinInsight(
        id: 'mood_productivity',
        category: 'mood',
        headline: 'Kayfiyat ↔ samaradorlik',
        body: corr.insight,
        confidence: 0.78,
      ),
    ];
  }

  List<TwinInsight> _habitInsights(
    List<HabitEntity> habits,
    ComputedTwinProfile computed,
  ) {
    if (habits.isEmpty) return [];

    final longest = habits.map((h) {
      return _habitRepo?.calculateStreak(h) ?? 0;
    }).fold(0, (a, b) => a > b ? a : b);

    if (longest >= 7) {
      return [
        TwinInsight(
          id: 'habit_streak',
          category: 'habits',
          headline: 'Odat ustuvorligi',
          body:
              'Siz $longest kunlik streak ko\'rsatdingiz — ketma-ket kichik qadamlar sizning kuchli tomoningiz.',
          confidence: 0.88,
        ),
      ];
    }
    return [];
  }

  List<TwinInsight> _goalInsights(List<GoalEntity> goals) {
    final active = goals.where((g) => g.progress < 100).toList();
    if (active.isEmpty) return [];

    final stalled = active.where((g) => g.progress < 15).toList();
    if (stalled.isNotEmpty) {
      return [
        TwinInsight(
          id: 'goal_stalled',
          category: 'goals',
          headline: 'Maqsad harakatsiz',
          body:
              '"${stalled.first.title}" hali boshlanmagan — avtomatik reja yaratish tavsiya etiladi.',
          confidence: 0.8,
        ),
      ];
    }
    return [];
  }

  List<TwinRecommendation> _recommendations({
    required LifeTwinProfile profile,
    required ComputedTwinProfile computed,
    required String peakHours,
    required String learningStyle,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
  }) {
    final recs = <TwinRecommendation>[];

    if (learningStyle == 'daily_sessions') {
      recs.add(
        const TwinRecommendation(
          id: 'learn_daily',
          title: 'Kunlik o\'qish sessiyasi',
          description:
              'O\'tmish xatti-harakatingizga ko\'ra, kunlik qisqa o\'qish sessiyalari hafta oxiri crammingdan samaraliroq.',
          priority: 85,
          actionRoute: '/hayot/ta\'lim',
          actionLabel: 'Ta\'lim',
          actionType: 'study',
        ),
      );
    } else if (learningStyle == 'weekend_cramming') {
      recs.add(
        const TwinRecommendation(
          id: 'learn_daily_shift',
          title: 'Hafta oxiri o\'rniga kunlik rejim',
          description:
              'Hafta oxiri cramming o\'rniga har kuni 25 daqiqa o\'qish streak yaratish tavsiya etiladi.',
          priority: 82,
          actionRoute: '/boshqa/fokus',
          actionLabel: 'Fokus',
          actionType: 'focus',
        ),
      );
    }

    recs.add(
      TwinRecommendation(
        id: 'peak_schedule',
        title: 'Eng yaxshi vaqtingiz',
        description:
            'Murakkab vazifalarni $peakHours oralig\'iga rejalashtiring.',
        priority: 80,
        actionRoute: '/reja',
        actionLabel: 'Reja',
        actionType: 'execute_plan',
      ),
    );

    if (profile.burnout != null) {
      recs.add(
        TwinRecommendation(
          id: 'recovery',
          title: 'Tiklanish rejimi',
          description: profile.burnout!.message,
          priority: 95,
          actionRoute: '/favqulodda',
          actionLabel: 'Favqulodda',
          actionType: 'recovery',
        ),
      );
    }

    for (final goal in goals.where((g) => g.progress < 30).take(1)) {
      recs.add(
        TwinRecommendation(
          id: 'execute_goal_${goal.id}',
          title: 'Maqsadni bajarish',
          description:
              '"${goal.title}" uchun avtomatik reja va vazifalar yarating.',
          priority: 78,
          actionRoute: '/hayot/maqsadlar',
          actionLabel: 'Maqsadlar',
          actionType: 'goal',
        ),
      );
    }

    final overdue = tasks.where((t) {
      if (t.isCompleted || t.dueDate == null) return false;
      return t.dueDate!.isBefore(DateTime.now());
    }).length;
    if (overdue >= 2) {
      recs.add(
        TwinRecommendation(
          id: 'rebuild_schedule',
          title: 'Jadvalni qayta qurish',
          description:
              '$overdue ta kechikkan vazifa — AI jadvalni avtomatik moslashtiradi.',
          priority: 88,
          actionRoute: '/boshqa/action-engine',
          actionLabel: 'Action Engine',
          actionType: 'execute_plan',
        ),
      );
    }

    if (habits.any((h) {
      final streak = _habitRepo?.calculateStreak(h) ?? 0;
      return streak > 0 && streak < 3;
    })) {
      recs.add(
        const TwinRecommendation(
          id: 'habit_recovery',
          title: 'Odat tiklanishi',
          description:
              'Odat streak zaif — bugun faqat bitta odatni bajaring, streak saqlansin.',
          priority: 75,
          actionRoute: '/hayot/odatlar',
          actionLabel: 'Odatlar',
          actionType: 'habit',
        ),
      );
    }

    return recs;
  }
}
