-- REJABON AI — retention engine tables
-- Source: DATABASE_ARCHITECTURE.md §19.2–19.4

CREATE TABLE daily_briefing_logs (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  briefing_date       DATE NOT NULL,
  greeting            TEXT NOT NULL,
  priorities          JSONB NOT NULL DEFAULT '[]',
  advice              TEXT NOT NULL,
  productivity_score  INTEGER CHECK (productivity_score BETWEEN 0 AND 100),
  source_layer        TEXT NOT NULL DEFAULT 'rule' CHECK (source_layer IN ('rule','llm')),
  local_id            INTEGER,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, briefing_date)
);

CREATE TABLE emotion_snapshots (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  snapshot_date   DATE NOT NULL,
  happiness       REAL NOT NULL CHECK (happiness BETWEEN 0 AND 1),
  stress          REAL NOT NULL CHECK (stress BETWEEN 0 AND 1),
  motivation      REAL NOT NULL CHECK (motivation BETWEEN 0 AND 1),
  energy          REAL NOT NULL CHECK (energy BETWEEN 0 AND 1),
  anxiety         REAL NOT NULL CHECK (anxiety BETWEEN 0 AND 1),
  burnout_level   TEXT CHECK (burnout_level IN ('none','mild','moderate','severe')),
  top_insight     TEXT,
  intervention_id TEXT,
  local_id        INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, snapshot_date)
);

CREATE TABLE emergency_sessions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  triggered_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  motivation      TEXT NOT NULL,
  action_plan     JSONB NOT NULL DEFAULT '[]',
  recovery_plan   TEXT NOT NULL,
  reflection      TEXT,
  completed_at    TIMESTAMPTZ,
  local_id        INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE activity_heatmap_days (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  activity_date   DATE NOT NULL,
  intensity       SMALLINT NOT NULL CHECK (intensity BETWEEN 0 AND 4),
  task_count      INTEGER NOT NULL DEFAULT 0,
  habit_count     INTEGER NOT NULL DEFAULT 0,
  journal_count   INTEGER NOT NULL DEFAULT 0,
  workout_minutes INTEGER NOT NULL DEFAULT 0,
  study_minutes   INTEGER NOT NULL DEFAULT 0,
  computed_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, activity_date)
);

CREATE TABLE memory_retrieval_logs (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  memory_id       UUID NOT NULL REFERENCES coach_memories(id) ON DELETE CASCADE,
  surface         TEXT NOT NULL CHECK (surface IN ('dashboard','coach','briefing','qa')),
  retrieved_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes (§19.3)
CREATE INDEX idx_briefing_logs_user_date ON daily_briefing_logs(user_id, briefing_date DESC);
CREATE INDEX idx_emotion_snapshots_user_date ON emotion_snapshots(user_id, snapshot_date DESC);
CREATE INDEX idx_emergency_sessions_user ON emergency_sessions(user_id, triggered_at DESC);
CREATE INDEX idx_heatmap_days_user_date ON activity_heatmap_days(user_id, activity_date DESC);
CREATE INDEX idx_memory_retrieval_memory ON memory_retrieval_logs(memory_id, retrieved_at DESC);

-- Materialized view — heatmap (§19.4)
CREATE MATERIALIZED VIEW v_activity_heatmap_365 AS
SELECT
  user_id,
  activity_date,
  intensity,
  task_count + habit_count + journal_count AS activity_score
FROM activity_heatmap_days
WHERE activity_date >= CURRENT_DATE - INTERVAL '365 days';

CREATE UNIQUE INDEX ON v_activity_heatmap_365(user_id, activity_date);

-- RLS (§11 owner template)
ALTER TABLE daily_briefing_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY daily_briefing_logs_select_own ON daily_briefing_logs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY daily_briefing_logs_insert_own ON daily_briefing_logs FOR INSERT WITH CHECK (auth.uid() = user_id);

ALTER TABLE emotion_snapshots ENABLE ROW LEVEL SECURITY;
CREATE POLICY emotion_snapshots_select_own ON emotion_snapshots FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY emotion_snapshots_insert_own ON emotion_snapshots FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY emotion_snapshots_update_own ON emotion_snapshots FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE emergency_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY emergency_sessions_select_own ON emergency_sessions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY emergency_sessions_insert_own ON emergency_sessions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY emergency_sessions_update_own ON emergency_sessions FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE activity_heatmap_days ENABLE ROW LEVEL SECURITY;
CREATE POLICY activity_heatmap_days_select_own ON activity_heatmap_days FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY activity_heatmap_days_insert_own ON activity_heatmap_days FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY activity_heatmap_days_update_own ON activity_heatmap_days FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE memory_retrieval_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY memory_retrieval_logs_select_own ON memory_retrieval_logs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY memory_retrieval_logs_insert_own ON memory_retrieval_logs FOR INSERT WITH CHECK (auth.uid() = user_id);
