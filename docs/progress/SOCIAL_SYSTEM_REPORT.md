# Social & Viral Growth System Report

**Date:** 2026-06-21  
**Status:** Production-ready (local-first baseline)

---

## Overview

The Social & Viral Growth System transforms the Phase 2 social skeleton into a premium, motivating hub with accountability partners, friend/group challenges, share cards, weekly leaderboards, referral rewards, privacy controls, and Premium integration.

Architecture remains **offline-first (Isar)** — designed for viral loops on-device with cloud sync as a future upgrade path.

---

## Features Implemented

### 1. Accountability Partners ✅
| Component | Path |
|-----------|------|
| Entity | `partnership_entity.dart` (privacy flags wired) |
| Service | `social_service.dart` — connect, check-in, summaries, remove |
| UI | Social Hub → **Hamkorlar** tab |

- Partner summaries with days connected + check-in state
- Daily check-in XP (+30, once/day)
- Connect XP (+50)
- Cannot connect with own code
- Referral recorded on successful connect

### 2. Friend Challenges ✅
| Component | Path |
|-----------|------|
| Entity | `friend_challenge_entity.dart` |
| Service | `friend_challenge_service.dart` |
| UI | **Musobaqalar** tab |

Templates: Streak duel, Task sprint, Habit race  
1v1 progress tracking with partner sync on check-in

### 3. Group Challenges ✅
| Component | Path |
|-----------|------|
| Entity | `group_challenge_entity.dart` |
| Service | `group_challenge_service.dart` |

Templates: Team streak, Group tasks, Wellness week  
Free: 5 members · Premium: 10 members

### 4. Achievement Sharing ✅
- Tap unlocked achievement on **Qahramon** screen → share text card
- `ShareCardService` with branded format + `#REJABONAI`

### 5. Streak Sharing ✅
- Leaderboard shows streak highlights when privacy allows
- Share card infrastructure supports streak stat lines
- Privacy toggle: `shareStreaks`

### 6. Referral System ✅
| Component | Path |
|-----------|------|
| Entity | `referral_entity.dart` |
| Service | `referral_service.dart` |

- Tracks referrals on partner connect
- Milestone tiers: 1 / 3 / 5 invites
- Rich share message with invite code

### 7. Invite Rewards ✅
- +100 XP per referral (×1.5 Premium multiplier)
- Every 3 referrals → Premium trial credit (3 days)
- Referral stats tab: total invites, XP earned, next milestone

### 8. Share Cards ✅
| Component | Path |
|-----------|------|
| Service | `share_card_service.dart` |

- Visual gradient cards via `RepaintBoundary` → PNG share
- Text fallback if image capture fails
- Premium gradient variant for subscribers

### 9. Weekly Leaderboards ✅
| Component | Path |
|-----------|------|
| Service | `leaderboard_service.dart` |

**Non-toxic design:**
- Encouragement messages, not shame
- Community message adapts to rank
- Privacy: hide from leaderboard entirely
- Anonymous alias option

### 10. Privacy Controls ✅
| Component | Path |
|-----------|------|
| Entity | `social_settings_entity.dart` |
| UI | `social_privacy_sheet.dart` |

Toggles: leaderboard visibility, streak/achievement sharing, friend challenges, group invites, anonymous mode

### 11. Premium Integration ✅
| Component | Path |
|-----------|------|
| Service | `premium_service.dart` (SharedPreferences) |

- Premium badge in Social Hub
- 10-member groups (vs 5 free)
- Premium share card styling
- 1.5× referral XP multiplier
- Auto 3-day Premium after 3 referral credits

---

## Database

- Schema version: **5**
- New collections: `ReferralEntity`, `FriendChallengeEntity`, `GroupChallengeEntity`, `SocialSettingsEntity`
- Migration: `social_viral_system_ready` — see `docs/migrations/v4_to_v5.md`
- Backup version: **1.2.0** (social collections included)

---

## Navigation

Route: `/boshqa/ijtimoiy`  
More hub → **Ijtimoiy** (Phase 2 section)

Tabs: Hamkorlar · Musobaqalar · Reyting · Takliflar

---

## Providers

`lib/features/social/presentation/providers/social_providers.dart`

Bootstrap: `runSocialBootstrap()` called from Phase 2 bootstrap

---

## Tests

| File | Coverage |
|------|----------|
| `leaderboard_service_test.dart` | Non-toxic board, privacy |
| `share_card_service_test.dart` | Share text format |

---

## UX Redesign Summary

| Before | After |
|--------|-------|
| Single scroll list | 4-tab premium hub with hero |
| Plain invite code row | Share card + copy + text + image share |
| No privacy | Full privacy bottom sheet |
| No challenges | Friend + group challenge flows |
| No leaderboard | Weekly encouraging rankings |
| No referral stats | Milestone progress + Premium upsell |

---

## Known Limitations (V3+)

- No cloud sync — partners/challenges are local records
- Partner progress is estimated from check-ins (not live sync)
- Premium is local flag (no App Store billing yet)
- Deep links / attribution not implemented

---

## Viral Growth Loop

```
Share invite card → Friend installs → Enters code → Partner connect
  → Referral XP + milestone → Premium trial → Expanded group challenges
  → Share achievement/streak → Repeat
```
