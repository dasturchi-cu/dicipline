-- REJABON AI — future self, analytics, social, and sync meta
-- Source: DATABASE_ARCHITECTURE.md §6.8–6.9

CREATE TABLE future_letters (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title             TEXT,
  content           TEXT NOT NULL,
  delivery_horizon  life_horizon NOT NULL,
  deliver_at        TIMESTAMPTZ NOT NULL,
  is_delivered      BOOLEAN NOT NULL DEFAULT FALSE,
  delivered_at      TIMESTAMPTZ,
  is_read           BOOLEAN NOT NULL DEFAULT FALSE,
  mood_at_writing   INTEGER CHECK (mood_at_writing BETWEEN 1 AND 5),
  snapshot          JSONB,
  local_id          INTEGER,
  sync_version      INTEGER NOT NULL DEFAULT 1,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at        TIMESTAMPTZ
);

CREATE TABLE vision_board_items (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  goal_id       UUID REFERENCES goals(id) ON DELETE SET NULL,
  image_url     TEXT,
  storage_path  TEXT,
  caption       TEXT,
  position_x    REAL DEFAULT 0,
  position_y    REAL DEFAULT 0,
  sort_order    INTEGER NOT NULL DEFAULT 0,
  local_id      INTEGER,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at    TIMESTAMPTZ
);

CREATE TABLE action_plans (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title         TEXT NOT NULL,
  description   TEXT,
  steps         JSONB NOT NULL DEFAULT '[]',
  goal_id       UUID REFERENCES goals(id) ON DELETE SET NULL,
  is_completed  BOOLEAN NOT NULL DEFAULT FALSE,
  local_id      INTEGER,
  sync_version  INTEGER NOT NULL DEFAULT 1,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at    TIMESTAMPTZ
);

CREATE TABLE life_scores (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  score_date       DATE NOT NULL,
  life_score       INTEGER NOT NULL CHECK (life_score BETWEEN 0 AND 100),
  task_score       INTEGER DEFAULT 0,
  habit_score      INTEGER DEFAULT 0,
  mood_score       INTEGER DEFAULT 0,
  goal_score       INTEGER DEFAULT 0,
  time_score       INTEGER DEFAULT 0,
  finance_score    INTEGER DEFAULT 0,
  domain_breakdown JSONB DEFAULT '{}',
  computed_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, score_date)
);

CREATE TABLE life_area_scores (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  score_date  DATE NOT NULL,
  area_id     TEXT NOT NULL,
  score       INTEGER NOT NULL CHECK (score BETWEEN 0 AND 100),
  computed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, score_date, area_id)
);

CREATE TABLE focus_sessions (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  session_type     TEXT NOT NULL,
  task_id          UUID REFERENCES tasks(id) ON DELETE SET NULL,
  started_at       TIMESTAMPTZ NOT NULL,
  ended_at         TIMESTAMPTZ,
  duration_seconds INTEGER,
  was_completed    BOOLEAN,
  xp_earned        INTEGER DEFAULT 0,
  local_id         INTEGER,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE friendships (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  friend_id  UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status     friendship_status NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, friend_id),
  CHECK (user_id <> friend_id)
);

CREATE TABLE partnerships (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  partner_name  TEXT NOT NULL,
  partner_email TEXT,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  local_id      INTEGER,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE friend_challenges (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  partnership_id   UUID REFERENCES partnerships(id) ON DELETE SET NULL,
  type_key         TEXT NOT NULL,
  title            TEXT NOT NULL,
  emoji            TEXT,
  target_score     INTEGER NOT NULL,
  my_score         INTEGER NOT NULL DEFAULT 0,
  my_progress      INTEGER NOT NULL DEFAULT 0,
  partner_name     TEXT,
  partner_score    INTEGER NOT NULL DEFAULT 0,
  partner_progress INTEGER NOT NULL DEFAULT 0,
  status           TEXT NOT NULL DEFAULT 'active',
  winner_label     TEXT,
  started_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  ends_at          TIMESTAMPTZ NOT NULL,
  local_id         INTEGER,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE group_challenges (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title          TEXT NOT NULL,
  description    TEXT,
  challenge_type TEXT NOT NULL,
  target_value   INTEGER NOT NULL,
  starts_at      TIMESTAMPTZ NOT NULL,
  ends_at        TIMESTAMPTZ NOT NULL,
  is_public      BOOLEAN NOT NULL DEFAULT FALSE,
  invite_code    TEXT UNIQUE,
  local_id       INTEGER,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE group_challenge_members (
  challenge_id  UUID NOT NULL REFERENCES group_challenges(id) ON DELETE CASCADE,
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  current_value INTEGER NOT NULL DEFAULT 0,
  joined_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (challenge_id, user_id)
);

CREATE TABLE referrals (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  referred_label   TEXT,
  source           TEXT,
  used_invite_code TEXT,
  reward_xp        INTEGER NOT NULL DEFAULT 0,
  reward_claimed   BOOLEAN NOT NULL DEFAULT FALSE,
  local_id         INTEGER,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE social_settings (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                 UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name            TEXT NOT NULL DEFAULT '',
  show_on_leaderboard     BOOLEAN NOT NULL DEFAULT TRUE,
  share_streaks           BOOLEAN NOT NULL DEFAULT TRUE,
  share_achievements      BOOLEAN NOT NULL DEFAULT TRUE,
  allow_friend_challenges BOOLEAN NOT NULL DEFAULT TRUE,
  allow_group_invites     BOOLEAN NOT NULL DEFAULT TRUE,
  leaderboard_use_alias   BOOLEAN NOT NULL DEFAULT FALSE,
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE sync_cursors (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  device_id      UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  table_name     TEXT NOT NULL,
  last_pulled_at TIMESTAMPTZ,
  last_pushed_at TIMESTAMPTZ,
  last_cursor    TIMESTAMPTZ,
  UNIQUE(user_id, device_id, table_name)
);

CREATE TABLE sync_tombstones (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  table_name  TEXT NOT NULL,
  record_id   UUID NOT NULL,
  local_id    INTEGER,
  deleted_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  device_id   UUID REFERENCES devices(id) ON DELETE SET NULL,
  UNIQUE(user_id, table_name, record_id)
);
