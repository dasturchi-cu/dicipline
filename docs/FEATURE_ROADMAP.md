# REJABON AI — Feature Roadmap

**Document:** Phased delivery + Retention Engine + Top 20 priorities  
**Version:** 2.1  
**Date:** 2026-06-21  
**Canonical strategy:** `../PRODUCT_STRATEGY.md`

---

## 1. Roadmap Overview

```
V1.5 MVP+     V1.6 Retention   V2 Growth        V3 Platform       V4 Network
(8 weeks)     (4 weeks)        (12 weeks)       (16 weeks)        (20 weeks)
─────────     ────────────     ──────────       ───────────       ──────────
Wire loops    Dashboard 2.0    Future Self      Supabase sync     Social
Mood analytics Daily briefing  Focus/Pomodoro   Auth + RLS        Leaderboards
Unified coach  Life heatmap     Unified analytics Multi-device     Referrals
RPG backup     Emergency mode   Life Brain L2    Premium billing   Share cards
               AI memory 🟡     Anti-procrast    Retention cloud   Voice premium
               Predictions 🟡   LLM briefing     Boss challenges
```

**Current position:** V1.5 ✅ complete · V1.6 🟡 partial (8/12 retention systems shipped) · V2 in progress.

---

## 2. Version Definitions

### V1.5 — MVP+ (Life Loop Wired) ✅

**Goal:** Make existing features feel like one product.  
**Status:** Complete — 57/57 tests passing.

| Feature | Priority | Status |
|---------|----------|--------|
| Wire analytics insights → actions | P0 | ✅ |
| Mood trend service + chart | P0 | ✅ |
| RPG backup fix | P0 | ✅ |
| Time logs → life area scores | P0 | ✅ |
| Unified coach context | P0 | ✅ |
| Dashboard slim (today strip + coach) | P0 | ✅ |
| Finance in Hayot hub | P1 | ✅ |
| Capture → inbox snackbar CTA | P1 | ✅ |

### V1.6 — Retention Engine 🟡 (Partial)

**Goal:** Build daily reopen habit — "AI Life OS users cannot stop using."  
**Ship criteria:** Dashboard 2.0 live; briefing + heatmap + emergency + XP overlay; tests green.

| Feature | Priority | Retention | Status | Code |
|---------|----------|-----------|--------|------|
| Dashboard 2.0 | P0 | Critical | ✅ | `dashboard_screen.dart` |
| Daily AI Briefing | P0 | Critical | ✅ rule | `daily_briefing_service.dart` |
| Life Heatmap (365d) | P0 | Very High | ✅ | `life_heatmap_service.dart` |
| Future Prediction Engine | P0 | High | 🟡 | `future_prediction_engine.dart` |
| Emotion Intelligence | P0 | Very High | 🟡 | `emotion_intelligence_service.dart` |
| Emergency Mode | P0 | High | ✅ | `/favqulodda` |
| AI Memory System | P0 | Very High | 🟡 | `memory_retriever.dart`, `/boshqa/xotira` |
| Second Brain Q&A | P1 | High | 🟡 | `second_brain_qa_service.dart` |
| Voice AI Assistant | P1 | High | 🟡 | STT only — `/boshqa/murabbiy/ovoz` |
| Life Character / RPG | P0 | Very High | ✅ | `/qahramon` |
| Achievement Showcase | P1 | High | ✅ | `/qahramon/yutuqlar` |
| Dopamine Reward System | P0 | Critical | ✅ | `xp_reward_overlay.dart` |

**V1.6 remaining (before V2 gate):**

| Feature | Priority | Effort |
|---------|----------|--------|
| Morning briefing push notification | P0 | 3d |
| Emotion intervention push | P0 | 3d |
| Briefing LLM L2 | P0 | 5d |
| Memory LLM enrichment | P0 | 5d |
| Voice TTS | P1 | 3d |
| Level-up ceremony | P1 | 3d |
| Second Brain LLM RAG | P1 | 5d |

### V2 — Growth (Intelligence + Depth)

**Goal:** AI-first differentiation; emotional retention; anti-procrastination.

| Feature | Priority | Business | Retention | Complexity | Revenue | Status |
|---------|----------|----------|-----------|------------|---------|--------|
| Life Brain (full merge) | P0 | Very High | Very High | High | Premium | 🟡 |
| Future Letters (1mo–5yr) | P0 | High | Very High | Med | Premium | ❌ |
| Focus Mode + Pomodoro | P0 | High | High | Med | Premium | ❌ |
| AI procrastination intervention | P0 | High | Very High | High | Premium | ❌ |
| Unified Analytics Hub v2 | P0 | High | High | High | Premium | ❌ |
| Weekly AI review (enhanced CEO) | P0 | High | High | Med | — | 🟡 |
| Vision board | P1 | Med | High | Med | Premium | ❌ |
| 2-minute rule micro-tasks | P1 | Med | High | Low | — | ❌ |
| AI Journal emotion detection | P1 | High | High | High | Premium | ❌ |
| Focus stat (7th RPG attribute) | P1 | Med | High | Med | — | ❌ |
| Swipe inbox triage | P1 | Med | High | Med | — | ❌ |
| Achievement share cards | P1 | High | Med | Low | Viral | 🟡 |
| More hub curation (8 items) | P1 | Med | Med | Low | — | ❌ |

### V3 — Platform (Cloud + Scale)

| Feature | Priority | Status |
|---------|----------|--------|
| Supabase auth | P0 | ❌ |
| PostgreSQL sync | P0 | ❌ |
| Premium / Pro paywall | P0 | ❌ |
| Retention cloud tables (see DATABASE) | P1 | ❌ |
| AI Memory cloud backup | P1 | 🟡 local only |
| Boss challenges | P1 | ❌ |
| Skill tree | P1 | ❌ |

### V4 — Network (Social + Viral)

| Feature | Priority | Status |
|---------|----------|--------|
| Friends + accountability | P0 | ❌ |
| Group challenges | P0 | ❌ |
| Achievement sharing (viral) | P0 | 🟡 service exists |
| Referral rewards | P0 | ❌ |
| Leaderboards | P1 | 🟡 local only |
| Voice journal full pipeline | P1 | ❌ |

---

## 3. Recalculated Priority Matrix

**Formula:** `Score = Retention×4 + Business×3 + Loop×2 − Complexity×1`

| Rank | Feature | Score | Pri | Version | Status |
|------|---------|-------|-----|---------|--------|
| 1 | Morning briefing push | 96 | P0 | V1.6 | ❌ |
| 2 | Dashboard 2.0 | 95 | — | V1.6 | ✅ |
| 3 | Focus + Pomodoro | 94 | P0 | V2 | ❌ |
| 4 | Future Letters UI | 93 | P0 | V2 | ❌ |
| 5 | Life Brain full merge | 92 | P0 | V2 | 🟡 |
| 6 | Emotion push interventions | 91 | P0 | V1.6 | ❌ |
| 7 | Unified Analytics Hub | 90 | P0 | V2 | ❌ |
| 8 | Briefing LLM L2 | 89 | P0 | V1.6 | 🟡 |
| 9 | AI Memory LLM | 88 | P0 | V1.6 | 🟡 |
| 10 | Level-up ceremony | 87 | P1 | V1.6 | ❌ |
| 11 | Anti-procrastination banner | 86 | P0 | V2 | ❌ |
| 12 | Second Brain RAG | 85 | P1 | V1.6 | 🟡 |
| 13 | Heatmap in analytics | 84 | P1 | V2 | 🟡 |
| 14 | Voice TTS | 83 | P1 | V1.6 | ❌ |
| 15 | Achievement share | 82 | P1 | V2 | 🟡 |
| 16 | Weekly CEO LLM narrative | 81 | P1 | V2 | 🟡 |
| 17 | Swipe inbox triage | 80 | P1 | V2 | ❌ |
| 18 | Vision board | 78 | P1 | V2 | ❌ |
| 19 | More hub curation | 76 | P1 | V2 | ❌ |
| 20 | Premium paywall | 75 | P1 | V3 | ❌ |

---

## 4. Top 20 — Implementation Plan

### Sprint R2-S1 (Week 1) — Morning Hook

| Task | Owner | Files | Done when |
|------|-------|-------|-----------|
| Briefing push scheduler | Eng | `re_engagement_notification_service.dart` | 07:00 local fires |
| Deep link to dashboard | Eng | `app_router.dart` | Tap opens `/` briefing zone |
| Briefing content in push body | Eng | `daily_briefing_service.dart` | Top priority in notification |
| Settings toggle | Eng | `settings_provider.dart` | User can disable |

### Sprint R2-S2 (Week 2) — Emotion Delivery

| Task | Owner | Files | Done when |
|------|-------|-------|-----------|
| Burnout push trigger | Eng | `emotion_intelligence_service.dart` | mood decline + overdue → notify |
| Rest quest auto-create | Eng | `quest_service.dart` | Push CTA opens quest |
| Max 1 emotion push/day | Eng | notification helper | No spam |

### Sprint P2-S4 (Weeks 3–4) — Focus Mode

| Task | Owner | Files | Done when |
|------|-------|-------|-----------|
| `FocusSessionEntity` Isar | Eng | `focus_session_entity.dart` | Migration v6 |
| Pomodoro timer UI | Eng | `focus_mode_screen.dart` | 25/5 cycles |
| XP on session complete | Eng | `action_reward_bridge.dart` | Focus stat XP |
| Dashboard link | Eng | coach intervention | Avoidance → focus CTA |

### Sprint P2-S3 (Weeks 5–6) — Future Self

| Task | Owner | Files | Done when |
|------|-------|-------|-----------|
| Letter creation flow | Eng | `future_letter_screen.dart` | 1mo–5yr horizons |
| Snapshot on write | Eng | `future_letter_service.dart` | level, mood, goals saved |
| Unlock ceremony | Eng | `letter_unlock_screen.dart` | Push + compare UI |
| Hayot hub link | Eng | `life_hub_screen.dart` | Kelajak tab visible |

### Sprint P2-S2 (Weeks 7–8) — Analytics Hub

| Task | Owner | Files | Done when |
|------|-------|-------|-----------|
| `AnalyticsHubScreen` 5 tabs | Eng | new screen | Hayot, Kayfiyat, Heatmap, Vaqt, Korrelatsiya |
| Migrate time analytics | Eng | router redirect | Old route → tab |
| InsightCard on all insights | Eng | `analytics_screen.dart` | 0 dead ends |
| Heatmap tab (full 365d) | Eng | `LifeHeatmapWidget` | Dashboard keeps mini |

### Parallel — Intelligence Depth

| Task | Sprint | Files |
|------|--------|-------|
| Briefing LLM L2 | R2-S3 | `daily_briefing_service.dart` + orchestrator |
| Memory nightly enrich | R2-S3 | `ai_memory_sync.dart` + LLM |
| Life Brain provider merge | P2-S1 | `intelligence_providers.dart` |
| Level-up ceremony | R2-S4 | `level_up_overlay.dart` |
| Voice TTS | R2-S4 | `voice_ai_service.dart` + flutter_tts |
| Second Brain RAG | R2-S5 | `second_brain_qa_service.dart` + embeddings |

---

## 5. Fifty WOW Features — Status Update

Rules: Must increase DAU, retention, or revenue. 🤖 = AI-first.

### Retention Engine (NEW — R1–R12)

| # | Feature | Status |
|---|---------|--------|
| R1 | 🤖 AI Memory persistent | 🟡 |
| R2 | 🤖 Daily AI Briefing | ✅ |
| R3 | Life Heatmap 365d | ✅ |
| R4 | 🤖 Future Predictions | 🟡 |
| R5 | 🤖 Emotion Intelligence | 🟡 |
| R6 | Second Brain Q&A | 🟡 |
| R7 | 🤖 Voice AI commands | 🟡 |
| R8 | Emergency Mode | ✅ |
| R9 | Life Character RPG | ✅ |
| R10 | Achievement Showcase | ✅ |
| R11 | Dopamine XP overlay | ✅ |
| R12 | Dashboard 2.0 | ✅ |

### Capture & Intelligence (1–10)

| # | Feature | Status |
|---|---------|--------|
| 1 | Smart Capture classify | ❌ |
| 2 | Inbox Zero Coach | 🟡 badge only |
| 3 | Universal Search | 🟡 second brain |
| 4 | Context Snap OCR | ❌ |
| 5 | Meeting Debrief | ❌ |
| 6 | Quick Voice Task | ✅ voice route |
| 7 | Duplicate Detector | ❌ |
| 8 | Priority Oracle | 🟡 briefing priorities |
| 9 | Swipe Triage | ❌ |
| 10 | Commitment Extractor | ❌ |

### Coach & AI (11–20)

| # | Feature | Status |
|---|---------|--------|
| 11 | Evidence Tips | 🟡 Life Brain |
| 12 | Stress Day Protocol | 🟡 emotion service |
| 13 | Weekly Narrative | 🟡 CEO partial |
| 14 | Goal Drift Alert | ✅ Life Brain |
| 15 | Energy Matching | ❌ |
| 16 | Accountability Reply | ❌ |
| 17 | Monthly Life Letter | ❌ |
| 18 | Burnout Guard | 🟡 emotion + emergency |
| 19 | Celebration Moments | 🟡 XP overlay |
| 20 | Coach Personality | ❌ |

### RPG & Gamification (21–30)

| # | Feature | Status |
|---|---------|--------|
| 21 | Daily Quest Board | ✅ |
| 22 | Weekly Boss | ❌ V3 |
| 23 | Skill Tree | ❌ V3 |
| 24 | Streak Shield | ❌ Premium |
| 25 | Stat Decay | ❌ |
| 26 | Level-Up Ceremony | ❌ |
| 27 | Rare Drops | ❌ |
| 28 | Class System | ❌ |
| 29 | Guild Quests | ❌ V4 |
| 30 | Season Pass | ❌ |

### Analytics & Prediction (31–38)

| # | Feature | Status |
|---|---------|--------|
| 31 | Life Score | ✅ |
| 32 | Domain Radar | 🟡 life areas |
| 33 | Trend Predictions | ✅ strip |
| 34 | Correlation Cards | 🟡 partial |
| 35 | Heatmap Calendar | ✅ |
| 36 | Time ROI | 🟡 |
| 37 | Anomaly Detection | ❌ |
| 38 | Export CEO Report | ❌ |

### Future Self & Emotional (39–44)

| # | Feature | Status |
|---|---------|--------|
| 39 | Future Letters | 🟡 service only |
| 40 | Vision Board | ❌ |
| 41 | Dream Timeline | ❌ |
| 42 | Future Message AI | ❌ |
| 43 | Milestone Time Capsule | ❌ |
| 44 | Regret Minimization | ❌ |

### Anti-Procrastination (45–48)

| # | Feature | Status |
|---|---------|--------|
| 45 | Focus Mode | ❌ |
| 46 | Pomodoro | ❌ |
| 47 | 2-Minute Rule | ❌ |
| 48 | Avoidance Interventions | ❌ |

### Social & Viral (49–50)

| # | Feature | Status |
|---|---------|--------|
| 49 | Challenge a Friend | ❌ V4 |
| 50 | Achievement Share | 🟡 ShareCardService |

---

## 6. Deprecation List

| Feature | Action | Version |
|---------|--------|---------|
| 11-card dashboard layout | Replaced by Dashboard 2.0 | V1.6 ✅ |
| Unused dashboard widgets | Delete or wire | V2 |
| QuickAddSheet | Deprecate (Capture wins) | V1.5 ✅ |
| Isolated `/reja` only entry | Merge to dashboard | V2 |
| AiMemory unwired | Wired via retriever | V1.6 ✅ |
| Prediction engine V4-only | Moved to V1.6 | ✅ |

---

## 7. Release Cadence

| Cadence | Content |
|---------|---------|
| Weekly | Bug fixes, retention polish |
| Bi-weekly | One loop-improvement or push notification |
| Monthly | Themed release (Retention month, Future Self month) |
| Quarterly | Major version bump |

---

## 8. Risk Register

| Risk | Mitigation |
|------|------------|
| Retention sprawl on dashboard | Zone collapse after analytics hub; max 8 zones |
| Push notification fatigue | Max 3/day; user toggles per type |
| Rule-based AI shallow | LLM L2 with rule fallback always |
| Feature creep | Life loop gate on every PR |
| AI cost | Rule-first; LLM quotas; Premium unlimited |

---

*See `PRODUCT_STRATEGY.md` §31–32, `DATABASE_ARCHITECTURE.md` §4.5, `UI_UX_REDESIGN.md` §6.7 for Dashboard 2.0 spec.*
