-- REJABON AI — indexes
-- Source: DATABASE_ARCHITECTURE.md §7

-- Critical indexes (§7 table)
CREATE INDEX idx_tasks_user_due ON tasks(user_id, due_date)
  WHERE deleted_at IS NULL AND NOT is_completed;

CREATE INDEX idx_tasks_overdue ON tasks(user_id, due_date)
  WHERE deleted_at IS NULL AND NOT is_completed AND due_date < now();

CREATE INDEX idx_habit_completions_user_date ON habit_completions(user_id, completed_date DESC);

CREATE INDEX idx_journal_user_date ON journal_entries(user_id, entry_date DESC);

CREATE INDEX idx_inbox_pending ON inbox_items(user_id)
  WHERE status = 'pending' AND deleted_at IS NULL;

CREATE INDEX idx_xp_events_user_earned ON xp_events(user_id, earned_at DESC);

CREATE INDEX idx_life_scores_user_date ON life_scores(user_id, score_date DESC);

CREATE INDEX idx_coach_memories_user ON coach_memories(user_id)
  WHERE deleted_at IS NULL AND NOT is_dismissed;

CREATE INDEX idx_future_letters_pending ON future_letters(user_id, deliver_at)
  WHERE NOT is_delivered AND deleted_at IS NULL;

CREATE INDEX idx_sync_tombstones_pull ON sync_tombstones(user_id, deleted_at DESC);

-- user_id composite indexes
CREATE INDEX idx_profiles_user ON profiles(user_id);
CREATE INDEX idx_devices_user ON devices(user_id);
CREATE INDEX idx_tasks_user_updated ON tasks(user_id, updated_at DESC);
CREATE INDEX idx_habits_user ON habits(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_goals_user ON goals(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_goal_milestones_goal ON goal_milestones(goal_id, sort_order);
CREATE INDEX idx_notes_user_updated ON notes(user_id, updated_at DESC);
CREATE INDEX idx_documents_user ON documents(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_inbox_user_updated ON inbox_items(user_id, updated_at DESC);
CREATE INDEX idx_finance_user_date ON finance_transactions(user_id, tx_date DESC);
CREATE INDEX idx_workouts_user_date ON workouts(user_id, workout_date DESC);
CREATE INDEX idx_study_subjects_user ON study_subjects(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_study_sessions_user_date ON study_sessions(user_id, session_date DESC);
CREATE INDEX idx_calendar_events_user_start ON calendar_events(user_id, start_time);
CREATE INDEX idx_plans_user_date ON plans(user_id, plan_date DESC);
CREATE INDEX idx_plan_items_plan ON plan_items(plan_id, sort_order);
CREATE INDEX idx_time_logs_user_started ON time_logs(user_id, started_at DESC);
CREATE INDEX idx_quests_user_dates ON quests(user_id, start_date, end_date);
CREATE INDEX idx_achievement_unlocks_user ON achievement_unlocks(user_id, unlocked_at DESC);
CREATE INDEX idx_badge_unlocks_user ON badge_unlocks(user_id, unlocked_at DESC);
CREATE INDEX idx_skill_nodes_user ON skill_nodes(user_id, branch);
CREATE INDEX idx_boss_challenges_user ON boss_challenges(user_id, ends_at);
CREATE INDEX idx_coach_conversations_user ON coach_conversations(user_id, created_at DESC);
CREATE INDEX idx_coach_commitments_user ON coach_commitments(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_coach_advice_logs_user ON coach_advice_logs(user_id, created_at DESC);
CREATE INDEX idx_focus_sessions_user ON focus_sessions(user_id, started_at DESC);
CREATE INDEX idx_friendships_user ON friendships(user_id, status);
CREATE INDEX idx_friendships_friend ON friendships(friend_id, status);
CREATE INDEX idx_partnerships_user ON partnerships(user_id) WHERE is_active;
CREATE INDEX idx_friend_challenges_user ON friend_challenges(user_id, ends_at);
CREATE INDEX idx_group_challenges_creator ON group_challenges(creator_id);
CREATE INDEX idx_group_challenge_members_user ON group_challenge_members(user_id);
CREATE INDEX idx_referrals_user ON referrals(user_id);
CREATE INDEX idx_sync_cursors_user ON sync_cursors(user_id, table_name);

-- GIN array indexes
CREATE INDEX idx_tasks_life_areas ON tasks USING GIN(life_area_ids);
CREATE INDEX idx_habits_life_areas ON habits USING GIN(life_area_ids);
CREATE INDEX idx_goals_life_areas ON goals USING GIN(life_area_ids);
CREATE INDEX idx_notes_tags ON notes USING GIN(tags);
CREATE INDEX idx_notes_life_areas ON notes USING GIN(life_area_ids);
CREATE INDEX idx_plans_life_areas ON plans USING GIN(life_area_ids);

-- Full-text search on notes
CREATE INDEX idx_notes_fts ON notes
  USING GIN(to_tsvector('simple', coalesce(title, '') || ' ' || coalesce(content, '')));

-- XP and quest indexes
CREATE INDEX idx_xp_events_source ON xp_events(user_id, source, source_id);
CREATE INDEX idx_quests_active ON quests(user_id, is_completed, end_date);

-- Unique (user_id, local_id) for sync tables
CREATE UNIQUE INDEX idx_tasks_user_local_id ON tasks(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_habits_user_local_id ON habits(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_goals_user_local_id ON goals(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_notes_user_local_id ON notes(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_journal_user_local_id ON journal_entries(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_documents_user_local_id ON documents(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_inbox_user_local_id ON inbox_items(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_finance_user_local_id ON finance_transactions(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_workouts_user_local_id ON workouts(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_study_subjects_user_local_id ON study_subjects(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_calendar_user_local_id ON calendar_events(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_plans_user_local_id ON plans(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_time_logs_user_local_id ON time_logs(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_player_profiles_user_local_id ON player_profiles(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_quests_user_local_id ON quests(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_coach_memories_user_local_id ON coach_memories(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_coach_commitments_user_local_id ON coach_commitments(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_future_letters_user_local_id ON future_letters(user_id, local_id) WHERE local_id IS NOT NULL;
CREATE UNIQUE INDEX idx_action_plans_user_local_id ON action_plans(user_id, local_id) WHERE local_id IS NOT NULL;
