# Future Simulator Report

**Date:** 2026-06-21  
**Status:** Production-ready

## Overview

Future Simulator provides what-if scenario modeling, predictive analytics, and time-capsule letters to future self.

## Architecture

| Component | Path |
|-----------|------|
| Scenario engine | `lib/features/future_simulator/domain/future_simulator_service.dart` |
| Prediction engine | `lib/features/future_simulator/domain/future_prediction_engine.dart` |
| Letters | `lib/features/future_simulator/domain/future_letter_service.dart` |
| Schema | `lib/core/database/schemas/future_letter_entity.dart` |
| UI | `lib/features/future_simulator/presentation/screens/future_simulator_screen.dart` |

## Tabs

1. **Simulyatsiya** — maintain / boost / slump scenarios (life score projection)
2. **Bashoratlar** — predictive analytics (new)
3. **Xatlar** — time-capsule letters (1m–5y)

## Predictions (FuturePredictionEngine)

### Goal completion dates
- Estimates weeks to 100% based on weekly task completion rate
- Flags goals likely to miss `targetDate`
- Confidence score based on recent activity

### Streak break risks
- Per-habit risk score (high / medium / low)
- Factors: not done today, long streak at risk, gap patterns

### Productivity trends
- Compares this week vs last week task completions
- Direction: up | down | stable

### Mood trends
- 7-day journal average vs historical
- Direction and projected mood value

## Data sources

All predictions use real local data: `TaskEntity`, `HabitEntity`, `GoalEntity`, `JournalEntryEntity`. No mock data.

## Provider

`futurePredictionsProvider` in `phase2_providers.dart`

## Tests

- `test/features/future_prediction_engine_test.dart`

## Route

`/hayot/simulyator`
