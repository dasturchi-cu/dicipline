-- REJABON AI — database functions
-- Source: DATABASE_ARCHITECTURE.md §9–10

-- Bump updated_at (+ sync_version on sync tables)
CREATE OR REPLACE FUNCTION touch_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  NEW.sync_version = COALESCE(OLD.sync_version, 0) + 1;
  RETURN NEW;
END;
$$;

-- Bump updated_at only (tables without sync_version)
CREATE OR REPLACE FUNCTION touch_updated_at_simple()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- Level formula: 100 * (level - 1)^1.5 (LIFE_RPG_SYSTEM.md §6.1)
CREATE OR REPLACE FUNCTION xp_threshold_for_level(p_level INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
  IF p_level <= 1 THEN
    RETURN 0;
  END IF;
  RETURN (100 * power(p_level - 1, 1.5))::INTEGER;
END;
$$;

CREATE OR REPLACE FUNCTION level_from_total_xp(p_total_xp INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  v_level INTEGER := 1;
BEGIN
  WHILE xp_threshold_for_level(v_level + 1) <= p_total_xp AND v_level < 100 LOOP
    v_level := v_level + 1;
  END LOOP;
  RETURN v_level;
END;
$$;

CREATE OR REPLACE FUNCTION title_for_level(p_level INTEGER)
RETURNS TEXT
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
  IF p_level >= 100 THEN RETURN 'Hayot afsonasi'; END IF;
  IF p_level >= 76  THEN RETURN 'Hayot strategi'; END IF;
  IF p_level >= 51  THEN RETURN 'Ustoz'; END IF;
  IF p_level >= 26  THEN RETURN 'Hayot arxitekti'; END IF;
  IF p_level >= 11  THEN RETURN 'Intizom quruvchi'; END IF;
  RETURN 'Hayot o''rganuvchisi';
END;
$$;

-- Auth bootstrap: profile + RPG + coach + social rows
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO profiles (user_id, display_name)
    VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'display_name', ''));
  INSERT INTO player_profiles (user_id) VALUES (NEW.id);
  INSERT INTO coach_preferences (user_id) VALUES (NEW.id);
  INSERT INTO twin_profiles (user_id) VALUES (NEW.id);
  INSERT INTO social_settings (user_id) VALUES (NEW.id);
  INSERT INTO subscriptions (user_id, tier) VALUES (NEW.id, 'free');
  RETURN NEW;
END;
$$;

-- Server-side daily life score snapshot
CREATE OR REPLACE FUNCTION compute_daily_life_score(
  p_user_id UUID,
  p_score_date DATE DEFAULT CURRENT_DATE
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_task_score    INTEGER := 0;
  v_habit_score   INTEGER := 0;
  v_mood_score    INTEGER := 50;
  v_goal_score    INTEGER := 0;
  v_time_score    INTEGER := 0;
  v_finance_score INTEGER := 50;
  v_life_score    INTEGER := 0;
BEGIN
  SELECT COALESCE(
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_completed) / NULLIF(COUNT(*), 0)),
    0
  )::INTEGER
  INTO v_task_score
  FROM tasks
  WHERE user_id = p_user_id
    AND deleted_at IS NULL
    AND (
      due_date IS NULL
      OR due_date::date = p_score_date
      OR (NOT is_completed AND due_date::date <= p_score_date)
    );

  SELECT COALESCE(
    ROUND(100.0 * (
      SELECT COUNT(DISTINCT hc.habit_id)
      FROM habit_completions hc
      WHERE hc.user_id = p_user_id AND hc.completed_date = p_score_date
    ) / NULLIF(COUNT(*), 0)),
    0
  )::INTEGER
  INTO v_habit_score
  FROM habits
  WHERE user_id = p_user_id AND deleted_at IS NULL;

  SELECT COALESCE(mood * 20, 50)
  INTO v_mood_score
  FROM journal_entries
  WHERE user_id = p_user_id
    AND entry_date = p_score_date
    AND deleted_at IS NULL;

  SELECT COALESCE(ROUND(AVG(progress)), 0)::INTEGER
  INTO v_goal_score
  FROM goals
  WHERE user_id = p_user_id
    AND deleted_at IS NULL
    AND NOT is_completed;

  SELECT LEAST(100, COALESCE(SUM(duration_seconds) / 36, 0))::INTEGER
  INTO v_time_score
  FROM time_logs
  WHERE user_id = p_user_id
    AND deleted_at IS NULL
    AND started_at::date = p_score_date;

  SELECT CASE
    WHEN COUNT(*) = 0 THEN 50
    WHEN SUM(CASE WHEN tx_type = 'income' THEN amount ELSE 0 END)
       >= SUM(CASE WHEN tx_type = 'expense' THEN amount ELSE 0 END) THEN 75
    ELSE 35
  END::INTEGER
  INTO v_finance_score
  FROM finance_transactions
  WHERE user_id = p_user_id
    AND deleted_at IS NULL
    AND tx_date >= date_trunc('month', p_score_date)::date
    AND tx_date <= p_score_date;

  v_life_score := (
    v_task_score + v_habit_score + v_mood_score
    + v_goal_score + v_time_score + v_finance_score
  ) / 6;

  INSERT INTO life_scores (
    user_id, score_date, life_score,
    task_score, habit_score, mood_score,
    goal_score, time_score, finance_score
  )
  VALUES (
    p_user_id, p_score_date, v_life_score,
    v_task_score, v_habit_score, v_mood_score,
    v_goal_score, v_time_score, v_finance_score
  )
  ON CONFLICT (user_id, score_date) DO UPDATE SET
    life_score    = EXCLUDED.life_score,
    task_score    = EXCLUDED.task_score,
    habit_score   = EXCLUDED.habit_score,
    mood_score    = EXCLUDED.mood_score,
    goal_score    = EXCLUDED.goal_score,
    time_score    = EXCLUDED.time_score,
    finance_score = EXCLUDED.finance_score,
    computed_at   = now();

  RETURN v_life_score;
END;
$$;

-- Atomic XP event + profile update
CREATE OR REPLACE FUNCTION apply_xp_event(
  p_user_id     UUID,
  p_stat_type   stat_type,
  p_amount      INTEGER,
  p_source      TEXT,
  p_source_id   TEXT DEFAULT NULL,
  p_description TEXT DEFAULT NULL,
  p_device_id   UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_event_id   UUID;
  v_total_xp   INTEGER;
  v_old_level  INTEGER;
  v_new_level  INTEGER;
  v_title      TEXT;
BEGIN
  IF p_amount <= 0 THEN
    RETURN jsonb_build_object('success', false, 'reason', 'invalid_amount');
  END IF;

  INSERT INTO xp_events (
    user_id, stat_type, amount, source, source_id, description, device_id
  )
  VALUES (
    p_user_id, p_stat_type, p_amount, p_source, p_source_id, p_description, p_device_id
  )
  RETURNING id INTO v_event_id;

  INSERT INTO player_profiles (user_id)
  VALUES (p_user_id)
  ON CONFLICT (user_id) DO NOTHING;

  SELECT total_xp, level
  INTO v_total_xp, v_old_level
  FROM player_profiles
  WHERE user_id = p_user_id
  FOR UPDATE;

  v_total_xp := v_total_xp + p_amount;
  v_new_level := level_from_total_xp(v_total_xp);
  v_title := title_for_level(v_new_level);

  UPDATE player_profiles SET
    total_xp = v_total_xp,
    level = v_new_level,
    title = v_title,
    stat_discipline = stat_discipline + CASE WHEN p_stat_type = 'discipline' THEN p_amount ELSE 0 END,
    stat_focus      = stat_focus      + CASE WHEN p_stat_type = 'focus'      THEN p_amount ELSE 0 END,
    stat_health     = stat_health     + CASE WHEN p_stat_type = 'health'     THEN p_amount ELSE 0 END,
    stat_knowledge  = stat_knowledge  + CASE WHEN p_stat_type = 'knowledge'  THEN p_amount ELSE 0 END,
    stat_wealth     = stat_wealth     + CASE WHEN p_stat_type = 'wealth'     THEN p_amount ELSE 0 END,
    stat_social     = stat_social     + CASE WHEN p_stat_type = 'social'     THEN p_amount ELSE 0 END,
    stat_spiritual  = stat_spiritual  + CASE WHEN p_stat_type = 'spiritual'  THEN p_amount ELSE 0 END,
    last_xp_earned_at = now(),
    updated_at = now()
  WHERE user_id = p_user_id;

  RETURN jsonb_build_object(
    'success', true,
    'event_id', v_event_id,
    'amount', p_amount,
    'stat_type', p_stat_type::TEXT,
    'leveled_up', v_new_level > v_old_level,
    'new_level', CASE WHEN v_new_level > v_old_level THEN v_new_level ELSE NULL END,
    'total_xp', v_total_xp
  );
END;
$$;
