import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/schemas/time_log_entity.dart';
import '../../../core/repositories/study_repository.dart';
import '../../../core/repositories/time_log_repository.dart';
import '../../../core/repositories/workout_repository.dart';

enum TimerState { idle, running, paused }

class ActiveTimerSession {
  const ActiveTimerSession({
    required this.sessionType,
    required this.label,
    required this.state,
    required this.elapsedSeconds,
    required this.startedAt,
  });

  final String sessionType;
  final String label;
  final TimerState state;
  final int elapsedSeconds;
  final DateTime? startedAt;

  static const idle = ActiveTimerSession(
    sessionType: 'focus',
    label: '',
    state: TimerState.idle,
    elapsedSeconds: 0,
    startedAt: null,
  );

  ActiveTimerSession copyWith({
    String? sessionType,
    String? label,
    TimerState? state,
    int? elapsedSeconds,
    DateTime? startedAt,
  }) {
    return ActiveTimerSession(
      sessionType: sessionType ?? this.sessionType,
      label: label ?? this.label,
      state: state ?? this.state,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}

class TimeTrackerNotifier extends StateNotifier<ActiveTimerSession> {
  TimeTrackerNotifier({
    required TimeLogRepository timeLogRepository,
    required WorkoutRepository workoutRepository,
    required StudyRepository studyRepository,
  })  : _timeLogs = timeLogRepository,
        _workouts = workoutRepository,
        _study = studyRepository,
        super(ActiveTimerSession.idle);

  final TimeLogRepository _timeLogs;
  final WorkoutRepository _workouts;
  final StudyRepository _study;

  Timer? _ticker;
  DateTime? _segmentStart;
  int _baseSeconds = 0;

  void selectType(String sessionType, {String? label}) {
    if (state.state != TimerState.idle) return;
    state = state.copyWith(
      sessionType: sessionType,
      label: label ?? _defaultLabel(sessionType),
    );
  }

  void start() {
    if (state.state == TimerState.running) return;
    _segmentStart = DateTime.now();
    if (state.state == TimerState.idle) {
      _baseSeconds = 0;
    }
    state = state.copyWith(
      state: TimerState.running,
      startedAt: state.startedAt ?? DateTime.now(),
    );
    _startTicker();
  }

  void pause() {
    if (state.state != TimerState.running) return;
    _accumulate();
    _ticker?.cancel();
    state = state.copyWith(state: TimerState.paused);
  }

  Future<int> stop() async {
    if (state.state == TimerState.idle) return 0;
    if (state.state == TimerState.running) {
      _accumulate();
    }
    _ticker?.cancel();

    final total = state.elapsedSeconds;
    final sessionType = state.sessionType;
    final label = state.label;
    final startedAt = state.startedAt;

    if (total >= 30) {
      final ended = DateTime.now();
      final started =
          startedAt ?? ended.subtract(Duration(seconds: total));
      await _timeLogs.create(
        TimeLogEntity.create(
          sessionType: sessionType,
          durationSeconds: total,
          startedAt: started,
          endedAt: ended,
          label: label,
        ),
      );
      await _syncLegacyModules(
        sessionType: sessionType,
        label: label,
        seconds: total,
        started: started,
      );
    }

    state = ActiveTimerSession.idle;
    _baseSeconds = 0;
    _segmentStart = null;
    return total;
  }

  Future<void> _syncLegacyModules({
    required String sessionType,
    required String label,
    required int seconds,
    required DateTime started,
  }) async {
    final minutes = (seconds / 60).ceil().clamp(1, 9999);
    switch (sessionType) {
      case 'workout':
        await _workouts.create(
          exerciseName: label.isNotEmpty ? label : 'Mashq',
          durationMinutes: minutes,
          date: started,
        );
      case 'study':
      case 'programming':
      case 'reading':
        final subjects = await _study.getAllSubjects();
        final name = sessionType == 'programming'
            ? 'Dasturlash'
            : sessionType == 'reading'
                ? 'O\'qish'
                : 'Ta\'lim';
        final existing = subjects.where((s) => s.name == name);
        final subjectId = existing.isEmpty
            ? (await _study.createSubject(name: name)).id
            : existing.first.id;
        await _study.createSession(
          subjectId: subjectId,
          durationMinutes: minutes,
          date: started,
        );
      default:
        break;
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.state != TimerState.running || _segmentStart == null) return;
      final delta = DateTime.now().difference(_segmentStart!).inSeconds;
      state = state.copyWith(elapsedSeconds: _baseSeconds + delta);
    });
  }

  void _accumulate() {
    if (_segmentStart == null) return;
    _baseSeconds +=
        DateTime.now().difference(_segmentStart!).inSeconds.clamp(0, 86400);
    _segmentStart = null;
    state = state.copyWith(elapsedSeconds: _baseSeconds);
  }

  static String _defaultLabel(String type) => switch (type) {
        'study' => 'Ta\'lim',
        'programming' => 'Dasturlash',
        'workout' => 'Mashq',
        'focus' => 'Fokus',
        'reading' => 'O\'qish',
        _ => 'Sessiya',
      };

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
