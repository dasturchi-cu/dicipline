-- REJABON AI — RPG, gamification, coach, and AI twin
-- Source: DATABASE_ARCHITECTURE.md §6.6–6.7

CREATE TABLE player_profiles (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  total_xp          INTEGER NOT NULL DEFAULT 0,
  level             INTEGER NOT NULL DEFAULT 1 CHECK (level BETWEEN 1 AND 100),
  stat_discipline   INTEGER NOT NULL DEFAULT 0,
  stat_focus        INTEGER NOT NULL DEFAULT 0,
  stat_health       INTEGER NOT NULL DEFAULT 0,
  stat_knowledge    INTEGER NOT NULL DEFAULT 0,
  stat_wealth       INTEGER NOT NULL DEFAULT 0,
  stat_social       INTEGER NOT NULL DEFAULT 0,
  stat_spiritual    INTEGER NOT NULL DEFAULT 0,
  avatar_emoji      TEXT DEFAULT '🧙',
  title             TEXT DEFAULT 'Hayot o''rganuvchisi',
  last_xp_earned_at TIMESTAMPTZ,
  local_id          INTEGER,
  sync_version      INTEGER NOT NULL DEFAULT 1,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE xp_events (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  stat_type       stat_type NOT NULL,
  amount          INTEGER NOT NULL CHECK (amount > 0),
  source          TEXT NOT NULL,
  source_id       TEXT,
  description     TEXT,
  earned_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  local_id        INTEGER,
  device_id       UUID REFERENCES devices(id) ON DELETE SET NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE quests (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  quest_type        quest_type NOT NULL,
  quest_key         TEXT NOT NULL,
  title             TEXT NOT NULL,
  description       TEXT,
  stat_reward       stat_type NOT NULL,
  xp_reward         INTEGER NOT NULL,
  verification_type TEXT NOT NULL DEFAULT 'auto',
  verification_rule JSONB,
  current_progress  INTEGER NOT NULL DEFAULT 0,
  target_progress   INTEGER NOT NULL DEFAULT 1,
  start_date        DATE NOT NULL,
  end_date          DATE NOT NULL,
  is_completed      BOOLEAN NOT NULL DEFAULT FALSE,
  completed_at      TIMESTAMPTZ,
  local_id          INTEGER,
  device_id         UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version      INTEGER NOT NULL DEFAULT 1,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE achievement_unlocks (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  achievement_key TEXT NOT NULL,
  unlocked_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  celebrated      BOOLEAN NOT NULL DEFAULT FALSE,
  local_id        INTEGER,
  UNIQUE(user_id, achievement_key)
);

CREATE TABLE badge_unlocks (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  badge_key       TEXT NOT NULL,
  rarity          TEXT NOT NULL CHECK (rarity IN ('common','rare','epic','legendary')),
  emoji           TEXT NOT NULL,
  title           TEXT NOT NULL,
  source          TEXT NOT NULL,
  source_id       TEXT,
  showcased       BOOLEAN NOT NULL DEFAULT FALSE,
  unlocked_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  local_id        INTEGER,
  UNIQUE(user_id, badge_key)
);

CREATE TABLE skill_nodes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  branch          stat_type NOT NULL,
  node_key        TEXT NOT NULL,
  tier            INTEGER NOT NULL DEFAULT 1,
  xp_cost         INTEGER NOT NULL,
  is_unlocked     BOOLEAN NOT NULL DEFAULT FALSE,
  unlocked_at     TIMESTAMPTZ,
  local_id        INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, branch, node_key)
);

CREATE TABLE boss_challenges (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  boss_key        TEXT NOT NULL,
  title           TEXT NOT NULL,
  description     TEXT,
  boss_type       TEXT NOT NULL CHECK (boss_type IN ('weekly','monthly','seasonal')),
  required_count  INTEGER NOT NULL,
  current_count   INTEGER NOT NULL DEFAULT 0,
  reward_xp       INTEGER NOT NULL,
  is_defeated     BOOLEAN NOT NULL DEFAULT FALSE,
  defeated_at     TIMESTAMPTZ,
  starts_at       TIMESTAMPTZ NOT NULL,
  ends_at         TIMESTAMPTZ NOT NULL,
  local_id        INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, boss_key)
);

CREATE TABLE coach_memories (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category            TEXT NOT NULL,
  insight             TEXT NOT NULL,
  confidence          REAL NOT NULL DEFAULT 0.8 CHECK (confidence BETWEEN 0 AND 1),
  reference_count     INTEGER NOT NULL DEFAULT 0,
  last_referenced_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_dismissed        BOOLEAN NOT NULL DEFAULT FALSE,
  local_id            INTEGER,
  device_id           UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version        INTEGER NOT NULL DEFAULT 1,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMPTZ
);

CREATE TABLE coach_conversations (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role            coach_role NOT NULL,
  message         TEXT NOT NULL,
  input_type      TEXT NOT NULL DEFAULT 'text',
  context_type    TEXT,
  prompt_version  TEXT,
  local_id        INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE coach_commitments (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  commitment_text  TEXT NOT NULL,
  source           TEXT NOT NULL CHECK (source IN ('journal','coach','manual','goal')),
  source_entity_id TEXT,
  due_at           TIMESTAMPTZ,
  is_fulfilled     BOOLEAN NOT NULL DEFAULT FALSE,
  fulfilled_at     TIMESTAMPTZ,
  local_id         INTEGER,
  device_id        UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version     INTEGER NOT NULL DEFAULT 1,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at       TIMESTAMPTZ
);

CREATE TABLE coach_preferences (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  preferred_tone        TEXT NOT NULL DEFAULT 'encouraging',
  daily_llm_quota_used  INTEGER NOT NULL DEFAULT 0,
  quota_reset_at        DATE NOT NULL DEFAULT CURRENT_DATE,
  dismissed_patterns    JSONB NOT NULL DEFAULT '[]',
  intervention_enabled  BOOLEAN NOT NULL DEFAULT TRUE,
  weekly_review_push    BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE coach_advice_logs (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  insight_id      TEXT NOT NULL,
  headline        TEXT NOT NULL,
  body            TEXT,
  source_layer    TEXT NOT NULL,
  confidence      TEXT,
  action_taken    BOOLEAN NOT NULL DEFAULT FALSE,
  feedback        TEXT CHECK (feedback IN ('helpful','not_helpful','dismissed')),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE twin_profiles (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  chronotype            TEXT NOT NULL DEFAULT 'balanced',
  productivity_style    TEXT NOT NULL DEFAULT 'steady',
  goal_orientation      TEXT NOT NULL DEFAULT 'realistic',
  habit_consistency     TEXT NOT NULL DEFAULT 'medium',
  mood_trend            TEXT NOT NULL DEFAULT 'stable',
  traits                JSONB NOT NULL DEFAULT '{}',
  life_score_snapshot   INTEGER NOT NULL DEFAULT 0,
  local_id              INTEGER,
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);
