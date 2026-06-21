# Migration v4 → v5 (Social & Viral Growth)

**Version:** 5  
**Date:** 2026-06-21

## New Collections

- `ReferralEntity` — invite tracking and reward milestones
- `FriendChallengeEntity` — 1v1 challenge progress
- `GroupChallengeEntity` — team challenge progress
- `SocialSettingsEntity` — privacy and sharing preferences

## Features Enabled

- Accountability partners (enhanced)
- Friend & group challenges
- Achievement & streak sharing cards
- Weekly non-toxic leaderboards
- Referral system & invite rewards
- Premium social integration
- Privacy controls

## Migration step

`social_viral_system_ready` — version bump only; Isar auto-creates collections.

## Backup format

Backup version bumped to **1.2.0** with optional keys: `referrals`, `friendChallenges`, `groupChallenges`, `socialSettings`. Older backups (1.0.0 / 1.1.0) restore without social data.
