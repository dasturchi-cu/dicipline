import '../../../core/database/schemas/document_entity.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/note_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/utils/date_format.dart';
import 'second_brain_search_service.dart';

/// Ikkinchi miyadan AI javob.
class BrainAnswer {
  const BrainAnswer({
    required this.question,
    required this.answer,
    required this.sources,
    required this.confidence,
  });

  final String question;
  final String answer;
  final List<BrainSearchResult> sources;
  final double confidence;
}

/// Shaxsiy bilim bazasidan savol-javob (qoidaviy + qidiruv).
class SecondBrainQaService {
  SecondBrainQaService({SecondBrainSearchService? search})
      : _search = search ?? SecondBrainSearchService();

  final SecondBrainSearchService _search;

  BrainAnswer ask({
    required String question,
    required List<NoteEntity> notes,
    required List<DocumentEntity> documents,
    required List<TaskEntity> tasks,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
  }) {
    final q = question.trim();
    final lower = q.toLowerCase();

    // Maqsadlar
    if (_matches(lower, ['maqsad', 'goal', 'ielts', 'target'])) {
      return _goalAnswer(q, goals, lower);
    }

    // Kundalik / kayfiyat
    if (_matches(lower, ['kundalik', 'journal', 'kayfiyat', 'mood', 'yozgan'])) {
      return _journalAnswer(q, journal, lower);
    }

    // Vazifalar
    if (_matches(lower, ['vazifa', 'task', 'bajarilgan'])) {
      return _taskAnswer(q, tasks);
    }

    // Umumiy qidiruv
    final results = _search.search(
      query: q,
      notes: notes,
      documents: documents,
      tasks: tasks,
    );

    if (results.isEmpty) {
      return BrainAnswer(
        question: q,
        answer: 'Bu mavzuda ma\'lumot topilmadi. Capture orqali saqlang yoki kundalik yozing.',
        sources: const [],
        confidence: 0.2,
      );
    }

    final top = results.take(3).toList();
    final summary = top.map((r) => '• ${r.title}: ${r.subtitle}').join('\n');
    return BrainAnswer(
      question: q,
      answer: 'Topildi:\n$summary',
      sources: top,
      confidence: 0.75,
    );
  }

  BrainAnswer _goalAnswer(String q, List<GoalEntity> goals, String lower) {
    if (goals.isEmpty) {
      return BrainAnswer(
        question: q,
        answer: 'Hali maqsadlar qo\'yilmagan. Hayot → Maqsadlar bo\'limidan qo\'shing.',
        sources: const [],
        confidence: 0.9,
      );
    }

    final filtered = lower.contains('ielts')
        ? goals.where((g) => g.title.toLowerCase().contains('ielts')).toList()
        : goals;

    if (filtered.isEmpty) {
      final list = goals
          .map((g) => '• ${g.title}: ${g.progress.round()}%')
          .join('\n');
      return BrainAnswer(
        question: q,
        answer: 'Maqsadlaringiz:\n$list',
        sources: const [],
        confidence: 0.85,
      );
    }

    final now = DateTime.now();
    final lastMonth = goals.where((g) {
      return g.createdAt.isAfter(now.subtract(const Duration(days: 30)));
    });

    if (lower.contains('o\'tgan oy') || lower.contains('last month')) {
      if (lastMonth.isEmpty) {
        return BrainAnswer(
          question: q,
          answer: 'O\'tgan oy yangi maqsad qo\'yilmagan.',
          sources: const [],
          confidence: 0.8,
        );
      }
      final list = lastMonth.map((g) => '• ${g.title}').join('\n');
      return BrainAnswer(
        question: q,
        answer: 'O\'tgan oy qo\'yilgan maqsadlar:\n$list',
        sources: const [],
        confidence: 0.9,
      );
    }

    final target = filtered.first;
    return BrainAnswer(
      question: q,
      answer:
          '"${target.title}" — ${target.progress.round()}% bajarildi.${target.targetDate != null ? ' Muddat: ${AppDateFormat.formatDate(target.targetDate!)}.' : ''}',
      sources: const [],
      confidence: 0.92,
    );
  }

  BrainAnswer _journalAnswer(
    String q,
    List<JournalEntryEntity> journal,
    String lower,
  ) {
    if (journal.isEmpty) {
      return BrainAnswer(
        question: q,
        answer: 'Kundalik yozuvlar yo\'q. Bugun birinchi yozuvni qoldiring.',
        sources: const [],
        confidence: 0.9,
      );
    }

    final keyword = _extractKeyword(lower, ['ielts', 'ingliz', 'ish', 'sog\'liq']);
    final matching = keyword != null
        ? journal
            .where((j) => j.content.toLowerCase().contains(keyword))
            .toList()
        : journal.where((j) => j.content.trim().isNotEmpty).toList();

    if (matching.isEmpty) {
      return BrainAnswer(
        question: q,
        answer: keyword != null
            ? '"$keyword" haqida kundalik yozuv topilmadi.'
            : '${journal.length} ta kundalik yozuv bor.',
        sources: const [],
        confidence: 0.7,
      );
    }

    final recent = matching.take(3).map((j) {
      final preview = j.content.length > 80
          ? '${j.content.substring(0, 80)}...'
          : j.content;
      return '• ${AppDateFormat.formatDate(j.date)}: $preview';
    }).join('\n');

    return BrainAnswer(
      question: q,
      answer: 'Kundalikdan:\n$recent',
      sources: const [],
      confidence: 0.88,
    );
  }

  BrainAnswer _taskAnswer(String q, List<TaskEntity> tasks) {
    final done = tasks.where((t) => t.isCompleted).length;
    final pending = tasks.where((t) => !t.isCompleted).length;
    return BrainAnswer(
      question: q,
      answer: 'Jami $done ta vazifa bajarildi, $pending ta kutilmoqda.',
      sources: const [],
      confidence: 0.95,
    );
  }

  bool _matches(String lower, List<String> keywords) =>
      keywords.any((k) => lower.contains(k));

  String? _extractKeyword(String lower, List<String> candidates) {
    for (final c in candidates) {
      if (lower.contains(c)) return c;
    }
    return null;
  }
}
