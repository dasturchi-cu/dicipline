-- REJABON AI — triggers
-- Source: DATABASE_ARCHITECTURE.md §10

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Tables with sync_version → touch_updated_at()
CREATE TRIGGER trg_profiles_updated
  BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_devices_updated
  BEFORE UPDATE ON devices FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_subscriptions_updated
  BEFORE UPDATE ON subscriptions FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();

CREATE TRIGGER trg_tasks_updated
  BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_habits_updated
  BEFORE UPDATE ON habits FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_goals_updated
  BEFORE UPDATE ON goals FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_goal_milestones_updated
  BEFORE UPDATE ON goal_milestones FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_notes_updated
  BEFORE UPDATE ON notes FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_journal_entries_updated
  BEFORE UPDATE ON journal_entries FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_documents_updated
  BEFORE UPDATE ON documents FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_inbox_items_updated
  BEFORE UPDATE ON inbox_items FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_finance_transactions_updated
  BEFORE UPDATE ON finance_transactions FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_workouts_updated
  BEFORE UPDATE ON workouts FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_study_subjects_updated
  BEFORE UPDATE ON study_subjects FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_study_sessions_updated
  BEFORE UPDATE ON study_sessions FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_calendar_events_updated
  BEFORE UPDATE ON calendar_events FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_plans_updated
  BEFORE UPDATE ON plans FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_plan_items_updated
  BEFORE UPDATE ON plan_items FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_monthly_focus_updated
  BEFORE UPDATE ON monthly_focus FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_time_logs_updated
  BEFORE UPDATE ON time_logs FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_milestones_updated
  BEFORE UPDATE ON milestones FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_challenges_updated
  BEFORE UPDATE ON challenges FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();

CREATE TRIGGER trg_player_profiles_updated
  BEFORE UPDATE ON player_profiles FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_quests_updated
  BEFORE UPDATE ON quests FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_skill_nodes_updated
  BEFORE UPDATE ON skill_nodes FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_boss_challenges_updated
  BEFORE UPDATE ON boss_challenges FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_coach_memories_updated
  BEFORE UPDATE ON coach_memories FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_coach_commitments_updated
  BEFORE UPDATE ON coach_commitments FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_coach_preferences_updated
  BEFORE UPDATE ON coach_preferences FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_twin_profiles_updated
  BEFORE UPDATE ON twin_profiles FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();

CREATE TRIGGER trg_future_letters_updated
  BEFORE UPDATE ON future_letters FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER trg_vision_board_items_updated
  BEFORE UPDATE ON vision_board_items FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_action_plans_updated
  BEFORE UPDATE ON action_plans FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TRIGGER trg_focus_sessions_updated
  BEFORE UPDATE ON focus_sessions FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_friendships_updated
  BEFORE UPDATE ON friendships FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_partnerships_updated
  BEFORE UPDATE ON partnerships FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_friend_challenges_updated
  BEFORE UPDATE ON friend_challenges FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_group_challenges_updated
  BEFORE UPDATE ON group_challenges FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();
CREATE TRIGGER trg_social_settings_updated
  BEFORE UPDATE ON social_settings FOR EACH ROW EXECUTE FUNCTION touch_updated_at_simple();

-- Soft-delete → sync tombstone
CREATE OR REPLACE FUNCTION record_sync_tombstone()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL THEN
    INSERT INTO sync_tombstones (user_id, table_name, record_id, local_id, device_id)
    VALUES (NEW.user_id, TG_TABLE_NAME, NEW.id, NEW.local_id, NEW.device_id)
    ON CONFLICT (user_id, table_name, record_id)
      DO UPDATE SET deleted_at = EXCLUDED.deleted_at;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_tasks_tombstone
  BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_habits_tombstone
  BEFORE UPDATE ON habits FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_goals_tombstone
  BEFORE UPDATE ON goals FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_notes_tombstone
  BEFORE UPDATE ON notes FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_journal_entries_tombstone
  BEFORE UPDATE ON journal_entries FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_documents_tombstone
  BEFORE UPDATE ON documents FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_inbox_items_tombstone
  BEFORE UPDATE ON inbox_items FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_finance_transactions_tombstone
  BEFORE UPDATE ON finance_transactions FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_workouts_tombstone
  BEFORE UPDATE ON workouts FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_study_subjects_tombstone
  BEFORE UPDATE ON study_subjects FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_calendar_events_tombstone
  BEFORE UPDATE ON calendar_events FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_plans_tombstone
  BEFORE UPDATE ON plans FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_time_logs_tombstone
  BEFORE UPDATE ON time_logs FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_coach_memories_tombstone
  BEFORE UPDATE ON coach_memories FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_coach_commitments_tombstone
  BEFORE UPDATE ON coach_commitments FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_future_letters_tombstone
  BEFORE UPDATE ON future_letters FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_vision_board_items_tombstone
  BEFORE UPDATE ON vision_board_items FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
CREATE TRIGGER trg_action_plans_tombstone
  BEFORE UPDATE ON action_plans FOR EACH ROW EXECUTE FUNCTION record_sync_tombstone();
