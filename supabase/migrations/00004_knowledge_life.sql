-- REJABON AI — knowledge, capture, and life modules
-- Source: DATABASE_ARCHITECTURE.md §6.4–6.5

CREATE TABLE notes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  emoji           TEXT DEFAULT '',
  content         TEXT NOT NULL DEFAULT '',
  tags            TEXT[] DEFAULT '{}',
  item_type       TEXT NOT NULL DEFAULT 'note',
  source_url      TEXT,
  category        TEXT NOT NULL DEFAULT 'umumiy',
  life_area_ids   TEXT[] DEFAULT '{}',
  is_favorite     BOOLEAN NOT NULL DEFAULT FALSE,
  local_id        INTEGER,
  device_id       UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version    INTEGER NOT NULL DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ
);

CREATE TABLE journal_entries (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  entry_date      DATE NOT NULL,
  content         TEXT NOT NULL DEFAULT '',
  mood            INTEGER NOT NULL DEFAULT 3 CHECK (mood BETWEEN 1 AND 5),
  stress_level    INTEGER CHECK (stress_level BETWEEN 1 AND 5),
  energy_level    INTEGER CHECK (energy_level BETWEEN 1 AND 5),
  ai_tags         TEXT[] DEFAULT '{}',
  local_id        INTEGER,
  device_id       UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version    INTEGER NOT NULL DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ,
  UNIQUE(user_id, entry_date)
);

CREATE TABLE documents (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  file_name       TEXT,
  mime_type       TEXT,
  storage_path    TEXT,
  size_bytes      BIGINT,
  tags            TEXT[] DEFAULT '{}',
  local_id        INTEGER,
  device_id       UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version    INTEGER NOT NULL DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ
);

CREATE TABLE inbox_items (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title                 TEXT NOT NULL,
  body                  TEXT NOT NULL DEFAULT '',
  capture_type          capture_type NOT NULL DEFAULT 'note',
  status                inbox_status NOT NULL DEFAULT 'pending',
  suggested_action      TEXT,
  source_url            TEXT,
  emoji                 TEXT DEFAULT '📥',
  processed_entity_id   UUID,
  processed_entity_type TEXT,
  local_id              INTEGER,
  device_id             UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version          INTEGER NOT NULL DEFAULT 1,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at            TIMESTAMPTZ
);

CREATE TABLE finance_transactions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  tx_type         finance_tx_type NOT NULL,
  amount          NUMERIC(14,2) NOT NULL CHECK (amount >= 0),
  category        TEXT NOT NULL,
  description     TEXT,
  tx_date         DATE NOT NULL DEFAULT CURRENT_DATE,
  local_id        INTEGER,
  device_id       UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version    INTEGER NOT NULL DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ
);

CREATE TABLE workouts (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  workout_type     TEXT NOT NULL,
  duration_minutes INTEGER,
  calories         INTEGER,
  notes            TEXT,
  workout_date     DATE NOT NULL DEFAULT CURRENT_DATE,
  local_id         INTEGER,
  device_id        UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version     INTEGER NOT NULL DEFAULT 1,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at       TIMESTAMPTZ
);

CREATE TABLE study_subjects (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,
  emoji           TEXT DEFAULT '📚',
  color           INTEGER,
  total_minutes   INTEGER NOT NULL DEFAULT 0,
  local_id        INTEGER,
  device_id       UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version    INTEGER NOT NULL DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ
);

CREATE TABLE study_sessions (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  subject_id       UUID NOT NULL REFERENCES study_subjects(id) ON DELETE CASCADE,
  duration_minutes INTEGER NOT NULL,
  notes            TEXT,
  session_date     DATE NOT NULL DEFAULT CURRENT_DATE,
  local_id         INTEGER,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE calendar_events (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  description     TEXT,
  start_time      TIMESTAMPTZ NOT NULL,
  end_time        TIMESTAMPTZ NOT NULL,
  is_all_day      BOOLEAN NOT NULL DEFAULT FALSE,
  recurrence_rule TEXT,
  local_id        INTEGER,
  device_id       UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version    INTEGER NOT NULL DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ
);

CREATE TABLE plans (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  plan_date       DATE NOT NULL,
  source_text     TEXT,
  life_area_ids   TEXT[] DEFAULT '{}',
  local_id        INTEGER,
  device_id       UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version    INTEGER NOT NULL DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ,
  UNIQUE(user_id, plan_date)
);

CREATE TABLE plan_items (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  plan_id          UUID NOT NULL REFERENCES plans(id) ON DELETE CASCADE,
  title            TEXT NOT NULL,
  emoji            TEXT DEFAULT '',
  start_time       TIMESTAMPTZ NOT NULL,
  duration_minutes INTEGER NOT NULL DEFAULT 30,
  is_completed     BOOLEAN NOT NULL DEFAULT FALSE,
  is_missed        BOOLEAN NOT NULL DEFAULT FALSE,
  category         TEXT DEFAULT 'general',
  sort_order       INTEGER NOT NULL DEFAULT 0,
  local_id         INTEGER,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE monthly_focus (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  focus_month     DATE NOT NULL,
  title           TEXT NOT NULL,
  description     TEXT,
  goal_ids        UUID[] DEFAULT '{}',
  local_id        INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, focus_month)
);

CREATE TABLE time_logs (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  session_type      TEXT NOT NULL,
  duration_seconds  INTEGER NOT NULL CHECK (duration_seconds > 0),
  started_at        TIMESTAMPTZ NOT NULL,
  ended_at          TIMESTAMPTZ NOT NULL,
  label             TEXT,
  notes             TEXT,
  from_timer        BOOLEAN NOT NULL DEFAULT TRUE,
  life_area_id      TEXT,
  task_id           UUID REFERENCES tasks(id) ON DELETE SET NULL,
  local_id          INTEGER,
  device_id         UUID REFERENCES devices(id) ON DELETE SET NULL,
  sync_version      INTEGER NOT NULL DEFAULT 1,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at        TIMESTAMPTZ
);

CREATE TABLE milestones (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  description     TEXT,
  milestone_date  DATE NOT NULL,
  emoji           TEXT,
  category        TEXT,
  local_id        INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE challenges (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  description     TEXT,
  target_value    INTEGER NOT NULL,
  current_value   INTEGER NOT NULL DEFAULT 0,
  starts_at       TIMESTAMPTZ NOT NULL,
  ends_at         TIMESTAMPTZ NOT NULL,
  is_completed    BOOLEAN NOT NULL DEFAULT FALSE,
  local_id        INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
