import '../../../core/constants/life_areas.dart';
import '../../../core/database/schemas/document_entity.dart';
import '../../../core/database/schemas/note_entity.dart';
import '../../../core/database/schemas/task_entity.dart';

/// Qidiruv natijasi — ikkinchi miya.
class BrainSearchResult {
  const BrainSearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.emoji,
    required this.route,
    this.isFavorite = false,
  });

  final int id;
  final String title;
  final String subtitle;
  final String type;
  final String emoji;
  final String route;
  final bool isFavorite;
}

/// Global qidiruv — eslatmalar, hujjatlar, vazifalar.
class SecondBrainSearchService {
  List<BrainSearchResult> search({
    required String query,
    required List<NoteEntity> notes,
    required List<DocumentEntity> documents,
    required List<TaskEntity> tasks,
    String? categoryFilter,
    bool favoritesOnly = false,
  }) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty && !favoritesOnly) return [];

    final results = <BrainSearchResult>[];

    for (final note in notes) {
      if (favoritesOnly && !note.isFavorite) continue;
      if (categoryFilter != null &&
          categoryFilter.isNotEmpty &&
          note.category != categoryFilter) {
        continue;
      }
      final match = q.isEmpty ||
          note.title.toLowerCase().contains(q) ||
          note.content.toLowerCase().contains(q) ||
          note.tags.any((t) => t.toLowerCase().contains(q));
      if (!match) continue;

      results.add(
        BrainSearchResult(
          id: note.id,
          title: note.title,
          subtitle: _noteSubtitle(note),
          type: note.itemType,
          emoji: note.emoji.isNotEmpty ? note.emoji : _typeEmoji(note.itemType),
          route: '/boshqa/eslatmalar',
          isFavorite: note.isFavorite,
        ),
      );
    }

    for (final doc in documents) {
      if (favoritesOnly && !doc.isFavorite) continue;
      final match = q.isEmpty ||
          doc.title.toLowerCase().contains(q) ||
          (doc.description?.toLowerCase().contains(q) ?? false);
      if (!match) continue;

      results.add(
        BrainSearchResult(
          id: doc.id,
          title: doc.title,
          subtitle: doc.mediaType,
          type: doc.mediaType,
          emoji: _mediaEmoji(doc.mediaType),
          route: '/boshqa/hujjatlar',
          isFavorite: doc.isFavorite,
        ),
      );
    }

    for (final task in tasks) {
      if (favoritesOnly) continue;
      final match = q.isEmpty ||
          task.title.toLowerCase().contains(q) ||
          (task.description?.toLowerCase().contains(q) ?? false);
      if (!match) continue;

      results.add(
        BrainSearchResult(
          id: task.id,
          title: task.title,
          subtitle: task.isCompleted ? 'Bajarildi' : 'Faol vazifa',
          type: 'task',
          emoji: task.emoji.isNotEmpty ? task.emoji : '📋',
          route: '/vazifalar/${task.id}',
        ),
      );
    }

    results.sort((a, b) {
      if (a.isFavorite != b.isFavorite) {
        return a.isFavorite ? -1 : 1;
      }
      return a.title.compareTo(b.title);
    });

    return results;
  }

  List<String> collectCategories({
    required List<NoteEntity> notes,
    required List<DocumentEntity> documents,
  }) {
    final cats = <String>{};
    for (final n in notes) {
      if (n.category.isNotEmpty) cats.add(n.category);
    }
    for (final d in documents) {
      if (d.type.isNotEmpty) cats.add(d.type);
    }
    return cats.toList()..sort();
  }

  static String _noteSubtitle(NoteEntity note) {
    if (note.sourceUrl != null && note.sourceUrl!.isNotEmpty) {
      return note.sourceUrl!;
    }
    final preview = note.content.trim();
    if (preview.length > 60) return '${preview.substring(0, 60)}...';
    return preview.isEmpty ? note.category : preview;
  }

  static String _typeEmoji(String type) => switch (type) {
        'link' => '🔗',
        'learning' => '📚',
        'audio_ref' => '🎙️',
        _ => '📝',
      };

  static String _mediaEmoji(String media) => switch (media) {
        'pdf' => '📄',
        'image' => '🖼️',
        'audio' => '🎙️',
        'link' => '🔗',
        _ => '📁',
      };
}
