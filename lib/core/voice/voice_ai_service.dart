import 'package:rejabon_ai/core/ai/ai_orchestrator.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/plan_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/repositories/habit_repository.dart';
import 'package:rejabon_ai/core/repositories/plan_repository.dart';
import 'package:rejabon_ai/core/repositories/task_repository.dart';
import 'package:rejabon_ai/core/voice/speech_capture_service.dart';
import 'package:rejabon_ai/core/voice/voice_command_parser.dart';
import 'package:rejabon_ai/core/voice/text_to_speech_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';

/// Ovozli AI — STT, buyruqlar va Life Twin chat.
class VoiceAiService {
  VoiceAiService({
    required SpeechCaptureService speech,
    required LifeTwinService twinService,
    required TaskRepository taskRepo,
    required HabitRepository habitRepo,
    required PlanRepository planRepo,
    AiService? aiService,
    VoiceCommandParser? parser,
    TextToSpeechService? tts,
  })  : _speech = speech,
        _twin = twinService,
        _tasks = taskRepo,
        _habits = habitRepo,
        _plans = planRepo,
        _ai = aiService,
        _parser = parser ?? const VoiceCommandParser(),
        _tts = tts ?? TextToSpeechService();

  final SpeechCaptureService _speech;
  final LifeTwinService _twin;
  final TaskRepository _tasks;
  final HabitRepository _habits;
  final PlanRepository _plans;
  final AiService? _ai;
  final VoiceCommandParser _parser;
  final TextToSpeechService _tts;

  bool get isListening => _speech.isListening;

  Future<bool> initialize() => _speech.initialize();

  Future<void> startVoiceInput({
    required void Function(String partial) onPartial,
    required void Function(String finalText) onResult,
  }) {
    return _speech.startListening(
      onPartial: onPartial,
      onFinal: onResult,
    );
  }

  Future<void> stopVoiceInput() => _speech.stopListening();

  Future<VoiceCommandResult> processVoiceInput({
    required String transcript,
    required LifeTwinProfile profile,
  }) async {
    if (transcript.trim().isEmpty) {
      return const VoiceCommandResult(
        type: 'error',
        message: 'Hech narsa eshitilmadi. Qayta urinib ko\'ring.',
      );
    }

    final command = _parser.parse(transcript);

    switch (command.type) {
      case 'create_task':
        await _createTask(command.createdTitle!);
        final reply = await _twin.chat(
          userMessage: transcript,
          profile: profile,
          inputType: 'voice',
        );
        await _tts.speak('Vazifa yaratildi. $reply');
        return command.copyWith(message: reply);
      case 'create_habit':
        await _createHabit(command.createdTitle!);
        final reply = await _twin.chat(
          userMessage: transcript,
          profile: profile,
          inputType: 'voice',
        );
        await _tts.speak('Odat qo\'shildi. $reply');
        return command.copyWith(message: reply);
      case 'create_plan':
        await _createPlan(command.createdTitle ?? 'Bugungi reja');
        final reply = await _twin.chat(
          userMessage: transcript,
          profile: profile,
          inputType: 'voice',
        );
        await _tts.speak('Reja yaratildi.');
        return command.copyWith(message: reply);
      case 'help':
        await _tts.speak(command.message);
        return command;
      default:
        final reply = await _twin.chat(
          userMessage: transcript,
          profile: profile,
          inputType: 'voice',
        );
        await _tts.speak(reply);
        return VoiceCommandResult(type: 'chat', message: reply);
    }
  }

  Future<void> _createTask(String title) async {
    await _tasks.save(
      TaskEntity.create(title: title, priority: 1),
    );
  }

  Future<void> _createHabit(String name) async {
    await _habits.save(
      HabitEntity.create(name: name),
    );
  }

  Future<void> _createPlan(String sourceText) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var plan = await _plans.getForDate(today);
    plan ??= PlanEntity.create(planDate: today);

    final lines = sourceText
        .split(RegExp(r'[,;]| va '))
        .map((l) => l.trim())
        .where((l) => l.length > 2)
        .toList();

    var cursor = DateTime(today.year, today.month, today.day, 9);
    for (final line in lines.take(6)) {
      plan.items.add(
        PlanItemEmbedded.create(
          title: line,
          startTime: cursor,
          durationMinutes: 30,
        ),
      );
      cursor = cursor.add(const Duration(minutes: 45));
    }

    if (plan.items.isEmpty) {
      plan.items.add(
        PlanItemEmbedded.create(
          title: sourceText,
          startTime: cursor,
          durationMinutes: 30,
        ),
      );
    }

    plan.sourceText = sourceText;
    plan.updatedAt = DateTime.now();
    await _plans.save(plan);
  }

  @Deprecated('Use processVoiceInput instead')
  Future<String> processVoiceQuery({
    required String transcript,
    required LifeTwinProfile profile,
  }) async {
    final result = await processVoiceInput(
      transcript: transcript,
      profile: profile,
    );
    return result.message;
  }
}
