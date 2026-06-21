import '../../../core/ai/ai_orchestrator.dart';
import '../../../core/database/schemas/finance_transaction_entity.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/repositories/finance_repository.dart';
import '../../../core/repositories/goal_repository.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../../core/repositories/journal_repository.dart';
import '../../../core/repositories/task_repository.dart';

/// AI murabbiy tavsiyasi.
class AiTip {
  const AiTip({
    required this.title,
    required this.description,
    this.actionRoute,
  });

  final String title;
  final String description;
  final String? actionRoute;

  String get displayText => '$title. $description';
}

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Ma'lumotlar asosida o'zbek tilida shaxsiy tavsiyalar yaratadi.
class AiCoachService {
  AiCoachService({
    required TaskRepository taskRepository,
    required HabitRepository habitRepository,
    required GoalRepository goalRepository,
    required FinanceRepository financeRepository,
    required JournalRepository journalRepository,
    AiService? aiService,
  })  : _tasks = taskRepository,
        _habits = habitRepository,
        _goals = goalRepository,
        _finance = financeRepository,
        _journal = journalRepository,
        _aiService = aiService;

  final TaskRepository _tasks;
  final HabitRepository _habits;
  final GoalRepository _goals;
  final FinanceRepository _finance;
  final JournalRepository _journal;
  final AiService? _aiService;

  Future<List<AiTip>> generateRecommendations() async {
    final tasks = await _tasks.getAll();
    final habits = await _habits.getAll();
    final goals = await _goals.getAll();
    final finance = await _finance.getAll();
    final journalToday = await _journal.getToday();

    final tips = generateFromData(
      tasks: tasks,
      habits: habits,
      goals: goals,
      finance: finance,
      journalToday: journalToday,
      habitRepository: _habits,
    );

    final llmTip = await _generateLlmTip(
      tasks: tasks,
      habits: habits,
      goals: goals,
      finance: finance,
      journalToday: journalToday,
      existingTips: tips,
    );

    if (llmTip != null) {
      return [llmTip, ...tips];
    }

    return tips;
  }

  Future<AiTip?> _generateLlmTip({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<FinanceTransactionEntity> finance,
    required JournalEntryEntity? journalToday,
    required List<AiTip> existingTips,
  }) async {
    final ai = _aiService ?? AiService.instance;
    if (ai == null) return null;

    final overdueCount = tasks.where((task) {
      if (task.isCompleted) return false;
      final due = task.dueDate;
      return due != null &&
          DateTime(due.year, due.month, due.day)
              .isBefore(_normalizeDate(DateTime.now()));
    }).length;

    final incompleteHabits = habits.where((habit) {
      final today = _normalizeDate(DateTime.now());
      return !habit.completedDates.any((date) => _isSameDay(date, today));
    }).length;

    final lowGoals = goals.where((goal) => goal.progress < 30).length;
    final balance = FinanceRepository.balance(finance);
    final journalStatus = journalToday == null || journalToday.content.trim().isEmpty
        ? 'yozilmagan'
        : 'mood: ${journalToday.mood}/5';

    final context = StringBuffer()
      ..writeln('Bugungi holat:')
      ..writeln('- Kechikkan vazifalar: $overdueCount')
      ..writeln('- Bajarilmagan odatlar: $incompleteHabits')
      ..writeln('- Past progress maqsadlar: $lowGoals')
      ..writeln('- Moliya balansi: ${balance.toStringAsFixed(0)} so\'m')
      ..writeln('- Kundalik: $journalStatus');

    if (existingTips.isNotEmpty) {
      context.writeln('Mavjud ogohlantirishlar:');
      for (final tip in existingTips.take(3)) {
        context.writeln('- ${tip.title}: ${tip.description}');
      }
    }

    try {
      final response = await ai.chat(
        systemPrompt:
            'Sen REJABON AI shaxsiy murabbiyisan. Faqat o\'zbek tilida javob ber. '
            'Qisqa, aniq va motivatsion bo\'l. Manipulyatsiya qilma. '
            'Javob formati: BIRINCHI QATOR sarlavha, keyin nuqta va tavsif.',
        prompt: context.toString(),
        maxOutputTokens: 300,
      );

      if (response == null || response.trim().isEmpty) return null;

      final parsed = _parseLlmTip(response.trim());
      return parsed ??
          AiTip(
            title: 'AI murabbiy',
            description: response.trim(),
          );
    } catch (_) {
      return null;
    }
  }

  static AiTip? _parseLlmTip(String response) {
    final dotIndex = response.indexOf('. ');
    if (dotIndex <= 0) return null;

    final title = response.substring(0, dotIndex).trim();
    final description = response.substring(dotIndex + 2).trim();
    if (title.isEmpty || description.isEmpty) return null;

    return AiTip(title: title, description: description);
  }

  static List<AiTip> generateFromData({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<FinanceTransactionEntity> finance,
    JournalEntryEntity? journalToday,
    HabitRepository? habitRepository,
  }) {
    final tips = <AiTip>[
      ..._taskTipsFromData(tasks),
      ..._habitTipsFromData(habits, habitRepository),
      ..._goalTipsFromData(goals),
      ..._financeTipsFromData(finance),
      ..._journalTipsFromData(journalToday),
    ];

    if (tips.isEmpty) {
      tips.add(
        const AiTip(
          title: 'Ajoyib ish!',
          description:
              'Hozircha muhim ogohlantirishlar yo\'q. Yangi maqsadlar qo\'ying yoki kundalik yozing.',
          actionRoute: '/hayot/maqsadlar',
        ),
      );
    }

    return tips;
  }

  static List<String> generateTipStrings({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<FinanceTransactionEntity> finance,
    JournalEntryEntity? journalToday,
    HabitRepository? habitRepository,
  }) {
    return generateFromData(
      tasks: tasks,
      habits: habits,
      goals: goals,
      finance: finance,
      journalToday: journalToday,
      habitRepository: habitRepository,
    ).map((tip) => tip.displayText).toList();
  }

  static List<AiTip> _taskTipsFromData(List<TaskEntity> tasks) {
    final today = _normalizeDate(DateTime.now());
    final overdue = tasks
        .where((task) {
          if (task.isCompleted) return false;
          final due = task.dueDate;
          return due != null && _normalizeDate(due).isBefore(today);
        })
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    if (overdue.isEmpty) return [];

    final tips = <AiTip>[];
    for (final task in overdue.take(3)) {
      tips.add(
        AiTip(
          title: 'Muddat o\'tgan vazifa',
          description:
              '"${task.title}" vazifasi kechikdi. Bugun bajarishga harakat qiling.',
          actionRoute: '/vazifalar/${task.id}',
        ),
      );
    }

    if (overdue.length > 3) {
      tips.add(
        AiTip(
          title: 'Ko\'p kechikkan vazifalar',
          description:
              'Yana ${overdue.length - 3} ta vazifa muddati o\'tgan. Vazifalar ro\'yxatini ko\'rib chiqing.',
          actionRoute: '/vazifalar',
        ),
      );
    }

    return tips;
  }

  static List<AiTip> _habitTipsFromData(
    List<HabitEntity> habits,
    HabitRepository? habitRepository,
  ) {
    final today = _normalizeDate(DateTime.now());
    final incomplete = habits.where((habit) {
      return !habit.completedDates.any((date) => _isSameDay(date, today));
    }).toList();

    if (incomplete.isEmpty) return [];

    final tips = <AiTip>[];
    for (final habit in incomplete.take(3)) {
      final streak = habitRepository?.calculateStreak(habit) ??
          habitStreakFromDates(habit);
      final streakText = streak > 0
          ? ' Ketma-ketlik: $streak kun — bugun ham davom eting!'
          : ' Bugun boshlang va yaxshi odat shakllantiring.';
      tips.add(
        AiTip(
          title: 'Odat bajarilmagan',
          description: '"${habit.name}" bugun belgilanmagan.$streakText',
          actionRoute: '/hayot/odatlar',
        ),
      );
    }

    if (incomplete.length > 3) {
      tips.add(
        AiTip(
          title: 'Bugungi odatlar',
          description:
              '${incomplete.length} ta odat hali bajarilmagan. Kichik qadam — katta natija.',
          actionRoute: '/hayot/odatlar',
        ),
      );
    }

    return tips;
  }

  static int habitStreakFromDates(HabitEntity habit) {
    final dates = habit.completedDates.map(_normalizeDate).toSet();
    if (dates.isEmpty) return 0;

    var current = _normalizeDate(DateTime.now());
    if (!dates.contains(current)) {
      current = current.subtract(const Duration(days: 1));
    }

    var streak = 0;
    while (dates.contains(current)) {
      streak++;
      current = current.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static List<AiTip> _goalTipsFromData(List<GoalEntity> goals) {
    final lowProgress =
        goals.where((goal) => goal.progress < 30).toList();
    if (lowProgress.isEmpty) return [];

    final tips = <AiTip>[];
    for (final goal in lowProgress.take(2)) {
      final progress = goal.progress.toStringAsFixed(0);
      tips.add(
        AiTip(
          title: 'Maqsad sekin rivojlanmoqda',
          description:
              '"${goal.title}" faqat $progress% bajarilgan. Kichik bosqich qo\'shing yoki progressni yangilang.',
          actionRoute: '/hayot/maqsadlar',
        ),
      );
    }

    final now = DateTime.now();
    for (final goal in lowProgress) {
      final target = goal.targetDate;
      if (target != null && target.difference(now).inDays <= 14) {
        tips.add(
          AiTip(
            title: 'Maqsad muddati yaqinlashmoqda',
            description:
                '"${goal.title}" uchun ${target.difference(now).inDays} kun qoldi. Rejani tezlashtiring.',
            actionRoute: '/hayot/maqsadlar',
          ),
        );
        break;
      }
    }

    return tips;
  }

  static List<AiTip> _financeTipsFromData(
    List<FinanceTransactionEntity> finance,
  ) {
    final totalIncome = FinanceRepository.totalIncome(finance);
    final totalExpense = FinanceRepository.totalExpense(finance);
    final balance = FinanceRepository.balance(finance);
    final tips = <AiTip>[];

    if (balance < 0) {
      tips.add(
        AiTip(
          title: 'Salbiy balans',
          description:
              'Balansingiz ${balance.toStringAsFixed(0)} so\'m. Xarajatlarni ko\'rib chiqing va byudjet tuzing.',
          actionRoute: '/moliya',
        ),
      );
    }

    final expenseByCategory = <String, double>{};
    for (final tx in finance.where((t) => t.type == FinanceRepository.typeExpense)) {
      expenseByCategory[tx.category] =
          (expenseByCategory[tx.category] ?? 0) + tx.amount;
    }

    if (expenseByCategory.isNotEmpty && totalIncome > 0) {
      final topEntry = expenseByCategory.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      if (topEntry.value > totalIncome * 0.4) {
        tips.add(
          AiTip(
            title: 'Yuqori xarajat kategoriyasi',
            description:
                '"${topEntry.key}" kategoriyasida ${topEntry.value.toStringAsFixed(0)} so\'m sarflangan. Cheklov qo\'yishni o\'ylab ko\'ring.',
            actionRoute: '/moliya',
          ),
        );
      }
    }

    if (totalExpense == 0 && totalIncome == 0) {
      tips.add(
        const AiTip(
          title: 'Moliyani kuzatishni boshlang',
          description:
              'Daromad va xarajatlaringizni qayd eting — moliyaviy holatingizni yaxshiroq tushunasiz.',
          actionRoute: '/moliya',
        ),
      );
    }

    return tips;
  }

  static List<AiTip> _journalTipsFromData(JournalEntryEntity? today) {
    final tips = <AiTip>[];

    if (today == null || today.content.trim().isEmpty) {
      tips.add(
        const AiTip(
          title: 'Kundalik yozilmagan',
          description:
              'Bugungi kayfiyatingiz va fikrlaringizni yozing — bu sizga o\'zingizni yaxshiroq tushunishga yordam beradi.',
          actionRoute: '/hayot/kundalik',
        ),
      );
    } else if (today.mood <= 2) {
      tips.add(
        const AiTip(
          title: 'Kayfiyat past',
          description:
              'Bugun kayfiyatingiz past ko\'rinadi. Dam oling, sevimli mashg\'ulotingiz bilan shug\'ullaning yoki yaqinlaringiz bilan gaplashing.',
          actionRoute: '/hayot/kundalik',
        ),
      );
    }

    return tips;
  }
}
