import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PomodoroPhase { focus, breakTime, idle }

class PomodoroState {
  const PomodoroState({
    required this.phase,
    required this.secondsRemaining,
    required this.completedPomodoros,
    required this.isRunning,
  });

  final PomodoroPhase phase;
  final int secondsRemaining;
  final int completedPomodoros;
  final bool isRunning;

  static const idle = PomodoroState(
    phase: PomodoroPhase.idle,
    secondsRemaining: 25 * 60,
    completedPomodoros: 0,
    isRunning: false,
  );

  PomodoroState copyWith({
    PomodoroPhase? phase,
    int? secondsRemaining,
    int? completedPomodoros,
    bool? isRunning,
  }) {
    return PomodoroState(
      phase: phase ?? this.phase,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  PomodoroNotifier() : super(PomodoroState.idle);

  Timer? _timer;
  static const focusSeconds = 25 * 60;
  static const breakSeconds = 5 * 60;

  void startFocus() {
    _timer?.cancel();
    state = state.copyWith(
      phase: PomodoroPhase.focus,
      secondsRemaining: focusSeconds,
      isRunning: true,
    );
    _tick();
  }

  void startBreak() {
    _timer?.cancel();
    state = state.copyWith(
      phase: PomodoroPhase.breakTime,
      secondsRemaining: breakSeconds,
      isRunning: true,
    );
    _tick();
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resume() {
    if (state.phase == PomodoroPhase.idle) return;
    state = state.copyWith(isRunning: true);
    _tick();
  }

  /// Pomodoro tugadi — true qaytaradi agar focus sessiya yakunlangan bo'lsa.
  bool? stop() {
    _timer?.cancel();
    final wasFocusComplete =
        state.phase == PomodoroPhase.focus && state.secondsRemaining <= 0;
    final completed = wasFocusComplete
        ? state.completedPomodoros + 1
        : state.completedPomodoros;
    state = PomodoroState.idle.copyWith(completedPomodoros: completed);
    return wasFocusComplete ? true : null;
  }

  void _tick() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isRunning) return;
      if (state.secondsRemaining <= 1) {
        _onPhaseComplete();
        return;
      }
      state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
    });
  }

  void _onPhaseComplete() {
    _timer?.cancel();
    if (state.phase == PomodoroPhase.focus) {
      state = state.copyWith(
        phase: PomodoroPhase.breakTime,
        secondsRemaining: breakSeconds,
        isRunning: false,
        completedPomodoros: state.completedPomodoros + 1,
      );
    } else {
      state = state.copyWith(
        phase: PomodoroPhase.idle,
        secondsRemaining: focusSeconds,
        isRunning: false,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final pomodoroProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
  return PomodoroNotifier();
});
