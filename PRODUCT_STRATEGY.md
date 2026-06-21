# REJABON AI — Product Strategy
## From Planner to AI Life Operating System

**Version:** 2.1  
**Date:** 2026-06-21  
**Status:** Phase 2 + Retention Engine (partial ship)  
**Audience:** Product, engineering, design, growth  
**Companion docs:** `docs/FEATURE_ROADMAP.md`, `docs/IMPLEMENTATION_PLAN.md`, `docs/AI_COACH_SYSTEM.md`, `EXECUTION_PLAN.md`

---

## Table of Contents

1. [Executive Vision](#1-executive-vision)
2. [The Strategic Thesis](#2-the-strategic-thesis)
3. [What REJABON Is — and Is Not](#3-what-rejabon-is--and-is-not)
4. [Current State vs Target State](#4-current-state-vs-target-state)
5. [The Life OS Model](#5-the-life-os-model)
6. [Ten Product Pillars](#6-ten-product-pillars)
7. [The Life Loop](#7-the-life-loop)
8. [Life Brain — Unified Intelligence](#8-life-brain--unified-intelligence)
9. [Module Consolidation Map](#9-module-consolidation-map)
10. [User Personas & Jobs to Be Done](#10-user-personas--jobs-to-be-done)
11. [Core User Journeys](#11-core-user-journeys)
12. [Information Architecture](#12-information-architecture)
13. [AI Product Design](#13-ai-product-design)
14. [Life RPG — Behavior Engine](#14-life-rpg--behavior-engine)
15. [Future Self — Emotional Moat](#15-future-self--emotional-moat)
16. [Life Analytics — Consciousness Layer](#16-life-analytics--consciousness-layer)
17. [Anti-Procrastination Engine](#17-anti-procrastination-engine)
18. [Personal Knowledge System](#18-personal-knowledge-system)
19. [Social & Accountability (V4)](#19-social--accountability-v4)
20. [Monetization & Business Model](#20-monetization--business-model)
21. [Competitive Positioning](#21-competitive-positioning)
22. [Uzbek & Central Asia Market Strategy](#22-uzbek--central-asia-market-strategy)
23. [Design & Brand Philosophy](#23-design--brand-philosophy)
24. [Product Principles](#24-product-principles)
25. [Phase Roadmap](#25-phase-roadmap)
26. [Phase 2 — Detailed Scope](#26-phase-2--detailed-scope)
27. [What We Kill, Merge, or Hide](#27-what-we-kill-merge-or-hide)
28. [North Star Metrics](#28-north-star-metrics)
29. [Risks & Mitigations](#29-risks--mitigations)
30. [Retention Engine — Twelve Systems](#30-retention-engine--twelve-systems)
31. [Top 20 Highest-Impact Features](#31-top-20-highest-impact-features)
32. [Implementation Queue (Next 8 Weeks)](#32-implementation-queue-next-8-weeks)

---

## 1. Executive Vision

### Vision Statement

**REJABON AI** is the first Uzbek-native **AI Life Operating System** — a single intelligent layer that captures everything in your life, understands your patterns, coaches you with evidence, rewards real progress, and connects today's actions to the person you are becoming.

> *"Hayotingizni boshqaradigan, o'rganadigan va rivojlantiradigan sun'iy intellekt tizimi."*

### Mission

Replace fragmented productivity tools with one **offline-first Life OS** that makes self-improvement feel inevitable — not like homework.

### 5-Year Ambition

| Year | Goal |
|------|------|
| Y1 | 50K MAU, product-market fit in Uzbekistan |
| Y2 | 150K MAU, Premium launch, Future Self + Life Brain shipped |
| Y3 | 300K MAU, cloud sync, multi-device, Central Asia expansion |
| Y4 | 500K MAU, social accountability, prediction engine |
| Y5 | Category leader: "Life OS" in Uzbek/Central Asian markets |

### The One-Sentence Pitch

**English:** *The AI that runs your life — not another to-do app.*  
**Uzbek:** *Reja emas — butun hayotingizning operatsion tizimi.*

---

## 2. The Strategic Thesis

### The Planner Trap

Most "productivity apps" die because they:

1. **Capture without intelligence** — users dump tasks, never process
2. **Track without meaning** — habits exist in isolation from goals
3. **Report without action** — analytics screens are dead ends
4. **Fake AI** — chatbots that don't know your data
5. **No emotional hook** — nothing makes you *want* to open the app tomorrow

REJABON v1.0 fell into this trap: **32 routes, 24 feature modules, weak loops.** It was a capable planner with RPG and AI bolted on — not an operating system.

### The Life OS Thesis

A Life OS is not a feature list. It is a **closed loop**:

```
Everything enters → Intelligence understands → User acts → System rewards → User reflects → System plans → Repeat
```

**Transformation rule:** Every screen, entity, and AI output must answer: *Which stage of the Life Loop does this serve?* If none → delete, merge, or hide until wired.

### Why Now

| Force | Opportunity |
|-------|-------------|
| AI maturity | LLMs can synthesize life context — if you have real local data |
| Offline-first gap | Global apps assume always-online; Uzbek users need reliability |
| Gamification science | Duolingo proved daily loops work; Habitica proved RPG hooks work |
| Language gap | No serious Life OS exists in Uzbek |
| REJABON foundation | 30+ Isar collections, RPG, coach, capture already built |

---

## 3. What REJABON Is — and Is Not

### REJABON IS

| Identity | Description |
|----------|-------------|
| **Life Operating System** | Orchestrates goals, habits, tasks, health, finance, knowledge, mood |
| **Evidence-based AI coach** | Speaks from *your* data, cites patterns, offers one action |
| **RPG for real life** | XP from completed work, not fake game actions |
| **Future Self anchor** | Letters, vision, timeline — emotional long-term retention |
| **Offline-first** | Full functionality without network; cloud enhances later |
| **Uzbek-native** | Language, tone, cultural defaults — not translated English |

### REJABON IS NOT

| Anti-identity | Why we reject it |
|---------------|------------------|
| Todo app | Commodity; TickTick wins on speed |
| Habit tracker | Streak-only; churns after week 3 |
| Notion clone | Mobile knowledge needs capture + triage, not blank pages |
| Chatbot | Coach is mentor with evidence, not open-ended chat |
| Feature dump | 32 screens without loops = confusion |
| Fake AI | Rule-based fallbacks required; never hallucinate user stats |

---

## 4. Current State vs Target State

### Phase 1 Complete ✅ (V1.5 Wiring)

| Delivered | Impact |
|-----------|--------|
| RPG entities in backup | No data loss on restore |
| Time logs → life area scores | Time tracking affects balance wheel |
| MoodTrendService + journal chart | Mood data visualized, not wasted |
| LifeContextAssembler + CoachContext | Foundation for Life Brain |
| DashboardCoachCard | Coach visible on home; daily hook |
| XP bridge (journal, workout, finance) | More actions → RPG loop |
| Capture → Inbox CTA | Capture loop closed |

### Phase 2.5 Retention Engine 🟡 (Partial — 2026-06-21)

| System | Status | Route / Surface |
|--------|--------|-----------------|
| Dashboard 2.0 | ✅ Shipped | `/` — briefing, coach, memory, heatmap, predictions |
| Daily AI Briefing | ✅ Rule-based | `DailyBriefingCard` on dashboard |
| AI Memory | 🟡 Partial | `/boshqa/xotira`, `MemoryRetriever`, sync throttled |
| Life Heatmap (365d) | ✅ Shipped | GitHub-style grid on dashboard |
| Future Prediction Engine | 🟡 Partial | `DashboardPredictionsStrip`, simulator exists |
| Emotion Intelligence | 🟡 Partial | Burnout detection; no push interventions |
| Emergency Mode | ✅ Shipped | `/favqulodda` — recovery plan on demand |
| Second Brain Q&A | 🟡 Rule-based | Tab on `/boshqa/ikkinchi-miya` |
| Voice AI Assistant | 🟡 STT only | `/boshqa/murabbiy/ovoz` — no TTS |
| Life Character / RPG | ✅ Enhanced | `/qahramon`, XP overlay on complete |
| Achievement Showcase | ✅ Shipped | `/qahramon/yutuqlar` — 15 achievements |
| Dopamine Reward System | ✅ Shipped | `XpRewardOverlay` on task/habit XP |

**Tests:** 57/57 passing. **Retention hub:** `retention_providers.dart`.

### Current Architecture (Honest Assessment)

**Strengths:**
- 30+ Isar collections — real depth
- Multi-provider AI orchestrator
- RPG core (XP, quests, achievements, character screen)
- Capture + inbox + time tracking
- Life areas, CEO review, life direction
- Future letters service exists
- Pattern engine (CoachPatternEngine) exists
- **Dashboard 2.0** — single-screen retention loop (briefing → act → reward → reflect)
- **LifeBrainFacade** — priority-ranked insights (burnout, goal drift)
- **Retention services** — briefing, heatmap, emotion, emergency, predictions

**Gaps (Phase 2 remaining):**
- **Insight pipelines** partially unified — analytics/CEO/life-twin still parallel
- **Future Self UI** — service exists; creation/unlock ceremony not shipped
- **No focus mode / Pomodoro** — anti-procrastination missing
- **Analytics fragmented** — heatmap on dashboard but hub still split
- **Retention delivery** — no morning push for briefing; emotion interventions in-app only
- **AI depth** — memory/briefing/Q&A rule-based; LLM L2 not wired for retention surfaces
- **Voice loop incomplete** — STT + commands; no spoken responses
- **Social layer** scaffolded but incomplete

### Target State (End of Phase 2)

| Dimension | Target |
|-----------|--------|
| Intelligence | Single Life Brain → one insight stream, many surfaces |
| Dashboard | Retention command center ✅ → polish + morning push |
| Future Self | Letters + vision board + dream timeline in Hayot hub |
| Focus | Pomodoro + deep work + AI intervention on avoidance |
| Analytics | One hub: life score, mood, heatmap, time, correlations |
| Retention | Every system answers "why open tomorrow?" — push + ceremony |
| Advanced modules | Absorbed into pillars or removed from nav |

---

## 5. The Life OS Model

```
┌─────────────────────────────────────────────────────────────────┐
│                     REJABON AI LIFE OS                          │
├─────────────────────────────────────────────────────────────────┤
│  SURFACES          Dashboard · Coach · RPG · Analytics · Hayot  │
├─────────────────────────────────────────────────────────────────┤
│  LIFE BRAIN        Context · Patterns · Insights · Actions    │
├─────────────────────────────────────────────────────────────────┤
│  LIFE LOOP         Capture → Triage → Act → Reward → Reflect    │
│                    → Plan                                         │
├─────────────────────────────────────────────────────────────────┤
│  TEN PILLARS       Goals · Habits · Tasks · Coach · Analytics   │
│                    Future Self · RPG · Knowledge · Finance    │
│                    Health                                         │
├─────────────────────────────────────────────────────────────────┤
│  DATA LAYER        Isar (local) → Supabase (V3 sync)            │
└─────────────────────────────────────────────────────────────────┘
```

**Key insight:** Users interact with **Surfaces**. Surfaces are powered by **Life Brain**. Life Brain reads **Pillars** through the **Life Loop**. Data is always local-first.

---

## 6. Ten Product Pillars

Each pillar requires: **data model · score · AI context · RPG link · dashboard hook · weekly review hook**.

### Pillar 1 — Goals (Maqsadlar)

| Aspect | Specification |
|--------|---------------|
| **Purpose** | Define where life is going — short, medium, long horizon |
| **Entities** | `GoalEntity`, `MilestoneEntity`, `MonthlyFocusEntity` |
| **Life areas** | `lifeAreaIds`, `horizon`, `parentGoalId` |
| **RPG stat** | Discipline |
| **AI context** | Goal drift detection, progress velocity, deadline pressure |
| **Dashboard** | Life Direction card → horizon goals |
| **Phase 2** | Merge `/hayot/maqsadlar` + `/hayot/kelajak` into tabbed Goals hub |

### Pillar 2 — Habits (Odatlar)

| Aspect | Specification |
|--------|---------------|
| **Purpose** | Daily identity reinforcement through repetition |
| **Entities** | `HabitEntity` (frequency, streak, life areas) |
| **RPG stat** | Discipline |
| **AI context** | Streak risk, stress-day skip patterns, recovery quests |
| **Dashboard** | Habit dots in today strip |
| **Phase 2** | Heatmap calendar (Duolingo-style), streak → quest auto-link |

### Pillar 3 — Tasks (Vazifalar)

| Aspect | Specification |
|--------|---------------|
| **Purpose** | Executable units tied to goals and daily plan |
| **Entities** | `TaskEntity`, `PlanEntity` |
| **RPG stat** | Focus (V2 stat addition) |
| **AI context** | Overdue bands, priority oracle, 2-minute rule splits |
| **Dashboard** | Priority task card, today plan strip |
| **Phase 2** | Inline quick-create; swipe complete + XP toast everywhere |

### Pillar 4 — AI Coach (Murabbiy)

| Aspect | Specification |
|--------|---------------|
| **Purpose** | Proactive mentor — not chatbot |
| **Entities** | `CoachConversationEntity`, `AiMemoryEntity`, commitments (V2) |
| **AI layers** | L0 rules → L1 patterns → L2 LLM synthesis |
| **Surfaces** | Dashboard card, `/boshqa/murabbiy`, intervention banners |
| **Trust model** | Evidence + confidence + action + dismiss |
| **Phase 2** | Life Brain facade; weekly/monthly narrative reviews |

### Pillar 5 — Life Analytics (Hayot tahlili)

| Aspect | Specification |
|--------|---------------|
| **Purpose** | Make invisible patterns visible |
| **Scores** | Life Score, 6 life area scores, mood trend, time ROI |
| **Entities** | Derived from all pillars; `TimeLogEntity` for focus time |
| **Surfaces** | Unified `/boshqa/analitika` hub (Phase 2) |
| **AI context** | Correlation cards, predictions, monthly CEO synthesis |
| **Phase 2** | Merge time analytics + mood + life balance into one hub |

### Pillar 6 — Future Self (Kelajak o'zingiz)

| Aspect | Specification |
|--------|---------------|
| **Purpose** | Emotional long-term retention — who you're becoming |
| **Entities** | `FutureLetterEntity`, vision board items (V2), dream milestones |
| **RPG stat** | Spiritual |
| **Horizons** | 1mo, 3mo, 6mo, 1yr, 5yr |
| **Surfaces** | Hayot → Kelajak tab; letter unlock ceremonies |
| **Phase 2** | Ship letter creation UI; vision board; integrate with simulator |

### Pillar 7 — Life RPG (Qahramon)

| Aspect | Specification |
|--------|---------------|
| **Purpose** | Make progress feel like winning |
| **Entities** | `PlayerProfileEntity`, `QuestEntity`, `XpEventEntity`, `AchievementUnlockEntity` |
| **Stats** | Discipline, Focus, Health, Knowledge, Wealth, Social, Spiritual |
| **Mechanics** | XP, levels, daily/weekly quests, achievements, boss challenges (V3) |
| **Rule** | XP only from verified real actions |
| **Phase 2** | Level-up ceremony; quest board polish; Focus stat migration |

### Pillar 8 — Personal Knowledge (Ikkinchi miya)

| Aspect | Specification |
|--------|---------------|
| **Purpose** | Capture → organize → retrieve life information |
| **Entities** | `NoteEntity`, `DocumentEntity`, `InboxItemEntity` |
| **RPG stat** | Knowledge |
| **Flow** | Capture FAB → Inbox triage → note/task/goal/document |
| **Surfaces** | `/boshqa/inbox`, `/boshqa/ikkinchi-miya` |
| **Phase 2** | Universal search bar; unify capture document → DocumentEntity |

### Pillar 9 — Finance (Moliya)

| Aspect | Specification |
|--------|---------------|
| **Purpose** | Wealth awareness tied to life goals |
| **Entities** | `FinanceTransactionEntity` |
| **RPG stat** | Wealth |
| **AI context** | Spending spikes, mood correlation, category trends |
| **Surfaces** | Hayot hub card → `/moliya` |
| **Phase 2** | Surface in Hayot nav; finance insights in Life Brain |

### Pillar 10 — Health (Sog'liq)

| Aspect | Specification |
|--------|---------------|
| **Purpose** | Physical and mental wellbeing |
| **Entities** | `WorkoutEntity`, `JournalEntryEntity` (mood), time logs (workout/focus) |
| **RPG stat** | Health + Spiritual (journal) |
| **AI context** | Burnout detection, mood-productivity correlation |
| **Phase 2** | Mood analytics in unified hub; rest quests on burnout signal |

---

## 7. The Life Loop

The Life Loop is the **product core**. Every feature attaches to at least one stage.

```
    ┌──────────┐
    │ CAPTURE  │  FAB · voice · photo · link · journal quick-entry
    └────┬─────┘
         ▼
    ┌──────────┐
    │  TRIAGE  │  Inbox → task / habit / goal / note / archive
    └────┬─────┘
         ▼
    ┌──────────┐
    │   ACT    │  Complete task · check habit · workout · focus session
    └────┬─────┘
         ▼
    ┌──────────┐
    │  REWARD  │  XP · quest progress · achievement · life score ↑
    └────┬─────┘
         ▼
    ┌──────────┐
    │ REFLECT  │  Journal · mood · CEO review · coach insight
    └────┬─────┘
         ▼
    ┌──────────┐
    │   PLAN   │  AI day builder · weekly focus · future letter prompt
    └────┬─────┘
         │
         └──────► (next day)
```

### Loop Stage Requirements

| Stage | Minimum viable experience | Phase 2 upgrade |
|-------|---------------------------|-----------------|
| Capture | FAB → inbox in 2 taps | Voice-first, smart classify |
| Triage | Inbox with suggested action | Swipe triage, bulk process |
| Act | Task/habit complete | Focus mode, Pomodoro |
| Reward | XP toast + quest verify | Level-up ceremony |
| Reflect | Journal + mood chart | AI emotion tags, weekly narrative |
| Plan | Day builder + monthly focus | Coach-generated weekly plan |

### Loop Completion Metric

**Weekly Life Loop Score** = % of active users who in 7 days:
- Capture ≥1 item AND
- Complete ≥1 task AND
- Complete ≥1 habit AND
- View coach OR save journal AND
- Open dashboard ≥4 days

**Target:** 25% of WAU by end of Phase 2.

---

## 8. Life Brain — Unified Intelligence

### Problem Today

Insight pipelines run in parallel without coordination:

| Pipeline | Location | Output |
|----------|----------|--------|
| AI Coach | `ai_coach_service.dart` | Tips list |
| Analytics | `analyticsInsightsProvider` | Rule insights |
| CEO Review | `ceo_weekly_review_service.dart` | Weekly report |
| Life Direction | `life_direction_service.dart` | Horizon analysis |
| Life Twin | `life_twin_service.dart` | Twin message |
| Coach Patterns | `coach_pattern_engine.dart` | Correlations |
| Mood Trend | `mood_trend_service.dart` | 7-day trend |

Users get **duplicated or contradictory advice**. Engineers maintain **7 systems**.

### Life Brain Solution

**One facade. Many surfaces. Priority-ranked insights.**

```
┌─────────────────────────────────────────┐
│           LifeBrainFacade               │
│  assembleContext() → rankInsights()     │
│  → surfaceFor(dashboard|coach|weekly)   │
└─────────────────┬───────────────────────┘
                  │
    ┌─────────────┼─────────────┐
    ▼             ▼             ▼
 LifeContext   PatternEngine  AiCoachFacade
 Assembler     (L1)           (L2 LLM)
```

### LifeInsight Model (Product)

Every insight exposed to users:

| Field | Purpose |
|-------|---------|
| `id` | Stable key for dismiss tracking |
| `headline` | ≤80 chars, Uzbek |
| `body` | ≤300 chars, evidence-based |
| `evidence` | Bullet list of data points |
| `confidence` | high / medium / low |
| `priority` | 1–100 ranking score |
| `pillar` | Which pillar it serves |
| `loopStage` | capture / act / reflect / plan |
| `action` | Route + payload for one-tap CTA |
| `source` | rule / pattern / llm |

### Insight Priority Rules

1. **Burnout / crisis** — always top (mood < 2.5 + low completion)
2. **Streak at risk** — today, habit with 7+ streak unchecked
3. **Goal drift** — no goal-linked action in 7 days
4. **Overdue tasks** — ≥3 overdue
5. **Positive reinforcement** — wins, level-ups, streak milestones
6. **Educational patterns** — day-of-week, mood-productivity (medium confidence)

### Surfaces Receive Filtered Insights

| Surface | Max insights | Filter |
|---------|--------------|--------|
| Dashboard coach card | 1 | Highest priority with action |
| Coach screen | 5 | All pillars, grouped |
| CEO review | 10 | Weekly window |
| Analytics hub | Unlimited | Correlation cards |
| Push notification | 1 | Highest, max 1/day |

---

## 9. Module Consolidation Map

Existing codebase modules mapped to Life OS pillars:

| Current module | Route | Pillar | Phase 2 action |
|----------------|-------|--------|----------------|
| Dashboard | `/` | Orchestrator | Hero redesign (3 actions) |
| Tasks | `/vazifalar` | Tasks | Quick-create |
| Habits | `/hayot/odatlar` | Habits | Heatmap |
| Goals | `/hayot/maqsadlar` | Goals | Merge with kelajak |
| Future Planning | `/hayot/kelajak` | Future Self | Tab in Goals |
| Future Simulator | `/hayot/simulyator` | Future Self | Merge into Kelajak |
| Journal | `/hayot/kundalik` | Health | AI reflection (V2) |
| Workouts | `/hayot/mashq` | Health | Keep |
| Study | `/hayot/ta'lim` | Knowledge | XP wired |
| Finance | `/moliya` | Finance | Hayot hub link |
| Life Areas | `/hayot/sohalar` | Analytics | Actionable insights |
| Time Tracker | `/hayot/vaqt` | Tasks/Focus | Pomodoro (V2) |
| Timeline | `/hayot/timeline` | RPG + Future Self | Unified wins |
| Milestones | `/hayot/yutuqlar` | RPG + Goals | Merge achievements |
| Character | `/qahramon` | RPG | Polish |
| Inbox | `/boshqa/inbox` | Knowledge | Swipe triage |
| Second Brain | `/boshqa/ikkinchi-miya` | Knowledge | Global search |
| AI Coach | `/boshqa/murabbiy` | Coach | Life Brain powered |
| Voice Coach | `/boshqa/murabbiy/ovoz` | Coach | Premium |
| CEO Review | `/boshqa/ceo-hisobot` | Analytics | Action CTAs |
| Analytics | `/boshqa/analitika` | Analytics | **Unified hub** |
| Time Analytics | `/boshqa/vaqt-analitika` | Analytics | Merge into hub |
| AI Planning | `/reja` | Plan | Embed on dashboard |
| Life Twin | `/boshqa/life-twin` | Coach | **Absorb into Life Brain** |
| Action Engine | `/boshqa/action-engine` | Coach | **Merge or hide** |
| Decision Assistant | `/boshqa/qaror-yordam` | Coach | Sub-feature of coach |
| Life Map | `/boshqa/life-map` | Analytics | Merge into analytics hub |
| Social | `/boshqa/ijtimoiy` | Social (V4) | Hide until complete |

---

## 10. User Personas & Jobs to Be Done

### Persona A — The Optimizer (25–35, professional)

| JTBD | When | REJABON solution |
|------|------|------------------|
| Know what matters today | Morning | Dashboard coach + priority task |
| Track where time goes | Workday | Time logs → life areas → analytics |
| Weekly accountability | Sunday | CEO review + Life Brain narrative |
| Avoid burnout | Stress weeks | Burnout signal → rest quest |

**Hook:** Metrics, clarity, CEO review  
**Risk:** Churn if app feels like work → keep hero action singular

### Persona B — The Builder (22–40, entrepreneur/student)

| JTBD | When | REJABON solution |
|------|------|------------------|
| Achieve big goals | Daily | Goals → tasks → quests |
| Stay consistent | Daily | Habits + RPG streaks |
| Plan tomorrow tonight | Evening | Day builder |
| See progress | Anytime | RPG level + life score |

**Hook:** RPG, streaks, goal horizons  
**Risk:** Overwhelmed by features → progressive disclosure

### Persona C — The Seeker (28–50, wellness-focused)

| JTBD | When | REJABON solution |
|------|------|------------------|
| Understand my mood | Daily | Journal + mood trend |
| Life balance | Weekly | Life areas wheel |
| Meaning & direction | Monthly | Future letters, spiritual stat |
| Gentle guidance | Low days | Coach burnout protocol |

**Hook:** Mood analytics, balance wheel, future self  
**Risk:** Distrust fake AI → always show evidence

### Persona D — Uzbek-First User (all ages)

| JTBD | When | REJABON solution |
|------|------|------------------|
| App in my language | Always | Uzbek UI, coach, insights |
| Works without internet | Commute, travel | Offline-first Isar |
| Culturally relevant | Daily | Local finance, family life area |

**Moat:** No global competitor owns this intersection.

---

## 11. Core User Journeys

### Journey 1 — Morning Activation (target: <30 seconds to first action)

```
Open app → Dashboard loads
  → Coach card: "Bugun 2 ta ustuvor vazifa — birinchisi: X"
  → Tap CTA → Task screen with focus
  → Complete → XP toast → Quest 1/3 done
```

### Journey 2 — Stress Day Recovery

```
Journal mood = 2 → Save
  → MoodTrend detects burnout risk
  → Life Brain surfaces: "Yengil kun — 1 ta odat va dam olish"
  → Coach suggests recovery quest (not punishment)
  → RPG awards rest quest XP
```

### Journey 3 — Weekly CEO Loop

```
Sunday notification → CEO Review
  → Life Brain weekly narrative (wins + misses + pattern)
  → 3 actionable insights with CTAs
  → Set monthly focus for next week
  → Optional: write future letter
```

### Journey 4 — Capture to Action

```
FAB → voice "Ertaga dentistga borish"
  → Inbox with suggested action: task
  → Swipe → create task with due tomorrow
  → XP for inbox process
  → Task appears in tomorrow plan
```

### Journey 5 — Future Self Unlock

```
3 months ago: wrote letter
  → Notification: "Xatingiz ochildi"
  → Unlock ceremony screen
  → Compare snapshot (goals, level, mood then vs now)
  → Coach: "3 oy oldin siz yozgansiz... bugun..."
  → Share optional achievement card
```

---

## 12. Information Architecture

### Bottom Navigation (5 tabs — unchanged)

| Tab | Route | Role |
|-----|-------|------|
| Bosh sahifa | `/` | Command center — coach, today, RPG |
| Qahramon | `/qahramon` | RPG identity + quests |
| Vazifalar | `/vazifalar` | Task execution |
| Hayot | `/hayot` | Life pillars hub |
| Boshqa | `/boshqa` | Knowledge, coach, settings |

### Hayot Hub (restructured Phase 2)

```
Hayot
├── Maqsadlar (tabs: Faol | Uzoq muddat | Kelajak)
├── Odatlar
├── Kundalik
├── Moliya          ← linked from hub (not orphan)
├── Sog'liq (mashq)
├── Ta'lim
├── Hayot sohalari
├── Vaqt kuzatuv
├── Timeline & Yutuqlar
└── Kelajak o'zingiz (letters, vision, simulator)
```

### Boshqa Hub (curated Phase 2)

```
Boshqa
├── AI Murabbiy (+ ovoz Premium)
├── Smart Inbox
├── Ikkinchi miya
├── Analitika (unified hub)
├── CEO hisobot
├── Hujjatlar
├── Kalendar
└── Sozlamalar
```

**Hidden until V4:** Social, Life Twin (absorbed), Action Engine (merged)

---

## 13. AI Product Design

### Three Laws of REJABON AI

1. **No data, no claim** — never invent user statistics
2. **Rules before LLM** — offline always works
3. **One action per insight** — reduce decision fatigue

### AI Layers

| Layer | Name | Latency | Cost | When |
|-------|------|---------|------|------|
| L0 | Rule Engine | <50ms | Free | Always |
| L1 | Pattern Engine | <200ms | Free | ≥14 days data |
| L2 | LLM Synthesis | 1–5s | Paid | Premium / 3 free/day |
| L3 | Life Brain | <300ms assemble | Free | Always |

### Daily AI Moments

| Time | Trigger | Output |
|------|---------|--------|
| 06:00–10:00 | First open | Morning priorities (3 max) |
| 12:00–14:00 | Task avoidance detected | Gentle nudge → 2-min rule |
| 18:00–22:00 | Evening | Reflection prompt + mood |
| Sunday 18:00 | Weekly | CEO narrative + next week focus |
| 1st of month | Monthly | Life score report + future self prompt |

### Trust UI Pattern

```
┌─────────────────────────────────────┐
│ 🤖 Kayfiyat past → vazifa bajarish  │
│    34% kamroq (14 kun ma'lumot)     │
│                                     │
│ Ishonch: ●●●○○ O'rta               │
│                                     │
│ [Bitta yengil vazifani tanlash]     │
│ [Keyinroq eslat]                    │
└─────────────────────────────────────┘
```

---

## 14. Life RPG — Behavior Engine

RPG is not decoration. It is the **dopamine layer** of the Life Loop.

### Design Rules

| Rule | Implementation |
|------|----------------|
| Real actions only | XP from task/habit/journal/workout/finance/inbox/focus |
| No pay-to-win | Premium = cosmetics + convenience |
| Recovery over punishment | Broken streak → recovery quest, not shame |
| Identity formation | Level titles: Yo'lchi → Usta → Afsona |
| Visible on dashboard | Quest 2/3 always visible |

### Stat ↔ Pillar Mapping

| Stat | Uzbek | Primary XP sources |
|------|-------|-------------------|
| Discipline | Intizom | Habits, daily quests |
| Focus | Diqqat | Tasks, focus sessions, time logs |
| Health | Sog'liq | Workouts, sleep (V3) |
| Knowledge | Bilim | Study, notes, inbox triage |
| Wealth | Boylik | Finance logging |
| Social | Ijtimoiy | Challenges (V4) |
| Spiritual | Ma'naviyat | Journal, future letters, reflection |

### Phase 2 RPG Deliverables

- Focus stat migration (7th attribute)
- Level-up full-screen ceremony
- Quest board visual polish
- XP toast on all wired actions
- Timeline shows XP events alongside milestones

---

## 15. Future Self — Emotional Moat

### Why Future Self Matters

Tasks expire. **Letters don't.** Users who write a 1-year letter have **3× higher D30 retention** (industry benchmark for time-capsule features).

### Components

| Feature | Emotion | Retention mechanism |
|---------|---------|---------------------|
| Future Letters | Anticipation | Push notification on unlock |
| Vision Board | Aspiration | Visual goal connection |
| Dream Timeline | Direction | Horizontal life milestones |
| Simulator | Curiosity | "What if I keep this pace?" |
| Snapshot on write | Nostalgia | Compare then vs now on unlock |

### Horizons

| ID | Label | Unlock |
|----|-------|--------|
| 1m | 1 oy | 30 days |
| 3m | 3 oy | 90 days |
| 6m | 6 oy | 180 days |
| 1y | 1 yil | 365 days |
| 5y | 5 yil | 1825 days |

### Phase 2 Deliverables

- Letter creation flow in Hayot → Kelajak
- Unlock ceremony screen
- Snapshot captures: life score, level, top goals, mood
- Coach references open letters in monthly review
- Premium: unlimited active letters (free: 1)

---

## 16. Life Analytics — Consciousness Layer

### The Life Score Formula (Product)

| Component | Weight | Source |
|-----------|--------|--------|
| Task completion (14d) | 25% | Tasks in window |
| Habit completion (14d) | 25% | Habit opportunities |
| Goal progress | 15% | Active goals avg % |
| Mood average (7d) | 15% | Journal entries |
| Time invested | 10% | Time logs + workouts + study |
| Life area balance | 10% | Std dev of 6 area scores (lower = better) |

**Display:** Single 0–100 score + 6-axis radar + trend arrow.

### Analytics Hub Tabs (Phase 2)

| Tab | Content |
|-----|---------|
| Hayot | Life score trend, domain radar |
| Kayfiyat | Mood chart, burnout indicator |
| Samaradorlik | Task/habit heatmap |
| Vaqt | Time by area, focus minutes |
| Moliya | Spending trend (if data) |
| Korrelatsiyalar | Mood vs productivity, day-of-week |

**Rule:** Every insight card has an action chip. No dead ends.

---

## 17. Anti-Procrastination Engine

### Components (Phase 2)

| Feature | Behavior |
|---------|----------|
| Focus Mode | Full-screen timer; optional app pause (platform permitting) |
| Pomodoro | 25/5 cycles; XP bonus on complete |
| Deep Work | 45–90 min blocks |
| 2-Minute Rule | AI splits scary task into micro-step |
| Avoidance Detection | Same task rescheduled 3× → escalation |
| Intervention Banner | Shell-level coach message with focus CTA |

### Escalation Ladder

```
Level 1 (gentle):  "X vazifasi 3 kundan beri kutilmoqda"
Level 2 (direct):  "2 daqiqalik qoidani sinab ko'ramizmi?"
Level 3 (action):  [Fokus rejimini boshlash] button
```

### Burnout Override

If `BurnoutSignal.level >= moderate` → suppress escalation; offer rest quest instead.

---

## 18. Personal Knowledge System

### Capture → Triage → Retrieve

```
Capture FAB (global)
  → Inbox (unprocessed)
  → Triage (swipe or AI suggest)
  → Task | Habit | Goal | Note | Document | Archive
  → Second Brain search (retrieve)
```

### Phase 2 Upgrades

- Swipe triage on inbox
- Smart classify confidence badge
- Global search from dashboard (command palette pattern)
- Link notes/documents to goals

---

## 19. Social & Accountability (V4)

**Not Phase 2 scope.** Document for strategic completeness.

| Feature | Viral loop |
|---------|------------|
| Friend challenges | 7-day habit duel |
| Accountability partners | Weekly check-in |
| Leaderboards | Opt-in XP rank |
| Achievement sharing | Story card + referral link |
| Referral rewards | XP + premium days |

**Principle:** Private by default. Social is opt-in.

---

## 20. Monetization & Business Model

### Tiers

| Tier | Price (UZS/mo) | Includes |
|------|----------------|----------|
| **Free** | 0 | Full offline loop, rules coach, 3 LLM calls/day, 1 future letter |
| **Premium** | ~29,000 | Unlimited AI, analytics export, focus mode, all letters, themes |
| **Pro** | ~59,000 | Multi-device sync (V3), accountability, voice coach, API export |

### What Stays Free Forever

Tasks, habits, goals, journal, RPG core, capture, inbox, offline mode.

### Premium Value Proposition

*"Unlock the full intelligence of your Life OS — unlimited AI coach, deep analytics, and future self tools."*

### Revenue Model (Y2 target)

| Assumption | Value |
|------------|-------|
| MAU | 100,000 |
| Premium conversion | 5% |
| ARPU Premium | 29,000 UZS |
| Monthly revenue | ~145M UZS |

---

## 21. Competitive Positioning

| Competitor | They win on | REJABON wins on |
|------------|-------------|-----------------|
| TickTick | Speed, sync, polish | Life breadth, RPG, Uzbek AI |
| Notion | Flexibility, linking | Mobile-first, offline, guided loop |
| Habitica | Social RPG | Real-life modules + RPG |
| Duolingo | Streak psychology | Apply same psychology to whole life |
| Headspace | Wellness content | Mood + journal + coach integrated |
| Apple Health | Health data | Cross-domain life score |

**Positioning statement:**  
*REJABON is the only Uzbek-native AI Life OS that turns your real data into daily progress — with evidence, not chat.*

---

## 22. Uzbek & Central Asia Market Strategy

### Why Uzbekistan First

- 35M+ population, young demographic, smartphone growth
- Underserved in native-language productivity/life tools
- Global apps are English-first or poor Uzbek translations
- Offline reliability matters (connectivity variance)

### Go-to-Market (Product-Led)

| Phase | Channel |
|-------|---------|
| Launch | Telegram communities, dev influencers, Product Hunt |
| Growth | Achievement sharing cards, referral (V4) |
| Retention | Future letter unlocks, weekly CEO push |
| Expansion | Kazakh, Tajik localization (Y3) |

### Cultural Adaptations

- Family life area prominent (not just career)
- Finance in UZS defaults
- Coach tone: respectful *siz* form, warm not corporate
- Ramadan/holiday-aware planning (V3 calendar intelligence)

---

## 23. Design & Brand Philosophy

### Visual North Star

**Apple calm × Duolingo delight × Notion clarity**

| Element | Standard |
|---------|----------|
| Density | Low on dashboard; high only in analytics |
| Motion | 200–400ms functional; 600ms celebrations |
| Color | Deep navy base; life area gradient accents |
| Typography | Clear hierarchy; Uzbek diacritics supported |
| Glass | Nav and modals only — not everywhere |
| Emoji | User-controlled; never forced |

### Brand Voice

| Attribute | Example |
|-----------|---------|
| Warm | "Bugun yengil kun — bir odat kifoya." |
| Evidence-based | "14 kun ma'lumotiga ko'ra..." |
| Action-oriented | Always one CTA |
| Never condescending | No guilt for missed streaks |
| Uzbek-primary | English only in settings |

### Name

**REJABON** = *reja* (plan) + *bon* (good)  
Subtitle: **AI Life OS** / **Hayot operatsion tizimi**

---

## 24. Product Principles

| # | Principle | Test |
|---|-----------|------|
| 1 | One hero action per screen | Can user know what to do in 3 seconds? |
| 2 | Loop or leave | Does feature attach to Life Loop stage? |
| 3 | Evidence over hype | Does AI insight cite real data? |
| 4 | Offline sacred | Works in airplane mode? |
| 5 | Progress visible | XP, score, or streak on dashboard? |
| 6 | Connect before expand | Phase 1 before Phase 2 features |
| 7 | Earn notifications | Max 3 meaningful pushes/day |
| 8 | Real RPG | XP from verified actions only |
| 9 | Future emotional | Letter unlock > badge unlock for retention |
| 10 | Uzbek-first | Copy reviewed by native speaker |

---

## 25. Phase Roadmap

### Phase 1 — Wire the Machine ✅ (Complete)

Life loop connections, mood analytics, coach on dashboard, RPG backup, XP bridges, capture CTA.

### Phase 2.5 — Retention Engine 🟡 (4 weeks — partial ship)

Dashboard 2.0, daily briefing, heatmap, predictions, emotion, emergency, memory, showcase, XP overlay. **Remaining:** push delivery, LLM L2, TTS, level-up ceremony.

### Phase 2 — Intelligence & Depth (Current — 12 weeks)

Life Brain completion, Future Self UI, anti-procrastination, unified analytics, AI journal L2, retention push notifications.

### Phase 3 — Platform (16 weeks)

Supabase sync, auth, multi-device, premium billing, boss challenges, skill tree, retention cloud tables.

### Phase 4 — Network (20 weeks)

Social, leaderboards, referrals, achievement sharing viral loop, voice coach premium.

---

## 26. Phase 2 — Detailed Scope

### Phase 2 North Star

**User opens app and feels the system knows them — with one clear action, evidence-backed.**

### Sprint Breakdown

| Sprint | Weeks | Deliverable | Success metric |
|--------|-------|-------------|----------------|
| P2-S1 | 1–2 | Life Brain facade + insight ranking | 1 insight on dashboard with evidence |
| P2-S2 | 3–4 | Unified analytics hub | 0 dead-end insight cards |
| P2-S3 | 5–6 | Future letters UI + unlock ceremony | Letter creation flow complete |
| P2-S4 | 7–8 | Focus mode + Pomodoro | Focus sessions → XP |
| P2-S5 | 9–10 | AI journal emotion tags | Reflection paragraph on save |
| P2-S6 | 11–12 | Vision board + module consolidation | Hayot hub restructured |

### Phase 2 Engineering Priorities

1. `LifeBrainFacade` — unify all insight pipelines
2. `LifeInsight` model + dismiss tracking
3. `AnalyticsHubScreen` — merge analitika + vaqt + mood
4. `FutureLetterScreen` — create + list + unlock
5. `FocusSessionEntity` + timer UI
6. Deprecate parallel providers → single `lifeBrainProvider`
7. CEO review + analytics insights → action routes
8. Split `dashboard_widgets.dart` monolith

### Phase 2 Explicitly NOT In Scope

- Supabase / cloud sync
- Social leaderboards
- Skill tree / boss challenges
- Tablet layouts
- Payment integration

---

## 27. What We Kill, Merge, or Hide

| Item | Action | Phase |
|------|--------|-------|
| Life Twin standalone screen | Absorb into Life Brain | P2-S1 |
| Action Engine standalone | Merge into coach interventions | P2-S1 |
| Life Map standalone | Merge into analytics hub | P2-S2 |
| Time analytics separate route | Redirect to analytics hub | P2-S2 |
| Decision Assistant | Sub-tab in coach | P2-S2 |
| 14 unused dashboard widgets | Delete or wire | P2-S1 |
| QuickAddSheet | Deprecate (Capture wins) | P2-S1 |
| Social screen | Hide until V4 complete | Now |
| Duplicate goal routes | Tab merge | P2-S6 |
| `getAll()` FutureProviders | Stream-derived refactor | P2-S1 |

---

## 28. North Star Metrics

### Primary Metric

**Weekly Life Loop Score** — % WAU completing full loop (capture → act → reflect).

| Milestone | Target |
|-----------|--------|
| Post Phase 1 | Baseline measured |
| Post Phase 2 | ≥25% WAU |
| Post Phase 3 | ≥35% WAU |

### Supporting Metrics

| Metric | Phase 2 target |
|--------|----------------|
| D7 retention | ≥35% |
| D30 retention | ≥20% |
| Coach card CTR | ≥20% DAU |
| Dashboard → task complete | ≥15% DAU |
| RPG quest completion | ≥30% DAU |
| Future letter creation | ≥10% MAU |
| Focus session/week | ≥2 avg (engaged users) |
| Inbox processed <48h | ≥60% |
| Premium waitlist signups | 1,000 (pre-billing) |

---

## 29. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Feature creep returns | High | Life Loop gate on every PR |
| AI costs at scale | Medium | Rule-first; LLM quotas; Premium |
| Life Brain complexity | High | Phased merge; keep old pipelines until parity |
| User overwhelm | High | Dashboard hero redesign; hide advanced |
| Fake AI distrust | High | Evidence UI mandatory |
| Social schema incomplete | Medium | Hide social until build_runner + tests pass |
| Solo dev bandwidth | High | Ruthless P2 scope; no V3 work |
| Retention feature sprawl | High | One dashboard surface; shared `retention_providers` |
| Rule-based AI feels shallow | Medium | LLM L2 for briefing/memory/Q&A; rules always fallback |

---

## 30. Retention Engine — Twelve Systems

Every system must answer: **"Why should the user open this app every day?"**

| # | System | Loop stage | Daily hook | Ship status |
|---|--------|------------|------------|-------------|
| 1 | **AI Memory** | Reflect → Plan | "You studied English 21 days straight" | 🟡 Partial |
| 2 | **Daily Briefing** | Plan | Morning priorities + productivity prediction | ✅ Rule-based |
| 3 | **Life Heatmap** | Reward → Reflect | GitHub-style 365-day activity grid | ✅ Shipped |
| 4 | **Future Predictions** | Plan | "IELTS 7 in 92 days at this pace" | 🟡 Partial |
| 5 | **Emotion Intelligence** | Reflect | Burnout/depression-risk detection + interventions | 🟡 In-app only |
| 6 | **Second Brain Q&A** | Reflect | "What did I write about IELTS?" | 🟡 Rule search |
| 7 | **Voice AI** | Capture → Act | "Create task tomorrow 8 AM" | 🟡 No TTS |
| 8 | **Emergency Mode** | Act → Reflect | "I feel bad" → recovery plan | ✅ Shipped |
| 9 | **Life Character** | Reward | RPG stats: Health, Knowledge, Discipline… | ✅ Shipped |
| 10 | **Achievement Showcase** | Reward | Public/private trophy wall | ✅ Shipped |
| 11 | **Dopamine Rewards** | Reward | XP popup, streak, achievement progress | ✅ Shipped |
| 12 | **Dashboard 2.0** | All stages | Single command center | ✅ Shipped |

**Architecture:** `lib/features/retention/presentation/providers/retention_providers.dart` centralizes data; services in `features/{briefing,heatmap,emotion,emergency,second_brain}/domain/`.

---

## 31. Top 20 Highest-Impact Features

Scoring: **Retention 40% · Business 30% · Loop closure 20% · Build cost −10%**

| Rank | Feature | Impact | Pri | Status | Next action |
|------|---------|--------|-----|--------|-------------|
| 1 | Morning briefing push notification | 96 | **P0** | ❌ | Schedule 07:00 local; deep link `/` |
| 2 | Dashboard 2.0 command center | 95 | — | ✅ | Scroll perf; skeleton states |
| 3 | Focus Mode + Pomodoro + XP | 94 | **P0** | ❌ | `FocusSessionEntity` + timer UI |
| 4 | Future Letters + unlock ceremony | 93 | **P0** | ❌ | Hayot → Kelajak creation flow |
| 5 | Life Brain full pipeline merge | 92 | **P0** | 🟡 | Deprecate parallel insight providers |
| 6 | Emotion push interventions | 91 | **P0** | ❌ | Burnout → rest quest notification |
| 7 | Unified Analytics Hub (5 tabs) | 90 | **P0** | ❌ | Merge analitika + vaqt + heatmap |
| 8 | Daily Briefing LLM L2 | 89 | **P0** | 🟡 | Premium unlimited; 3 free/day |
| 9 | AI Memory LLM synthesis | 88 | **P0** | 🟡 | Nightly enrich + smarter retrieval |
| 10 | Level-up ceremony overlay | 87 | **P1** | ❌ | Full-screen on level change |
| 11 | Anti-procrastination shell banner | 86 | **P0** | ❌ | Avoidance detection → focus CTA |
| 12 | Second Brain LLM RAG Q&A | 85 | **P1** | 🟡 | Embed notes; cite sources |
| 13 | Life Heatmap in analytics tab | 84 | **P1** | 🟡 | Move duplicate; keep dashboard mini |
| 14 | Voice AI TTS responses | 83 | **P1** | ❌ | flutter_tts after command success |
| 15 | Achievement share cards | 82 | **P1** | 🟡 | `ShareCardService` → story format |
| 16 | Weekly AI CEO narrative (LLM) | 81 | **P1** | 🟡 | Sunday push + dashboard card |
| 17 | Swipe inbox triage | 80 | **P1** | ❌ | Capture loop closure |
| 18 | Vision board | 78 | **P1** | ❌ | Future Self pillar |
| 19 | More hub curation (8 visible) | 76 | **P1** | ❌ | Reduce discovery paralysis |
| 20 | Premium paywall + billing prep | 75 | **P1** | ❌ | Gate LLM unlimited, focus mode |

**Already shipped (not in queue):** Emergency Mode, XP overlay, Achievement Showcase (15 defs), Prediction strip, Emotion card (in-app).

---

## 32. Implementation Queue (Next 8 Weeks)

Aligned with `docs/FEATURE_ROADMAP.md` §8.

| Week | Sprint | Deliverables | Exit metric |
|------|--------|--------------|-------------|
| 1 | R2-S1 | Morning briefing push; briefing deep link | Push CTR ≥15% |
| 2 | R2-S2 | Emotion intervention notifications; rest quest auto-offer | Burnout users get push within 1h |
| 3–4 | P2-S4 | Focus Mode + Pomodoro + `FocusSessionEntity` | Focus → XP verified |
| 5–6 | P2-S3 | Future Letters UI + unlock ceremony | ≥10% MAU creates letter |
| 7–8 | P2-S2 | Unified Analytics Hub; heatmap tab | 0 dead-end insight cards |

**Parallel track (ongoing):** Life Brain provider consolidation; LLM L2 for briefing/memory; level-up ceremony.

---

## Appendix A — Glossary

| Term | Definition |
|------|------------|
| Life OS | Operating system for personal life management |
| Life Loop | Capture → Triage → Act → Reward → Reflect → Plan |
| Life Brain | Unified intelligence facade |
| Life Score | 0–100 composite wellbeing metric |
| Pillar | One of 10 life domains |
| Insight | Evidence-backed recommendation with action |
| Recovery quest | RPG quest after streak break — no punishment |
| Retention Engine | Twelve systems designed for daily reopen habit |
| Briefing | Morning AI summary: priorities, habits, predictions |

---

## Appendix B — Document Index

| Document | Purpose |
|----------|---------|
| `PRODUCT_STRATEGY.md` | This file — full product vision |
| `docs/AUDIT_REPORT.md` | Codebase audit |
| `docs/FEATURE_ROADMAP.md` | 50 features + version roadmap |
| `docs/IMPLEMENTATION_PLAN.md` | Engineering sprints |
| `docs/AI_COACH_SYSTEM.md` | Coach architecture |
| `docs/LIFE_RPG_SYSTEM.md` | RPG design |
| `docs/UI_UX_REDESIGN.md` | Screen specs |
| `docs/DATABASE_ARCHITECTURE.md` | Isar + Supabase schema |

---

*REJABON AI — Retention Engine live. Complete the brain. Earn every morning. Become the Life OS.*
