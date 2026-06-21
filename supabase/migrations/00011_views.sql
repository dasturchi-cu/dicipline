-- REJABON AI — views
-- Source: DATABASE_ARCHITECTURE.md §8

CREATE OR REPLACE VIEW v_user_dashboard_summary AS
SELECT
  p.user_id,
  p.display_name,
  pp.level,
  pp.total_xp,
  pp.avatar_emoji,
  (
    SELECT life_score FROM life_scores ls
    WHERE ls.user_id = p.user_id
    ORDER BY score_date DESC
    LIMIT 1
  ) AS latest_life_score,
  (
    SELECT COUNT(*) FROM tasks t
    WHERE t.user_id = p.user_id
      AND NOT t.is_completed
      AND t.deleted_at IS NULL
      AND t.due_date::date <= CURRENT_DATE
  ) AS tasks_due_today,
  (
    SELECT COUNT(*) FROM inbox_items i
    WHERE i.user_id = p.user_id
      AND i.status = 'pending'
      AND i.deleted_at IS NULL
  ) AS inbox_pending
FROM profiles p
LEFT JOIN player_profiles pp ON pp.user_id = p.user_id;

CREATE OR REPLACE VIEW v_weekly_productivity AS
SELECT
  t.user_id,
  t.due_date::date AS activity_date,
  COUNT(*) FILTER (WHERE t.is_completed) AS tasks_completed,
  COUNT(*) AS tasks_total
FROM tasks t
WHERE t.deleted_at IS NULL
  AND t.due_date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY t.user_id, t.due_date::date;

CREATE OR REPLACE VIEW v_habit_completion_rate AS
SELECT
  h.user_id,
  h.id AS habit_id,
  h.name AS habit_name,
  COUNT(hc.id) AS completions_30d,
  h.current_streak,
  h.longest_streak,
  ROUND(
    100.0 * COUNT(hc.id) / GREATEST(h.target_per_week * 4, 1),
    1
  ) AS completion_rate_pct
FROM habits h
LEFT JOIN habit_completions hc
  ON hc.habit_id = h.id
  AND hc.completed_date >= CURRENT_DATE - INTERVAL '30 days'
WHERE h.deleted_at IS NULL
GROUP BY h.user_id, h.id, h.name, h.current_streak, h.longest_streak, h.target_per_week;

CREATE OR REPLACE VIEW v_mood_trend_7d AS
SELECT
  j.user_id,
  j.entry_date,
  j.mood,
  j.stress_level,
  j.energy_level,
  AVG(j.mood) OVER (
    PARTITION BY j.user_id
    ORDER BY j.entry_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS mood_7d_avg
FROM journal_entries j
WHERE j.deleted_at IS NULL
  AND j.entry_date >= CURRENT_DATE - INTERVAL '7 days';

CREATE OR REPLACE VIEW v_finance_monthly AS
SELECT
  f.user_id,
  date_trunc('month', f.tx_date)::date AS month_start,
  SUM(CASE WHEN f.tx_type = 'income'  THEN f.amount ELSE 0 END) AS total_income,
  SUM(CASE WHEN f.tx_type = 'expense' THEN f.amount ELSE 0 END) AS total_expense,
  SUM(CASE WHEN f.tx_type = 'income'  THEN f.amount ELSE 0 END)
    - SUM(CASE WHEN f.tx_type = 'expense' THEN f.amount ELSE 0 END) AS net_balance
FROM finance_transactions f
WHERE f.deleted_at IS NULL
GROUP BY f.user_id, date_trunc('month', f.tx_date)::date;

CREATE OR REPLACE VIEW v_time_by_area AS
SELECT
  tl.user_id,
  COALESCE(tl.life_area_id, 'general') AS life_area_id,
  date_trunc('week', tl.started_at)::date AS week_start,
  SUM(tl.duration_seconds) AS total_seconds,
  COUNT(*) AS session_count
FROM time_logs tl
WHERE tl.deleted_at IS NULL
GROUP BY tl.user_id, COALESCE(tl.life_area_id, 'general'), date_trunc('week', tl.started_at)::date;

CREATE OR REPLACE VIEW v_active_quests AS
SELECT q.*
FROM quests q
WHERE NOT q.is_completed
  AND q.end_date >= CURRENT_DATE;

CREATE OR REPLACE VIEW v_leaderboard AS
SELECT
  pp.user_id,
  CASE
    WHEN ss.leaderboard_use_alias THEN ss.display_name
    ELSE p.display_name
  END AS display_name,
  pp.level,
  pp.total_xp,
  pp.avatar_emoji,
  pp.title,
  ss.show_on_leaderboard
FROM player_profiles pp
JOIN profiles p ON p.user_id = pp.user_id
LEFT JOIN social_settings ss ON ss.user_id = pp.user_id
WHERE COALESCE(ss.show_on_leaderboard, TRUE);

CREATE OR REPLACE VIEW v_friend_stats AS
SELECT
  f.user_id,
  f.friend_id,
  f.status,
  pp.level AS friend_level,
  pp.total_xp AS friend_total_xp,
  pp.avatar_emoji AS friend_avatar,
  (
    SELECT COUNT(*) FROM achievement_unlocks au
    WHERE au.user_id = f.friend_id
  ) AS friend_achievement_count,
  (
    SELECT MAX(h.longest_streak) FROM habits h
    WHERE h.user_id = f.friend_id AND h.deleted_at IS NULL
  ) AS friend_best_streak
FROM friendships f
LEFT JOIN player_profiles pp ON pp.user_id = f.friend_id
WHERE f.status = 'accepted';

CREATE OR REPLACE VIEW v_sync_changes AS
SELECT
  user_id,
  'tasks'::TEXT AS table_name,
  id AS record_id,
  updated_at AS changed_at,
  deleted_at IS NOT NULL AS is_deleted
FROM tasks
UNION ALL
SELECT user_id, 'habits', id, updated_at, deleted_at IS NOT NULL FROM habits
UNION ALL
SELECT user_id, 'goals', id, updated_at, deleted_at IS NOT NULL FROM goals
UNION ALL
SELECT user_id, 'notes', id, updated_at, deleted_at IS NOT NULL FROM notes
UNION ALL
SELECT user_id, 'journal_entries', id, updated_at, deleted_at IS NOT NULL FROM journal_entries
UNION ALL
SELECT user_id, 'inbox_items', id, updated_at, deleted_at IS NOT NULL FROM inbox_items
UNION ALL
SELECT user_id, 'habit_completions', id, created_at, FALSE FROM habit_completions
UNION ALL
SELECT user_id, table_name, record_id, deleted_at, TRUE FROM sync_tombstones;
