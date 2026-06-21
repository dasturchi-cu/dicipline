-- REJABON AI — productivity domain
-- Source: DATABASE_ARCHITECTURE.md §6.3

CREATE TABLE goals (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  emoji           TEXT DEFAULT '',
  description     TEXT,
  progress        REAL NOT NULL DEFAULT 0 CHECK (progress BETWEEN 0 AND 100),
  life_area_ids   TEXT[] NOT NULL DEFAULT '{}',
  horizon         life_horizon,
  parent_goal_id  UUID REFERENCES goals(id) ON DELETE SET NULL,
  target_date     TIMESTAMPTZ,
  is_completed    BOOLEAN NOT NULL DEFAULT FALSE,
  completed_at    TIMESTAMPTZ,
  local_id        INTEGER,
  device_id       UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version    INTEGER NOT NULL DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ
);

CREATE TABLE tasks (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                 UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title                   TEXT NOT NULL,
  emoji                   TEXT DEFAULT '',
  description             TEXT,
  is_completed            BOOLEAN NOT NULL DEFAULT FALSE,
  priority                priority_level NOT NULL DEFAULT 'medium',
  category                TEXT NOT NULL DEFAULT 'general',
  life_area_ids           TEXT[] NOT NULL DEFAULT '{}',
  due_date                TIMESTAMPTZ,
  completed_at            TIMESTAMPTZ,
  goal_id                 UUID REFERENCES goals(id) ON DELETE SET NULL,
  recurrence_type         TEXT NOT NULL DEFAULT 'none',
  recurrence_template_id  UUID REFERENCES tasks(id) ON DELETE SET NULL,
  next_recurrence_date    TIMESTAMPTZ,
  recurrence_days         INTEGER[] DEFAULT '{}',
  postpone_count          INTEGER NOT NULL DEFAULT 0,
  local_id                INTEGER,
  device_id               UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version            INTEGER NOT NULL DEFAULT 1,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at              TIMESTAMPTZ
);

CREATE TABLE habits (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,
  emoji           TEXT DEFAULT '',
  icon            TEXT DEFAULT 'check_circle',
  color           INTEGER NOT NULL DEFAULT 4280391411,
  life_area_ids   TEXT[] NOT NULL DEFAULT '{}',
  frequency_type  habit_frequency NOT NULL DEFAULT 'daily',
  target_per_week INTEGER NOT NULL DEFAULT 7,
  active_days     INTEGER[] DEFAULT '{}',
  current_streak  INTEGER NOT NULL DEFAULT 0,
  longest_streak  INTEGER NOT NULL DEFAULT 0,
  local_id        INTEGER,
  device_id       UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version    INTEGER NOT NULL DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ
);

CREATE TABLE habit_completions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  habit_id        UUID NOT NULL REFERENCES habits(id) ON DELETE CASCADE,
  completed_date  DATE NOT NULL,
  xp_awarded      INTEGER DEFAULT 0,
  local_id        INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, habit_id, completed_date)
);

CREATE TABLE goal_milestones (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  goal_id         UUID NOT NULL REFERENCES goals(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  sort_order      INTEGER NOT NULL DEFAULT 0,
  is_completed    BOOLEAN NOT NULL DEFAULT FALSE,
  completed_at    TIMESTAMPTZ,
  local_id        INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
