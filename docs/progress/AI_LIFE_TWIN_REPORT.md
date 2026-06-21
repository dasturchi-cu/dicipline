# AI Life Twin Report

**Date:** 2026-06-21  
**Status:** Production-ready

## Overview

AI Life Twin builds a persistent digital profile of the user by learning habits, goals, productivity patterns, and mood trends. It powers chat, decision assistance, and voice AI across the app.

## Architecture

| Layer | Component | Path |
|-------|-----------|------|
| Schema | `TwinProfileEntity` | `lib/core/database/schemas/twin_profile_entity.dart` |
| Repository | `TwinProfileRepository` | `lib/core/repositories/twin_profile_repository.dart` |
| Profile engine | `TwinProfileEngine` | `lib/features/life_twin/domain/twin_profile_engine.dart` |
| Digital twin | `DigitalTwinEngine` | `lib/features/life_twin/domain/digital_twin_engine.dart` |
| Patterns | `CoachPatternEngine` | `lib/features/life_twin/domain/coach_pattern_engine.dart` |
| Service | `LifeTwinService` | `lib/features/life_twin/domain/life_twin_service.dart` |
| Long-term memory | `AiMemoryService` | `lib/features/ai_memory/domain/ai_memory_service.dart` |
| UI | `LifeTwinScreen` | `/boshqa/life-twin` |

## Capabilities

### Personality profile
- **Chronotype:** morning_person | night_owl | balanced (from task completion hours)
- **Productivity style:** steady | burst | inconsistent
- **Goal orientation:** optimistic | realistic | cautious
- **Habit consistency:** high | medium | low
- **Mood trend:** stable | volatile | improving | declining

### Learning systems
- Top 3 habits by streak
- Active goals (progress < 100%)
- Top task categories
- Mood ↔ productivity correlation
- Day-of-week performance
- Burnout detection

### Long-term memory
`DigitalTwinEngine.syncProfile()` writes personality, habit, goal, productivity, and mood insights into `AiMemoryEntity` on each bootstrap.

### LLM twin message
When AI is configured (BYOK), generates a personalized 2–3 sentence twin message using profile + patterns + memory.

## Bootstrap

`runPhase2Bootstrap()` calls `LifeTwinService.buildProfile()` which runs `DigitalTwinEngine.syncProfile()`.

## Database

- Schema version: **4**
- Collection: `TwinProfileEntity` (persisted profile snapshots)

## Tests

- `test/features/twin_profile_engine_test.dart` — chronotype, goals, mood trend

## Routes & navigation

- More hub → **AI Life Twin**
- Voice coach mic shortcut from Life Twin screen
