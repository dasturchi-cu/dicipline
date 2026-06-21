# Action Engine Report

**Date:** 2026-06-21  
**Status:** Production-ready

## Overview

AI Action Engine automatically analyzes the user's state and generates actionable plans: schedule adjustments, plan rebuilds, recovery plans, and intervention strategies.

## Architecture

| Component | Path |
|-----------|------|
| Schema | `lib/core/database/schemas/action_plan_entity.dart` |
| Repository | `lib/core/repositories/action_plan_repository.dart` |
| Service | `lib/features/action_engine/domain/action_engine_service.dart` |
| Reschedule (reused) | `lib/features/ai_planning/domain/auto_reschedule_service.dart` |
| UI | `lib/features/action_engine/presentation/screens/action_engine_screen.dart` |

## Plan types

| Type | Method | Description |
|------|--------|-------------|
| `schedule_adjust` | `adjustSchedule()` | Reschedule missed plan items for today |
| `plan_rebuild` | `rebuildPlan()` | Rebuild today's plan from pending tasks by priority |
| `recovery` | `generateRecoveryPlan()` | Burnout-aware recovery steps |
| `intervention` | `generateIntervention()` | Life score breakdown interventions |

## Workflow

1. User taps **Tahlil ishga tushirish** on Action Engine screen
2. `runFullAnalysis()` generates all 4 plan types
3. Plans saved to `ActionPlanEntity` with status `pending`
4. User can **Qo'llash** on schedule_adjust plans → applies via `AutoRescheduleService`

## Integration

- Uses `LifeTwinProfile` for recovery context
- Uses `LifeScoreBreakdown` for intervention thresholds
- Writes to `PlanEntity` on rebuild

## Provider

- `actionEngineServiceProvider`
- `actionPlansProvider` / `pendingActionPlansProvider`

## Database

- Schema v4: `ActionPlanEntity`
- Included in backup export/import

## Route

`/boshqa/action-engine`

## Bootstrap

Action plans are generated on-demand (not auto on bootstrap) to avoid overwriting user intent.
