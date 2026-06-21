-- REJABON AI — row level security
-- Source: DATABASE_ARCHITECTURE.md §11

-- ── Owner template (user_id) ────────────────────────────────────────────────

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY profiles_select_own ON profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY profiles_insert_own ON profiles FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY profiles_update_own ON profiles FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY profiles_delete_own ON profiles FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE devices ENABLE ROW LEVEL SECURITY;
CREATE POLICY devices_select_own ON devices FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY devices_insert_own ON devices FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY devices_update_own ON devices FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY devices_delete_own ON devices FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY subscriptions_select_own ON subscriptions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY subscriptions_insert_own ON subscriptions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY subscriptions_update_own ON subscriptions FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
CREATE POLICY tasks_select_own ON tasks FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY tasks_insert_own ON tasks FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY tasks_update_own ON tasks FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY tasks_delete_own ON tasks FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE habits ENABLE ROW LEVEL SECURITY;
CREATE POLICY habits_select_own ON habits FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY habits_insert_own ON habits FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY habits_update_own ON habits FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY habits_delete_own ON habits FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE habit_completions ENABLE ROW LEVEL SECURITY;
CREATE POLICY habit_completions_select_own ON habit_completions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY habit_completions_insert_own ON habit_completions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY habit_completions_update_own ON habit_completions FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY habit_completions_delete_own ON habit_completions FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
CREATE POLICY goals_select_own ON goals FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY goals_insert_own ON goals FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY goals_update_own ON goals FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY goals_delete_own ON goals FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE goal_milestones ENABLE ROW LEVEL SECURITY;
CREATE POLICY goal_milestones_select_own ON goal_milestones FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY goal_milestones_insert_own ON goal_milestones FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY goal_milestones_update_own ON goal_milestones FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY goal_milestones_delete_own ON goal_milestones FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE notes ENABLE ROW LEVEL SECURITY;
CREATE POLICY notes_select_own ON notes FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY notes_insert_own ON notes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY notes_update_own ON notes FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY notes_delete_own ON notes FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE journal_entries ENABLE ROW LEVEL SECURITY;
CREATE POLICY journal_entries_select_own ON journal_entries FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY journal_entries_insert_own ON journal_entries FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY journal_entries_update_own ON journal_entries FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY journal_entries_delete_own ON journal_entries FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
CREATE POLICY documents_select_own ON documents FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY documents_insert_own ON documents FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY documents_update_own ON documents FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY documents_delete_own ON documents FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE inbox_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY inbox_items_select_own ON inbox_items FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY inbox_items_insert_own ON inbox_items FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY inbox_items_update_own ON inbox_items FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY inbox_items_delete_own ON inbox_items FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE finance_transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY finance_transactions_select_own ON finance_transactions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY finance_transactions_insert_own ON finance_transactions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY finance_transactions_update_own ON finance_transactions FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY finance_transactions_delete_own ON finance_transactions FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
CREATE POLICY workouts_select_own ON workouts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY workouts_insert_own ON workouts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY workouts_update_own ON workouts FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY workouts_delete_own ON workouts FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE study_subjects ENABLE ROW LEVEL SECURITY;
CREATE POLICY study_subjects_select_own ON study_subjects FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY study_subjects_insert_own ON study_subjects FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY study_subjects_update_own ON study_subjects FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY study_subjects_delete_own ON study_subjects FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE study_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY study_sessions_select_own ON study_sessions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY study_sessions_insert_own ON study_sessions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY study_sessions_update_own ON study_sessions FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY study_sessions_delete_own ON study_sessions FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE calendar_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY calendar_events_select_own ON calendar_events FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY calendar_events_insert_own ON calendar_events FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY calendar_events_update_own ON calendar_events FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY calendar_events_delete_own ON calendar_events FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY plans_select_own ON plans FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY plans_insert_own ON plans FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY plans_update_own ON plans FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY plans_delete_own ON plans FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE plan_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY plan_items_select_own ON plan_items FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY plan_items_insert_own ON plan_items FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY plan_items_update_own ON plan_items FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY plan_items_delete_own ON plan_items FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE monthly_focus ENABLE ROW LEVEL SECURITY;
CREATE POLICY monthly_focus_select_own ON monthly_focus FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY monthly_focus_insert_own ON monthly_focus FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY monthly_focus_update_own ON monthly_focus FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY monthly_focus_delete_own ON monthly_focus FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE time_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY time_logs_select_own ON time_logs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY time_logs_insert_own ON time_logs FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY time_logs_update_own ON time_logs FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY time_logs_delete_own ON time_logs FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE milestones ENABLE ROW LEVEL SECURITY;
CREATE POLICY milestones_select_own ON milestones FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY milestones_insert_own ON milestones FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY milestones_update_own ON milestones FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY milestones_delete_own ON milestones FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;
CREATE POLICY challenges_select_own ON challenges FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY challenges_insert_own ON challenges FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY challenges_update_own ON challenges FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY challenges_delete_own ON challenges FOR DELETE USING (auth.uid() = user_id);

-- ── RPG: friends-read on player_profiles & achievement_unlocks ──────────────

ALTER TABLE player_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY player_profiles_select ON player_profiles FOR SELECT USING (
  auth.uid() = user_id OR EXISTS (
    SELECT 1 FROM friendships f
    WHERE f.status = 'accepted'
      AND (
        (f.user_id = auth.uid() AND f.friend_id = player_profiles.user_id)
        OR (f.friend_id = auth.uid() AND f.user_id = player_profiles.user_id)
      )
  )
);
CREATE POLICY player_profiles_insert_own ON player_profiles FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY player_profiles_update_own ON player_profiles FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE xp_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY xp_events_select_own ON xp_events FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY xp_events_insert_own ON xp_events FOR INSERT WITH CHECK (auth.uid() = user_id);

ALTER TABLE quests ENABLE ROW LEVEL SECURITY;
CREATE POLICY quests_select_own ON quests FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY quests_insert_own ON quests FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY quests_update_own ON quests FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY quests_delete_own ON quests FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE achievement_unlocks ENABLE ROW LEVEL SECURITY;
CREATE POLICY achievement_unlocks_select ON achievement_unlocks FOR SELECT USING (
  auth.uid() = user_id OR EXISTS (
    SELECT 1 FROM friendships f
    WHERE f.status = 'accepted'
      AND (
        (f.user_id = auth.uid() AND f.friend_id = achievement_unlocks.user_id)
        OR (f.friend_id = auth.uid() AND f.user_id = achievement_unlocks.user_id)
      )
  )
);
CREATE POLICY achievement_unlocks_insert_own ON achievement_unlocks FOR INSERT WITH CHECK (auth.uid() = user_id);

ALTER TABLE badge_unlocks ENABLE ROW LEVEL SECURITY;
CREATE POLICY badge_unlocks_select_own ON badge_unlocks FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY badge_unlocks_insert_own ON badge_unlocks FOR INSERT WITH CHECK (auth.uid() = user_id);

ALTER TABLE skill_nodes ENABLE ROW LEVEL SECURITY;
CREATE POLICY skill_nodes_select_own ON skill_nodes FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY skill_nodes_insert_own ON skill_nodes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY skill_nodes_update_own ON skill_nodes FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY skill_nodes_delete_own ON skill_nodes FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE boss_challenges ENABLE ROW LEVEL SECURITY;
CREATE POLICY boss_challenges_select_own ON boss_challenges FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY boss_challenges_insert_own ON boss_challenges FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY boss_challenges_update_own ON boss_challenges FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY boss_challenges_delete_own ON boss_challenges FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE coach_memories ENABLE ROW LEVEL SECURITY;
CREATE POLICY coach_memories_select_own ON coach_memories FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY coach_memories_insert_own ON coach_memories FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY coach_memories_update_own ON coach_memories FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY coach_memories_delete_own ON coach_memories FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE coach_conversations ENABLE ROW LEVEL SECURITY;
CREATE POLICY coach_conversations_select_own ON coach_conversations FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY coach_conversations_insert_own ON coach_conversations FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY coach_conversations_update_own ON coach_conversations FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY coach_conversations_delete_own ON coach_conversations FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE coach_commitments ENABLE ROW LEVEL SECURITY;
CREATE POLICY coach_commitments_select_own ON coach_commitments FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY coach_commitments_insert_own ON coach_commitments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY coach_commitments_update_own ON coach_commitments FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY coach_commitments_delete_own ON coach_commitments FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE coach_preferences ENABLE ROW LEVEL SECURITY;
CREATE POLICY coach_preferences_select_own ON coach_preferences FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY coach_preferences_insert_own ON coach_preferences FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY coach_preferences_update_own ON coach_preferences FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE coach_advice_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY coach_advice_logs_select_own ON coach_advice_logs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY coach_advice_logs_insert_own ON coach_advice_logs FOR INSERT WITH CHECK (auth.uid() = user_id);

ALTER TABLE twin_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY twin_profiles_select_own ON twin_profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY twin_profiles_insert_own ON twin_profiles FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY twin_profiles_update_own ON twin_profiles FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE future_letters ENABLE ROW LEVEL SECURITY;
CREATE POLICY future_letters_select_own ON future_letters FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY future_letters_insert_own ON future_letters FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY future_letters_update_own ON future_letters FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY future_letters_delete_own ON future_letters FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE vision_board_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY vision_board_items_select_own ON vision_board_items FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY vision_board_items_insert_own ON vision_board_items FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY vision_board_items_update_own ON vision_board_items FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY vision_board_items_delete_own ON vision_board_items FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE action_plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY action_plans_select_own ON action_plans FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY action_plans_insert_own ON action_plans FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY action_plans_update_own ON action_plans FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY action_plans_delete_own ON action_plans FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE life_scores ENABLE ROW LEVEL SECURITY;
CREATE POLICY life_scores_select_own ON life_scores FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY life_scores_insert_own ON life_scores FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY life_scores_update_own ON life_scores FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE life_area_scores ENABLE ROW LEVEL SECURITY;
CREATE POLICY life_area_scores_select_own ON life_area_scores FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY life_area_scores_insert_own ON life_area_scores FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY life_area_scores_update_own ON life_area_scores FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE focus_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY focus_sessions_select_own ON focus_sessions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY focus_sessions_insert_own ON focus_sessions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY focus_sessions_update_own ON focus_sessions FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY focus_sessions_delete_own ON focus_sessions FOR DELETE USING (auth.uid() = user_id);

-- ── Social: bidirectional / group ───────────────────────────────────────────

ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
CREATE POLICY friendships_select ON friendships FOR SELECT USING (
  auth.uid() = user_id OR auth.uid() = friend_id
);
CREATE POLICY friendships_insert ON friendships FOR INSERT WITH CHECK (
  auth.uid() = user_id OR auth.uid() = friend_id
);
CREATE POLICY friendships_update ON friendships FOR UPDATE USING (
  auth.uid() = user_id OR auth.uid() = friend_id
);
CREATE POLICY friendships_delete ON friendships FOR DELETE USING (
  auth.uid() = user_id OR auth.uid() = friend_id
);

ALTER TABLE partnerships ENABLE ROW LEVEL SECURITY;
CREATE POLICY partnerships_select_own ON partnerships FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY partnerships_insert_own ON partnerships FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY partnerships_update_own ON partnerships FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY partnerships_delete_own ON partnerships FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE friend_challenges ENABLE ROW LEVEL SECURITY;
CREATE POLICY friend_challenges_select_own ON friend_challenges FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY friend_challenges_insert_own ON friend_challenges FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY friend_challenges_update_own ON friend_challenges FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY friend_challenges_delete_own ON friend_challenges FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE group_challenges ENABLE ROW LEVEL SECURITY;
CREATE POLICY group_challenges_select ON group_challenges FOR SELECT USING (
  is_public
  OR creator_id = auth.uid()
  OR EXISTS (
    SELECT 1 FROM group_challenge_members m
    WHERE m.challenge_id = group_challenges.id AND m.user_id = auth.uid()
  )
);
CREATE POLICY group_challenges_insert ON group_challenges FOR INSERT WITH CHECK (
  creator_id = auth.uid()
);
CREATE POLICY group_challenges_update ON group_challenges FOR UPDATE USING (
  creator_id = auth.uid()
);
CREATE POLICY group_challenges_delete ON group_challenges FOR DELETE USING (
  creator_id = auth.uid()
);

ALTER TABLE group_challenge_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY group_challenge_members_select ON group_challenge_members FOR SELECT USING (
  user_id = auth.uid()
  OR EXISTS (
    SELECT 1 FROM group_challenges gc
    WHERE gc.id = group_challenge_members.challenge_id
      AND (gc.is_public OR gc.creator_id = auth.uid())
  )
);
CREATE POLICY group_challenge_members_insert ON group_challenge_members FOR INSERT WITH CHECK (
  user_id = auth.uid()
);
CREATE POLICY group_challenge_members_update ON group_challenge_members FOR UPDATE USING (
  user_id = auth.uid()
);
CREATE POLICY group_challenge_members_delete ON group_challenge_members FOR DELETE USING (
  user_id = auth.uid()
);

ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;
CREATE POLICY referrals_select_own ON referrals FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY referrals_insert_own ON referrals FOR INSERT WITH CHECK (auth.uid() = user_id);

ALTER TABLE social_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY social_settings_select_own ON social_settings FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY social_settings_insert_own ON social_settings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY social_settings_update_own ON social_settings FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE sync_cursors ENABLE ROW LEVEL SECURITY;
CREATE POLICY sync_cursors_select_own ON sync_cursors FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY sync_cursors_insert_own ON sync_cursors FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY sync_cursors_update_own ON sync_cursors FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY sync_cursors_delete_own ON sync_cursors FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE sync_tombstones ENABLE ROW LEVEL SECURITY;
CREATE POLICY sync_tombstones_select_own ON sync_tombstones FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY sync_tombstones_insert_own ON sync_tombstones FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY sync_tombstones_update_own ON sync_tombstones FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY sync_tombstones_delete_own ON sync_tombstones FOR DELETE USING (auth.uid() = user_id);
