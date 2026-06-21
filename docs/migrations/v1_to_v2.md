# Migration v1 → v2

**Version:** 2  
**Date:** 2026-06-21  
**Service:** `DatabaseMigrationService`

## Changes

### New Isar Collections
- `PlayerProfileEntity` — RPG player profile (singleton)
- `XpEventEntity` — XP audit trail
- `AchievementUnlockEntity` — Persisted achievement unlocks
- `QuestEntity` — Daily and weekly quests
- `AppMeta` — Schema version tracking (wired into Isar)

### Extended Collections
- `TaskEntity` — Added `recurrenceType`, `recurrenceTemplateId`, `nextRecurrenceDate`, `recurrenceDays`
- `HabitEntity` — Added `frequencyType`, `targetPerWeek`, `activeDays`

### Migration Steps (v1 → v2)
1. Register new schemas in `IsarService`
2. Initialize `PlayerProfileEntity` for existing users
3. Mark schema version as `2` in `AppMeta`

## Running Migrations

Migrations run automatically on app start via `IsarService.open()` → `DatabaseMigrationService.migrate()`.

## Rollback

Isar does not support schema rollback. Backup JSON before major updates via Settings → Export.
