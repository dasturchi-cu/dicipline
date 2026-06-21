# REJABON AI — Step-by-Step Execution Plan

**Version:** 1.0 (Phase 1 Implementation)  
**Date:** 2026-06-21  
**Status:** Active — P0 in progress  
**Master roadmap:** `IMPLEMENTATION_PLAN.md`

---

## Phase 1 Objective

Wire the Life Loop so the app feels like one product. Resolve all **P0 audit items** before V2 features.

**Exit criteria:** Coach shows evidence on dashboard; mood visible in analytics; AI memory populates; API keys not in release APK; tests green; finance discoverable.

**Status (2026-06-21):** Phase 1 P0 + V1.6 retention sprint complete. `flutter test` — 57/57 passing. `flutter analyze lib` — 0 errors.

---

## Step-by-Step (P0 Order)

### Step 1 — Security: API keys (P0-01) ✅
1. Skip `assets/ai.env` in `kReleaseMode` in `AiConfig.loadEnvMap`
2. Release builds use `--dart-define` or local `.env` only
3. Document in `assets/ai.env.example`

### Step 2 — RPG backup (P0-02) ✅ (prior sprint)
- `backup_service.dart` includes playerProfiles, quests, xpEvents, achievementUnlocks

### Step 3 — Expand CoachContext (P0-03, M10) ✅
1. Add `TodaySnapshot`, `RpgSnapshot`, `GoalDriftSignal` to `coach_context.dart`
2. Extend `LifeContextAssembler.assemble()` with goals, habits, inbox, RPG
3. Update `coachContextProvider` to pass all slices
4. Add goal-drift insight in `LifeBrainFacade` (priority 75)

### Step 4 — AI Memory wiring (P0-04) ✅
1. `ai_memory_sync.dart` — throttled sync (24h) + on-demand
2. Call from `runPhase2Bootstrap` (app start) + CEO review refresh
3. Invalidate `aiMemoriesProvider` after store

### Step 5 — Mood analytics (P0-05) ✅
1. Add `InsightCategory.mood` + journal param to `AnalyticsInsightService`
2. Mood insights from `MoodTrendService`
3. `actionRoute` on insights; analytics screen CTA buttons
4. Shared `InsightCard` widget

### Step 6 — Dashboard slim (M11) ✅
1. `dashboard_today_strip.dart` — tasks + habits + inbox badge
2. Remove `DashboardMvpQuickActions`, duplicate task cards
3. Header shows life score ring

### Step 7 — Finance in Life hub (M13) ✅
1. Add finance `HubModuleCard` to `LifeHubScreen`
2. Route `/hayot/moliya`; redirect `/moliya`

### Step 8 — Tests & CI (M9) ✅
1. Fix/extend `life_brain_facade_test` for goal drift
2. Add `life_context_assembler_test`
3. `flutter test` green

---

## After P0 (MVP remainder — Sprint MVP-3/4)

| Step | Task | Doc |
|------|------|-----|
| 9 | Delete 11 dead dashboard widgets | UI_UX_REDESIGN |
| 10 | Stream-derived providers | IMPLEMENTATION_PLAN |
| 11 | More hub curate (8 items) | UI_UX_REDESIGN | ✅ |
| 12 | Focus stat Isar migration v3 | LIFE_RPG_SYSTEM |
| 13 | Integration test: life loop | IMPLEMENTATION_PLAN |

---

## V1.6 Retention Sprint (2026-06-21) ✅

| Item | Files |
|------|-------|
| Morning briefing push | `retention_notification_helper.dart` |
| Emotion push | `retention_notification_helper.dart` |
| Analytics Hub 5-tab | `analytics_hub_screen.dart` |
| Focus + Pomodoro + XP | `focus_mode_screen.dart`, `pomodoro_notifier.dart` |
| Letter unlock ceremony | `letter_unlock_screen.dart` |
| Coach intervention banner | `coach_intervention_banner.dart` |
| Level-up overlay | `level_up_overlay.dart` |
| More hub 8 modules | `more_hub_screen.dart` |

See `MASTER_IMPLEMENTATION_PLAN.md` for full gate checklist.

---

See `IMPLEMENTATION_PLAN.md` sections 6–8 for full sprint calendars.

---

*Execute Step 1 first. Do not start V2 until P0 checklist complete.*
