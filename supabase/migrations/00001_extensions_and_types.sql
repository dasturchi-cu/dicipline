-- REJABON AI — extensions and enum types
-- Source: DATABASE_ARCHITECTURE.md §6.1, §3.2–3.3

CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE priority_level AS ENUM ('low', 'medium', 'high');
CREATE TYPE habit_frequency AS ENUM ('daily', 'weekdays', 'weekly', 'custom');
CREATE TYPE finance_tx_type AS ENUM ('income', 'expense');
CREATE TYPE inbox_status AS ENUM ('pending', 'accepted', 'processed', 'archived');
CREATE TYPE capture_type AS ENUM ('note', 'voice', 'photo', 'link', 'document', 'idea');
CREATE TYPE quest_type AS ENUM ('daily', 'weekly', 'boss', 'welcome');
CREATE TYPE stat_type AS ENUM ('discipline', 'focus', 'health', 'knowledge', 'wealth', 'social', 'spiritual');
CREATE TYPE friendship_status AS ENUM ('pending', 'accepted', 'blocked');
CREATE TYPE subscription_tier AS ENUM ('free', 'premium', 'pro');
CREATE TYPE coach_role AS ENUM ('user', 'coach', 'system');
CREATE TYPE life_horizon AS ENUM ('1m', '3m', '6m', '1y', '5y');
