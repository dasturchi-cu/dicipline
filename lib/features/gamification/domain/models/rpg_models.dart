/// RPG stat turlari.
abstract final class StatType {
  static const discipline = 'discipline';
  static const health = 'health';
  static const knowledge = 'knowledge';
  static const wealth = 'wealth';
  static const social = 'social';
  static const spiritual = 'spiritual';

  static const all = [
    discipline,
    health,
    knowledge,
    wealth,
    social,
    spiritual,
  ];

  static String label(String type) => switch (type) {
        discipline => 'Intizom',
        health => 'Salomatlik',
        knowledge => 'Bilim',
        wealth => 'Boylik',
        social => 'Ijtimoiy',
        spiritual => 'Ma\'naviy',
        _ => type,
      };

  static String emoji(String type) => switch (type) {
        discipline => '💪',
        health => '❤️',
        knowledge => '🧠',
        wealth => '💰',
        social => '🤝',
        spiritual => '🕊️',
        _ => '⭐',
      };
}

/// XP manbalari.
abstract final class XpSource {
  static const taskComplete = 'task_complete';
  static const habitComplete = 'habit_complete';
  static const workout = 'workout';
  static const journal = 'journal';
  static const quest = 'quest';
  static const goal = 'goal';
  static const study = 'study';
  static const finance = 'finance';
  static const challenge = 'challenge';
  static const focusSession = 'focus_session';
}

/// XP mukofotlari.
abstract final class XpRewards {
  static const taskComplete = 10;
  static const habitComplete = 15;
  static const workout = 20;
  static const journal = 20;
  static const studyPerMinute = 1;
  static const financeLog = 10;
  static const goalMilestone = 50;
  static const challengeComplete = 100;
  static const pomodoroComplete = 25;
}

/// Quest shabloni.
class QuestTemplate {
  const QuestTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.statReward,
    required this.xpReward,
    required this.verificationType,
  });

  final String id;
  final String title;
  final String description;
  final String statReward;
  final int xpReward;
  final String verificationType;
}

/// Kunlik va haftalik quest shablonlari.
abstract final class QuestTemplates {
  static const daily = [
    QuestTemplate(
      id: 'tasks_3',
      title: '3 ta vazifa',
      description: 'Bugun kamida 3 ta vazifa bajaring',
      statReward: StatType.discipline,
      xpReward: 30,
      verificationType: 'auto',
    ),
    QuestTemplate(
      id: 'habits_all',
      title: 'Barcha odatlar',
      description: 'Bugungi barcha odatlaringizni bajaring',
      statReward: StatType.discipline,
      xpReward: 40,
      verificationType: 'auto',
    ),
    QuestTemplate(
      id: 'journal',
      title: 'Kundalik yozish',
      description: 'Bugun kundalik yozing',
      statReward: StatType.spiritual,
      xpReward: 20,
      verificationType: 'auto',
    ),
  ];

  static const weekly = [
    QuestTemplate(
      id: 'workouts_5',
      title: '5 ta mashq',
      description: 'Bu hafta kamida 5 marta mashq qiling',
      statReward: StatType.health,
      xpReward: 150,
      verificationType: 'auto',
    ),
    QuestTemplate(
      id: 'study_120',
      title: '2 soat o\'qish',
      description: 'Bu hafta kamida 120 daqiqa o\'qing',
      statReward: StatType.knowledge,
      xpReward: 100,
      verificationType: 'auto',
    ),
    QuestTemplate(
      id: 'journal_5',
      title: '5 kun kundalik',
      description: 'Bu hafta 5 kun kundalik yozing',
      statReward: StatType.spiritual,
      xpReward: 100,
      verificationType: 'auto',
    ),
  ];
}
