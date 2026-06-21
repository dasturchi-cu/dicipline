import '../../../core/database/schemas/inbox_item_entity.dart';
import '../../../core/repositories/goal_repository.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../../core/repositories/inbox_repository.dart';
import '../../../core/repositories/note_repository.dart';
import '../../../core/repositories/task_repository.dart';

/// Inbox elementini boshqa modulga aylantirish.
class InboxTriageService {
  InboxTriageService({
    required TaskRepository taskRepository,
    required HabitRepository habitRepository,
    required GoalRepository goalRepository,
    required NoteRepository noteRepository,
    required InboxRepository inboxRepository,
  })  : _tasks = taskRepository,
        _habits = habitRepository,
        _goals = goalRepository,
        _notes = noteRepository,
        _inbox = inboxRepository;

  final TaskRepository _tasks;
  final HabitRepository _habits;
  final GoalRepository _goals;
  final NoteRepository _notes;
  final InboxRepository _inbox;

  Future<void> acceptToBrain(InboxItemEntity item) async {
    await _notes.create(
      title: item.title,
      content: item.body.isNotEmpty ? item.body : item.title,
      itemType: item.captureType == 'link' ? 'link' : 'note',
      sourceUrl: item.sourceUrl,
      tags: ['inbox', item.captureType],
    );
    await _markProcessed(item);
  }

  Future<void> convertToTask(InboxItemEntity item) async {
    await _tasks.create(
      title: item.title,
      description: item.body.isNotEmpty ? item.body : null,
    );
    await _markProcessed(item);
  }

  Future<void> convertToHabit(InboxItemEntity item) async {
    await _habits.create(name: item.title);
    await _markProcessed(item);
  }

  Future<void> convertToGoal(InboxItemEntity item) async {
    await _goals.create(
      title: item.title,
      description: item.body.isNotEmpty ? item.body : null,
    );
    await _markProcessed(item);
  }

  Future<void> convertToLearning(InboxItemEntity item) async {
    await _notes.create(
      title: item.title,
      content: item.body.isNotEmpty ? item.body : item.title,
      itemType: 'learning',
      sourceUrl: item.sourceUrl,
      tags: ['ta\'lim', 'inbox'],
      category: 'ta\'lim',
    );
    await _markProcessed(item);
  }

  Future<void> dismiss(InboxItemEntity item) async {
    await _inbox.delete(item.id);
  }

  Future<void> _markProcessed(InboxItemEntity item) async {
    item.status = 'processed';
    await _inbox.save(item);
  }
}
