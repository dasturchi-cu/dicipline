-- REJABON AI — core profiles, devices, subscriptions
-- Source: DATABASE_ARCHITECTURE.md §6.2

CREATE TABLE profiles (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                 UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name            TEXT NOT NULL DEFAULT '',
  locale                  TEXT NOT NULL DEFAULT 'uz',
  persona                 TEXT CHECK (persona IN ('student','professional','health','finance','wellness','all')),
  focus_areas             TEXT[] DEFAULT '{}',
  avatar_emoji            TEXT DEFAULT '🧙',
  onboarding_completed_at TIMESTAMPTZ,
  settings                JSONB NOT NULL DEFAULT '{}',
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE devices (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  device_name     TEXT,
  platform        TEXT CHECK (platform IN ('android','ios','web','desktop')),
  app_version     TEXT,
  last_sync_at    TIMESTAMPTZ,
  push_token      TEXT,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, device_name)
);

CREATE TABLE subscriptions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  tier            subscription_tier NOT NULL DEFAULT 'free',
  expires_at      TIMESTAMPTZ,
  provider        TEXT,
  external_id     TEXT,
  metadata        JSONB DEFAULT '{}',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- handle_new_user() body: 00008_functions.sql
-- on_auth_user_created trigger: 00009_triggers.sql
