# REJABON AI — AI Life Coach System

**Version:** 4.0 (Phase 4 — Complete Design)  
**Date:** 2026-06-21  
**Status:** Canonical AI Coach specification  
**Companion:** `PRODUCT_STRATEGY.md`, `LIFE_RPG_SYSTEM.md`, `docs/DATABASE_ARCHITECTURE.md`

---

## Table of Contents

1. [Vision & Principles](#1-vision--principles)
2. [AI Architecture](#2-ai-architecture)
3. [Intelligence Layers (L0–L3)](#3-intelligence-layers-l0l3)
4. [Component Map (Current → Target)](#4-component-map-current--target)
5. [Life Context Model](#5-life-context-model)
6. [Prompt Architecture](#6-prompt-architecture)
7. [Memory System](#7-memory-system)
8. [User Profiling](#8-user-profiling)
9. [Recommendation Engine](#9-recommendation-engine)
10. [Pattern Engine](#10-pattern-engine)
11. [Coach Output Types](#11-coach-output-types)
12. [Intervention System](#12-intervention-system)
13. [Commitment Tracking](#13-commitment-tracking)
14. [Voice & Conversation](#14-voice--conversation)
15. [Database Schema](#15-database-schema)
16. [Provider & Infrastructure](#16-provider--infrastructure)
17. [UI Surfaces & Providers](#17-ui-surfaces--providers)
18. [Premium Gating & Quotas](#18-premium-gating--quotas)
19. [Security & Trust](#19-security--trust)
20. [Testing Strategy](#20-testing-strategy)
21. [Phase 4 Implementation Sprints](#21-phase-4-implementation-sprints)

---

## 1. Vision & Principles

### 1.1 What the AI Life Coach Is

The REJABON AI Life Coach is **not a chatbot**. It is a **proactive, evidence-based intelligence layer** that:

- Observes all life data stored locally in Isar
- Detects statistical patterns without hallucination
- Delivers **one prioritized actionable insight** at the right moment
- Remembers user preferences, confirmed patterns, and commitments
- Falls back to deterministic rules when offline or LLM unavailable

**User promise (Uzbek):**  
*"Murabbiyingiz haqiqiy ma'lumotlaringizga asoslanadi."*

**English:**  
*"Your coach cites your data — never generic motivation."*

### 1.2 Three Laws of REJABON AI

| Law | Rule |
|-----|------|
| **No data, no claim** | Never invent statistics, moods, or completion rates |
| **Rules before LLM** | Every LLM feature has an offline L0/L1 fallback |
| **One action per insight** | Reduce decision fatigue; always include a CTA |

### 1.3 Coach vs Chatbot

| Chatbot | REJABON Life Coach |
|---------|-------------------|
| Open-ended conversation | Structured insight + action |
| Generic advice | Evidence from user's Isar data |
| Always online | Offline rules always work |
| Memory in cloud | Local memory (`AiMemoryEntity`) |
| User initiates | System initiates at key moments |

### 1.4 Consolidation Mandate (Phase 4)

Today the codebase has **6 parallel intelligence pipelines**:

| Pipeline | File | Problem |
|----------|------|---------|
| AI Coach rules + LLM | `ai_coach_service.dart` | `getAll()` heavy; shallow LLM context |
| Life Brain ranking | `life_brain_facade.dart` | Partial context (journal + tasks only) |
| Coach patterns | `coach_pattern_engine.dart` | Not wired to coach LLM |
| Analytics insights | `analytics_insight_service.dart` | Separate from coach |
| Life Twin | `life_twin_service.dart` | Duplicate chat + patterns |
| Decision Assistant | `decision_assistant_service.dart` | Third recommendation list |

**Phase 4 target:** Single `AiCoachFacade` fed by expanded `LifeContextAssembler`, with Life Twin chat as a **surface** not a separate brain.

---

## 2. AI Architecture

### 2.1 System Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                         │
│  DashboardCoachCard │ CoachScreen │ InterventionBanner              │
│  WeeklyReview │ MonthlyReport │ VoiceCoach │ CommitmentTracker     │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
┌───────────────────────────────▼─────────────────────────────────────┐
│                         AiCoachFacade                                │
│  getDailyAdvice() │ getWeeklyReview() │ getMonthlyReview()          │
│  getIntervention() │ chat() │ rankRecommendations()                  │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
        ┌───────────────────────┼───────────────────────┐
        ▼                       ▼                       ▼
┌───────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Recommendation│     │  LlmSynthesizer │     │ MemoryRetriever │
│ Engine        │     │  (AiOrchestrator)│     │ (AiMemorySvc)  │
│ L0 rules +    │     │  JSON-structured │     │ + dismissals    │
│ L1 patterns   │     │  Uzbek output    │     │ + profile       │
└───────┬───────┘     └────────┬────────┘     └────────┬────────┘
        │                      │                         │
        └──────────────────────┼─────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    LifeContextAssembler                              │
│  Assembles CoachContext from 15+ data slices (budgeted, indexed)     │
└───────────────────────────────┬─────────────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         DATA LAYER (Isar)                            │
│ Tasks │ Habits │ Goals │ Journal │ Finance │ TimeLogs │ Inbox       │
│ Plans │ RPG │ LifeAreas │ CEO │ Milestones │ TwinProfile │ Memories  │
│ Conversations │ Commitments                                          │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Request Flow (Daily Advice)

```
1. User opens app OR navigates to /boshqa/murabbiy
2. coachContextProvider assembles CoachContext (<200ms target)
3. RecommendationEngine.generate(context, memories, profile)
   → L0 rules (AiCoachService.generateFromData logic)
   → L1 patterns (CoachPatternEngine + MoodTrendService)
   → L1.5 memory boost (confirmed AiMemoryEntity insights)
   → Merge + rank by priority
4. If Premium OR free LLM quota remaining:
   → LlmSynthesizer.synthesize(top 3 candidates + full context)
   → Parse JSON CoachAdvice; on fail → use top rule insight
5. LifeBrainFacade-compatible LifeInsight returned to UI
6. On user action (tap CTA): log outcome to memory
7. On dismiss ×3: suppress insight pattern
```

### 2.3 AiCoachFacade API (Target)

```dart
abstract class AiCoachFacade {
  /// Single best insight for dashboard.
  Future<CoachAdvice> getDailyAdvice();

  /// Sunday / CEO review synthesis.
  Future<CoachReview> getWeeklyReview();

  /// 1st of month life score narrative.
  Future<CoachReview> getMonthlyReview();

  /// Anti-procrastination / burnout — nullable if no trigger.
  CoachIntervention? getActiveIntervention();

  /// Ranked list for coach screen (max 5).
  Future<List<CoachAdvice>> getRecommendations({int limit = 5});

  /// Life Twin chat — conversation with profile + memory.
  Future<String> chat(String userMessage, {String inputType = 'text'});

  /// Record user feedback on advice.
  Future<void> recordFeedback(String insightId, CoachFeedback feedback);
}
```

### 2.4 File Structure (Target)

```
lib/
├── core/
│   ├── ai/                          # Existing — unchanged
│   │   ├── ai_orchestrator.dart
│   │   ├── ai_config.dart
│   │   └── ai_provider_client.dart
│   └── intelligence/
│       ├── life_context_assembler.dart    # Expand
│       ├── life_brain_facade.dart         # Merge into coach
│       ├── pattern_engine.dart            # Extract from life_twin
│       ├── models/
│       │   ├── coach_context.dart         # Expand
│       │   ├── coach_advice.dart          # New
│       │   ├── coach_review.dart          # New
│       │   └── life_insight.dart          # Existing
│       └── intelligence_providers.dart
└── features/
    └── coach/                             # Consolidate ai_coach + life_twin chat
        ├── domain/
        │   ├── ai_coach_facade.dart
        │   ├── recommendation_engine.dart
        │   ├── llm_synthesizer.dart
        │   ├── memory_retriever.dart
        │   ├── intervention_engine.dart
        │   └── commitment_extractor.dart
        └── presentation/
            ├── providers/coach_providers.dart
            └── screens/coach_screen.dart
```

---

## 3. Intelligence Layers (L0–L3)

| Layer | Name | Latency | Cost | When used |
|-------|------|---------|------|-----------|
| **L0** | Rule Engine | <50ms | Free | Always — offline baseline |
| **L1** | Pattern Engine | <200ms | Free | ≥7–14 days data |
| **L1.5** | Memory Retrieval | <30ms | Free | Top confirmed memories |
| **L2** | LLM Synthesizer | 1–5s | API | Premium / quota |
| **L3** | Life Brain Ranker | <100ms | Free | Priority merge of L0–L2 |

**Never ship L2 without L0.** User rule: no fake AI.

### 3.1 Layer Responsibilities

```
L0: "You have 3 overdue tasks"           — deterministic thresholds
L1: "Tuesday is your best day (34%)"     — statistical correlation
L1.5: "You told us mornings work best"    — stored memory recall
L2: "Given your mood trend and Career    — natural language synthesis
     goal drift, focus on X today"
L3: Pick ONE insight from above          — priority ranking
```

---

## 4. Component Map (Current → Target)

| Component | Status | Phase 4 action |
|-----------|--------|----------------|
| `AiCoachService` | ✅ Shipped | Extract rules → `RecommendationEngine`; thin wrapper |
| `LifeContextAssembler` | ⚠️ Partial | Expand to full `CoachContext` |
| `LifeBrainFacade` | ⚠️ Partial | Absorb into `AiCoachFacade` ranking |
| `CoachPatternEngine` | ✅ Shipped | Move to `core/intelligence/pattern_engine.dart` |
| `MoodTrendService` | ✅ Shipped | Feed context assembler |
| `AiMemoryService` | ⚠️ Underused | Wire to facade + weekly cron |
| `DigitalTwinEngine` | ✅ Shipped | Feed user profiling |
| `TwinProfileEngine` | ✅ Shipped | Feed user profiling |
| `LifeTwinService` | ✅ Shipped | Chat only → `AiCoachFacade.chat()` |
| `DecisionAssistantService` | ✅ Shipped | Merge into `RecommendationEngine` |
| `AnalyticsInsightService` | ✅ Shipped | Feed memory + L0 rules |
| `CeoWeeklyReviewService` | ✅ Shipped | Feed weekly review |
| `VoiceCoachScreen` | ✅ Shipped | Route through facade |
| `DashboardCoachCard` | ✅ Shipped | Consume `dailyCoachAdviceProvider` |

---

## 5. Life Context Model

### 5.1 CoachContext (Target Schema)

```dart
class CoachContext {
  final DateTime asOf;

  // User identity
  final UserProfile profile;
  final UserPersona persona;          // onboarding: student | professional | wellness | all

  // Time slices
  final TodaySnapshot today;
  final WeekSnapshot week;
  final MonthSnapshot month;

  // Life pillars
  final MoodTrendReport mood;
  final ProductivityPattern productivity;
  final HabitPattern habits;
  final GoalProgress goals;
  final FinanceSummary? finance;
  final SleepSummary? sleep;            // Phase 4: manual log
  final RpgSnapshot rpg;
  final LifeAreaBalance lifeBalance;

  // Intelligence
  final List<PatternInsight> patterns;
  final List<String> topMemories;
  final BurnoutSignal? burnout;

  // Operational
  final List<Commitment> openCommitments;
  final InboxSummary inbox;
  final PlanSummary? todayPlan;

  // Meta
  final int contextVersion;             // schema version for prompts
  final int estimatedTokens;            // after summarization
}
```

### 5.2 Sub-Models

#### UserProfile (from TwinProfileEntity + settings)

```dart
class UserProfile {
  final String displayName;
  final UserPersona persona;
  final String chronotype;              // morning_person | night_owl | balanced
  final String productivityStyle;       // steady | burst | inconsistent
  final String goalOrientation;         // optimistic | realistic | cautious
  final String habitConsistency;        // high | medium | low
  final String moodTrendLabel;          // stable | improving | declining | volatile
  final String preferredCoachTone;      // encouraging | direct | gentle
  final int lifeScore;
  final int playerLevel;
}
```

#### TodaySnapshot

```dart
class TodaySnapshot {
  final int tasksDue;
  final int tasksCompleted;
  final int tasksOverdue;
  final int habitsTotal;
  final int habitsCompleted;
  final bool journalWritten;
  final int? moodToday;                 // 1–5
  final int inboxUnprocessed;
  final int focusMinutes;
  final int xpEarnedToday;
}
```

#### WeekSnapshot

```dart
class WeekSnapshot {
  final int tasksCompleted;
  final double habitCompletionRate;
  final int journalDays;
  final double avgMood;
  final int workouts;
  final int studyMinutes;
  final String bestDay;                 // Dushanba, etc.
  final String worstDay;
  final int lifeScoreDelta;             // vs prior week
}
```

### 5.3 Context Assembly Rules

**Performance target:** <200ms on mid-range Android.

| Slice | Query strategy | Max rows |
|-------|----------------|----------|
| Today tasks | `dueDate == today OR completed today` | 50 |
| Overdue tasks | `!completed && dueDate < today` | 20 |
| Habits | `watchAll()` → filter today | 30 |
| Journal | last 30 entries | 30 |
| Goals | `progress < 100` | 20 |
| Finance | last 30 days | 100 |
| Time logs | last 14 days | 50 |
| XP events | last 7 days | 100 |
| Inbox | `isProcessed == false` | 50 |
| Memories | `getTop(limit: 5)` | 5 |
| Twin profile | singleton | 1 |

**Anti-pattern to eliminate:** `getAll()` on 8 repositories in `AiCoachService.generateRecommendations()`.

### 5.4 Context Summarization for LLM

Before sending to LLM, `ContextSummarizer` produces a token-budgeted JSON:

```json
{
  "user": {
    "name": "Ali",
    "persona": "professional",
    "chronotype": "morning_person",
    "level": 12,
    "coach_tone": "direct"
  },
  "today": {
    "tasks_overdue": 2,
    "habits_done": "2/5",
    "mood": "3/5",
    "journal": false
  },
  "week": {
    "tasks_completed": 18,
    "habit_rate": "71%",
    "avg_mood": 3.4,
    "best_day": "Dushanba"
  },
  "patterns": [
    "Kayfiyat past kunlarda vazifa bajarish 34% kamroq",
    "Eng samarali vaqt: 9–11"
  ],
  "memories": [
    "Siz ertalabki vazifalarni yaxshiroq bajaryapsiz"
  ],
  "goals_at_risk": ["Career: Portfolio yangilash — 9 kun harakatsiz"],
  "burnout": null
}
```

---

## 6. Prompt Architecture

### 6.1 Prompt System Overview

```
┌─────────────────────────────────────────┐
│           SYSTEM PROMPT (fixed)          │
│  Role + laws + output schema + tone      │
├─────────────────────────────────────────┤
│         DEVELOPER PROMPT (per task)      │
│  Task type + constraints + examples      │
├─────────────────────────────────────────┤
│           CONTEXT (dynamic JSON)         │
│  Summarized CoachContext                 │
├─────────────────────────────────────────┤
│         USER PROMPT (minimal)            │
│  "Generate daily_advice" or chat msg    │
└─────────────────────────────────────────┘
```

### 6.2 Master System Prompt

```
Siz REJABON AI hayot murabbiyisiz.

QOIDALAR:
1. Faqat CONTEXT ichidagi ma'lumotlarga tayaning. Hech narsa o'ylab topmang.
2. Javob o'zbek tilida bo'lsin.
3. Qisqa, aniq, samimiy — manipulyatsiya qilmang.
4. Har javobda bitta aniq harakat bo'lsin.
5. Ishonch darajasini ko'rsating (yuqori/o'rta/past).
6. Tibbiy tashxis qo'ymang. Sog'liq maslahatlari umumiy bo'lsin.

SHAXS:
- Foydalanuvchi bilan hurmatli "siz" shaklida gapiring.
- Ton: {coach_tone} (rag'batlantiruvchi | to'g'ridan-to'g'ri | muloyim)

OUTPUT: Faqat JSON formatida javob bering. Boshqa matn yo'q.
```

### 6.3 Task-Specific Developer Prompts

#### daily_advice

```
VAZIFA: daily_advice
Maqsad: Foydalanuvchiga bugun bitta eng muhim harakatni ayting.
Ustuvorlik: burnout > overdue > goal_drift > habits > journal > positive
Maksimum: headline 80 belgi, body 300 belgi
Evidence: kamida 1 ta CONTEXT dan olingan raqam
```

#### weekly_review

```
VAZIFA: weekly_review
Maqsad: Haftalik xulosa — g'alabalar, zaif tomonlar, keyingi hafta fokusi.
Tuzilma: wins[] (max 3), misses[] (max 3), pattern_insight, next_week_focus
Ton: CEO hisobot — professional lekin iliq
```

#### monthly_review

```
VAZIFA: monthly_review
Maqsad: Oylik hayot hisoboti — life score trend, maqsadlar, moliya, kelajak xati taklifi
Tuzilma: score_delta, domain_highlights[], domain_weak[], future_self_prompt
```

#### intervention

```
VAZIFA: intervention
Maqsad: Qisqa, aniq aralashuv — procrastination yoki burnout
Maksimum: headline 60 belgi, body 150 belgi
Ton: muloyim lekin to'g'ridan-to'g'ri
action.type: start_focus | navigate | complete_habit
```

#### chat

```
VAZIFA: chat
Maqsad: Foydalanuvchi savoliga kontekstga asoslangan javob
Maksimum: 250 belgi
Suhbat tarixi: oxirgi 6 ta xabar
Hech qachon tibbiy tashxis bermang
```

#### memory_extraction

```
VAZIFA: memory_extraction
Maqsad: Foydalanuvchi haqida 2-3 ta doimiy kuzatuv (o'zbek tilida)
Format: har biri alohida qator, faqat kuzatuvlar
Misol: "Siz dushanba kunlari eng samarali ishlaysiz."
```

### 6.4 Output JSON Schemas

#### CoachAdvice (daily / intervention)

```json
{
  "headline": "string, max 80 chars",
  "body": "string, max 300 chars",
  "evidence": ["string", "string"],
  "confidence": "high | medium | low",
  "action": {
    "type": "navigate | create_task | start_focus | complete_habit | open_journal",
    "route": "/vazifalar",
    "payload": {}
  },
  "tone": "encouraging | direct | gentle",
  "pillar": "tasks | habits | health | goals | finance | spiritual",
  "insight_id": "goal_drift_career_20260621"
}
```

#### CoachReview (weekly / monthly)

```json
{
  "title": "Haftalik hisobot — 16–22 iyun",
  "narrative": "string, max 600 chars",
  "wins": ["string"],
  "misses": ["string"],
  "pattern_insight": "string",
  "next_focus": "string",
  "evidence": ["string"],
  "confidence": "high | medium | low",
  "actions": [
    { "label": "string", "route": "/hayot/odatlar" }
  ]
}
```

#### ChatResponse

```json
{
  "reply": "string, max 400 chars",
  "suggested_action": {
    "type": "navigate",
    "route": "/vazifalar"
  }
}
```

### 6.5 Token Budget

| Task | Context max | Output max | Temperature |
|------|-------------|------------|-------------|
| daily_advice | 2,000 | 400 | 0.5 |
| weekly_review | 4,000 | 800 | 0.6 |
| monthly_review | 6,000 | 1,200 | 0.6 |
| intervention | 1,500 | 200 | 0.4 |
| chat | 3,000 + 6 history | 400 | 0.7 |
| memory_extraction | 1,500 | 200 | 0.5 |

### 6.6 Prompt Versioning

```dart
class PromptRegistry {
  static const version = 'coach_prompt_v4.0';
  static const systemPromptHash = 'sha256:...';  // for A/B testing
}
```

Store `promptVersion` in `CoachConversationEntity.contextType` metadata for debugging.

### 6.7 Fallback Chain

```
LLM request
  → JSON parse success? → use LLM output
  → JSON parse fail? → extract plain text → wrap as CoachAdvice
  → LLM timeout/error? → top L0 rule insight
  → No rules? → default encouragement (existing AiCoachService fallback)
  → Offline? → L0 + L1 only, never call AiOrchestrator
```

### 6.8 Shipped Prompt (Legacy — to replace)

Current `ai_coach_service.dart` LLM prompt (string buffer, not JSON):

```
System: Sen REJABON AI shaxsiy murabbiyisan. Faqat o'zbek tilida javob ber.
        Qisqa, aniq va motivatsion bo'l. Manipulyatsiya qilma.
        Javob formati: BIRINCHI QATOR sarlavha, keyin nuqta va tavsif.

User: Bugungi holat:
      - Kechikkan vazifalar: N
      - Bajarilmagan odatlar: N
      ...
```

**Phase 4:** Replace with JSON schema + full `CoachContext` summarizer.

---

## 7. Memory System

### 7.1 Memory Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   MEMORY LAYERS                        │
├─────────────────────────────────────────────────────────┤
│ L1 Working    │ CoachContext (per request, ephemeral) │
│ L2 Session    │ CoachConversationEntity (chat history)│
│ L3 Long-term  │ AiMemoryEntity (patterns + preferences)│
│ L4 Profile    │ TwinProfileEntity (computed traits)   │
│ L5 Episodic   │ CoachCommitmentEntity (promises)      │
└─────────────────────────────────────────────────────────┘
```

### 7.2 AiMemoryEntity (Shipped)

**File:** `lib/core/database/schemas/ai_memory_entity.dart`

| Field | Type | Description |
|-------|------|-------------|
| `id` | `Id` | PK |
| `category` | `String` | Indexed — see categories below |
| `insight` | `String` | Uzbek natural language |
| `confidence` | `double` | 0.0–1.0 |
| `createdAt` | `DateTime` | Indexed |
| `lastReferencedAt` | `DateTime` | Updated on recall |
| `referenceCount` | `int` | Popularity signal |

#### Memory Categories

| Category | Source | Example |
|----------|--------|---------|
| `productivity` | Analytics + patterns | "Siz ertalabki vazifalarni yaxshiroq bajaryapsiz" |
| `habits` | TwinProfileEngine | "Eng kuchli odatlar: Meditatsiya, O'qish" |
| `goals` | TwinProfileEngine | "Asosiy maqsadlar: Career, Health" |
| `mood` | Mood trend | "Kayfiyat barqaror (o'rtacha 3.8/5)" |
| `personality` | Chronotype | "Siz ertalabki odamsiz" |
| `finance` | Analytics | "Oziq-ovqat xarajatlari daromadning 40%" |
| `learning` | Study patterns | "Haftada 2 soatdan ko'p o'qimaysiz" |
| `fitness` | Workout patterns | "Mashq kunlari kayfiyat yuqoriroq" |
| `preference` | User feedback | "Foydalanuvchi qisqa maslahatni afzal ko'radi" |
| `dismissed` | Negative feedback | "MOOD_PRODUCTIVITY — 3× rad etilgan" |

### 7.3 Memory Lifecycle

```
WRITE triggers:
  ├── Weekly review completed → AiMemoryService.analyzeAndStore()
  ├── DigitalTwinEngine.syncProfile() → personality + habit + goal memories
  ├── Pattern confirmed (user taps "Foydali") → upsert with confidence 0.95
  ├── LLM memory_extraction task → upsert new observations
  └── Commitment fulfilled → episodic memory

READ triggers:
  ├── Daily advice assembly → getTop(limit: 5)
  ├── LLM context → top 3 memories in JSON
  └── Chat → top 5 memories + recent conversation

DECAY:
  ├── deleteOld(keepMax: 40) after analyzeAndStore
  ├── confidence -= 0.05/month if referenceCount == 0
  └── dismissed patterns → confidence = 0, excluded from retrieval

BOOST:
  ├── referenceCount++ on each recall
  └── user "Foydali" → confidence = min(1.0, confidence + 0.1)
```

### 7.4 AiMemoryService (Shipped — Wire in Phase 4)

**File:** `lib/features/ai_memory/domain/ai_memory_service.dart`

| Method | Purpose |
|--------|---------|
| `getTopInsights(limit)` | Retrieve for context |
| `analyzeAndStore(...)` | Analytics + LLM → upsert memories |

**Current gap:** `analyzeAndStore()` not called on schedule.  
**Phase 4 fix:** Call on:
- Weekly CEO review open
- Sunday 18:00 background task (if notifications enabled)
- After 7th daily app open in a week

### 7.5 MemoryRetriever (Target)

```dart
class MemoryRetriever {
  Future<List<ScoredMemory>> retrieveForContext(
    CoachContext context, {
    int limit = 5,
  }) async {
    final all = await _repo.getTop(limit: 20);
    return all
        .where((m) => !_dismissedIds.contains(m.insight.hashCode))
        .map((m) => ScoredMemory(
              memory: m,
              relevance: _scoreRelevance(m, context),
            ))
        .toList()
      ..sort((a, b) => b.relevance.compareTo(a.relevance))
      ..take(limit);
  }

  double _scoreRelevance(AiMemoryEntity m, CoachContext ctx) {
    var score = m.confidence * 0.4;
    score += (m.referenceCount.clamp(0, 10) / 10) * 0.2;
    score += _categoryMatch(m.category, ctx) * 0.4;
    return score;
  }
}
```

### 7.6 Dismissal & Learning

```dart
enum CoachFeedback { helpful, notHelpful, dismissed }

// On dismissed × 3 for same insight_id pattern:
await memoryRepo.upsert(
  category: 'dismissed',
  insight: 'PATTERN:$patternId',
  confidence: 0.0,
);
```

Store dismissals in `SharedPreferences` or new `CoachPreferenceEntity`.

---

## 8. User Profiling

### 8.1 Profile Architecture

User profiling combines **explicit** (onboarding) and **implicit** (computed from behavior) signals.

```
┌─────────────────────────────────────────────────────────┐
│                    USER PROFILE                          │
├──────────────────────┬──────────────────────────────────┤
│ EXPLICIT             │ IMPLICIT (computed)               │
│ ─────────────────    │ ─────────────────────────────     │
│ onboardingPersona    │ chronotype (TwinProfileEngine)    │
│ userName             │ productivityStyle                 │
│ coachTone preference │ goalOrientation                   │
│ notification times   │ habitConsistency                  │
│                      │ moodTrend                         │
│                      │ peakHours (from time logs)        │
│                      │ neglectedLifeAreas                │
│                      │ playerLevel + RPG stats           │
└──────────────────────┴──────────────────────────────────┘
```

### 8.2 Onboarding Personas (Explicit)

**Source:** `settingsProvider.onboardingPersona` — `SharedPreferences`

| ID | Label | Coach emphasis | Default tone |
|----|-------|----------------|--------------|
| `student` | Talaba | Study, habits, goals | encouraging |
| `professional` | Professional | Tasks, focus, CEO review | direct |
| `wellness` | Sog'lomlik | Mood, journal, balance | gentle |
| `all` | Hammasi | Balanced mix | encouraging |

**Prompt injection:**

```
Foydalanuvchi tipi: professional
Ustuvorliklar: vazifalar, fokus, samaradorlik
```

### 8.3 TwinProfileEntity (Implicit — Shipped)

**File:** `lib/core/database/schemas/twin_profile_entity.dart`

| Field | Values | Computed by |
|-------|--------|-------------|
| `chronotype` | morning_person, night_owl, balanced | `TwinProfileEngine` — task completion by hour |
| `productivityStyle` | steady, burst, inconsistent | Variance of daily completions |
| `goalOrientation` | optimistic, realistic, cautious | Goal progress vs targets |
| `habitConsistency` | high, medium, low | Streak averages |
| `moodTrend` | stable, volatile, improving, declining | 14-day mood regression |
| `traitsJson` | learnedHabits, learnedGoals, topCategories | Embedded JSON |
| `lifeScoreSnapshot` | 0–100 | Last sync life score |

### 8.4 TwinProfileEngine Logic

**File:** `lib/features/life_twin/domain/twin_profile_engine.dart`

```dart
class ComputedTwinProfile {
  final String chronotype;
  final String productivityStyle;
  final String goalOrientation;
  final String habitConsistency;
  final String moodTrend;
  final double avgMood;
  final List<String> learnedHabits;    // top 3 by streak
  final List<String> learnedGoals;     // top 3 by progress velocity
  final List<String> topTaskCategories;
}
```

**Chronotype detection:**

```
morning_person:  >60% task completions before 12:00
night_owl:       >40% task completions after 20:00
balanced:        otherwise
```

### 8.5 DigitalTwinEngine Sync

**Trigger:** Weekly OR on Life Twin screen open OR before weekly review LLM call.

```
syncProfile()
  → TwinProfileEngine.compute()
  → Save TwinProfileEntity
  → Upsert 4–6 AiMemoryEntity rows (personality, habits, goals, mood, patterns)
```

### 8.6 Coach Tone Adaptation

| Profile signal | Tone adjustment |
|----------------|-----------------|
| `moodTrend == declining` | gentle — shorter sentences, empathy first |
| `productivityStyle == burst` | direct — urgency, deadlines |
| `habitConsistency == low` | encouraging — celebrate small wins |
| `persona == professional` | direct — data-first |
| User setting override | Always wins |

### 8.7 Profile in Prompts

```json
{
  "profile": {
    "persona": "professional",
    "chronotype": "morning_person",
    "productivity_style": "steady",
    "habit_consistency": "medium",
    "mood_trend": "stable",
    "coach_tone": "direct",
    "peak_hours": "9-11",
    "neglected_areas": ["social", "finance"],
    "level": 12
  }
}
```

---

## 9. Recommendation Engine

### 9.1 Engine Architecture

The Recommendation Engine is the **single source of truth** for all coach advice. It merges L0 rules, L1 patterns, memories, and optional LLM synthesis into ranked `CoachAdvice` objects.

```
RecommendationEngine
  ├── RuleEvaluator          (from AiCoachService static methods)
  ├── PatternEvaluator       (CoachPatternEngine + MoodTrendService)
  ├── MemoryBooster          (MemoryRetriever)
  ├── PriorityRanker         (LifeBrainFacade logic, extended)
  ├── LlmSynthesizer         (optional enhancement)
  └── ActionRouter           (maps advice → routes)
```

### 9.2 Recommendation Pipeline

```dart
Future<List<CoachAdvice>> generate(CoachContext ctx) async {
  final candidates = <CoachAdvice>[];

  // L0: Rules (always)
  candidates.addAll(RuleEvaluator.evaluate(ctx));

  // L1: Patterns (if sufficient data)
  candidates.addAll(PatternEvaluator.evaluate(ctx));

  // L1.5: Memory-backed insights
  candidates.addAll(await MemoryBooster.boost(ctx));

  // L3: Rank
  candidates.sort((a, b) => b.priority.compareTo(a.priority));

  // L2: Optional LLM polish on top candidate
  if (_shouldUseLlm()) {
    final enhanced = await LlmSynthesizer.enhance(
      context: ctx,
      candidates: candidates.take(3).toList(),
      task: CoachTask.dailyAdvice,
    );
    if (enhanced != null) candidates.insert(0, enhanced);
  }

  return candidates;
}
```

### 9.3 Priority Matrix

| Priority | Condition | insight_id prefix |
|----------|-----------|-------------------|
| 100 | Burnout signal (L1) | `burnout_` |
| 95 | Mood ≤2 today | `mood_critical_` |
| 90 | Mood burnout risk (7-day) | `mood_burnout_risk` |
| 85 | Open commitment overdue | `commitment_` |
| 80 | ≥5 overdue tasks | `overdue_critical_` |
| 75 | Goal drift ≥7 days | `goal_drift_` |
| 70 | L0 coach rules (tasks, habits) | `rule_` |
| 65 | Inbox >20 unprocessed | `inbox_backlog_` |
| 60 | L1 pattern insight | `pattern_` |
| 50 | Finance negative balance | `finance_` |
| 40 | Journal missing today | `journal_` |
| 30 | RPG quest almost complete | `quest_nudge_` |
| 20 | Positive reinforcement | `win_` |
| 10 | Default encouragement | `default_` |

### 9.4 L0 Rule Catalog (Shipped — from AiCoachService)

#### Plan rules (`_planTipsFromData`)

| Rule ID | Condition | Action route |
|---------|-----------|--------------|
| `plan_missed` | missed plan items > 0 | `/reja` |
| `plan_pending` | pending plan items > 0 | `/reja` |

#### Task rules (`_taskTipsFromData`)

| Rule ID | Condition | Action route |
|---------|-----------|--------------|
| `task_overdue` | overdue task (top 3) | `/vazifalar/{id}` |
| `task_overdue_many` | overdue > 3 | `/vazifalar` |

#### Habit rules (`_habitTipsFromData`)

| Rule ID | Condition | Action route |
|---------|-----------|--------------|
| `habit_incomplete` | habit not checked today | `/hayot/odatlar` |
| `habit_incomplete_many` | incomplete > 3 | `/hayot/odatlar` |

#### Goal rules (`_goalTipsFromData`)

| Rule ID | Condition | Action route |
|---------|-----------|--------------|
| `goal_low_progress` | progress < 30% | `/hayot/maqsadlar` |
| `goal_deadline_near` | target ≤14 days | `/hayot/maqsadlar` |

#### Finance rules (`_financeTipsFromData`)

| Rule ID | Condition | Action route |
|---------|-----------|--------------|
| `finance_negative` | balance < 0 | `/moliya` |
| `finance_category_spike` | category > 40% income | `/moliya` |
| `finance_empty` | no transactions | `/moliya` |

#### Journal rules (`_journalTipsFromData`)

| Rule ID | Condition | Action route |
|---------|-----------|--------------|
| `journal_missing` | no entry today | `/hayot/kundalik` |
| `journal_low_mood` | mood ≤ 2 | `/hayot/kundalik` |

### 9.5 CoachAdvice Model (Target)

```dart
class CoachAdvice {
  final String id;
  final String headline;
  final String body;
  final List<String> evidence;
  final InsightConfidence confidence;
  final int priority;
  final InsightSource source;       // rule | pattern | memory | llm | merged
  final String? pillar;
  final String? loopStage;
  final CoachAction? action;
  final String tone;
}

class CoachAction {
  final String type;                // navigate | create_task | start_focus | ...
  final String? route;
  final Map<String, dynamic>? payload;
  final String? label;              // Uzbek CTA text
}
```

### 9.6 DecisionAssistant Merge

`DecisionAssistantService.generateRecommendations()` logic merges into RecommendationEngine:

| DecisionAssistant category | Maps to priority |
|--------------------------|------------------|
| wellbeing (burnout) | 100 |
| tasks (overdue) | 80 |
| goals (low progress) | 75 |
| memory_insight | 60 |
| general | 40 |

Standalone `/boshqa/qaror-yordam` route becomes a filtered view of `getRecommendations()`.

### 9.7 LifeBrainFacade Absorption

Current `LifeBrainFacade.generateInsights()` priority logic becomes `PriorityRanker` inside RecommendationEngine. `LifeInsight` and `CoachAdvice` unify — `LifeInsight` is the UI DTO, `CoachAdvice` is the domain model.

---

## 10. Pattern Engine

### 10.1 CoachPatternEngine (Shipped)

**File:** `lib/features/life_twin/domain/coach_pattern_engine.dart`

| Detector | Method | Min data | Output |
|----------|--------|----------|--------|
| Mood ↔ Productivity | `analyzeMoodProductivity` | 14 days journal + tasks | % difference high vs low mood days |
| Day of week | `analyzeDayOfWeek` | 7+ completed tasks | best/worst day + rates |
| Burnout | `detectBurnout` | 5+ journal entries, 7 days | level: high/moderate + message |
| Insight bundle | `buildPatternInsights` | combines above | List of Uzbek strings |

### 10.2 Extended Pattern Detectors (Phase 4)

| Pattern ID | Inputs | Output example | Min days |
|------------|--------|----------------|----------|
| `MOOD_PRODUCTIVITY` | mood × task completion | "Kayfiyat ≤2 → 41% kamroq vazifa" | 14 |
| `DAY_OF_WEEK` | completion by weekday | "Dushanba eng samarali kun (34%)" | 21 |
| `HOUR_OF_DAY` | completion by hour | "Eng yaxshi vaqt: 9–11" | 14 |
| `STRESS_HABIT_SKIP` | low mood day × habit miss | "Stress kunlari odat 34% ko'proq o'tkaziladi" | 21 |
| `FINANCE_STRESS` | spending spike × mood | "Yuqori xarajat haftalari kayfiyat past" | 30 |
| `INBOX_AVOIDANCE` | inbox count × overdue tasks | "Inbox to'lib → 2× kechikish" | 7 |
| `GOAL_DRIFT` | days since goal-linked task | "Career maqsadi: 9 kun harakatsiz" | — |
| `FOCUS_TIME` | time logs by hour | "Diqqat cho'qqisi: 9–11" | 14 |
| `SLEEP_PRODUCTIVITY` | sleep hours × completion | "Uyqu <6 soat → 28% kamroq" | 14 (needs sleep log) |
| `WEEKLY_MOOD_TREND` | MoodTrendService | "Kayfiyat yaxshilanmoqda" | 7 |

### 10.3 Confidence Scoring

```dart
InsightConfidence scoreConfidence({
  required int sampleSize,
  required double effectSize,
}) {
  if (sampleSize >= 21 && effectSize >= 0.3) return InsightConfidence.high;
  if (sampleSize >= 14 && effectSize >= 0.15) return InsightConfidence.medium;
  return InsightConfidence.low;
}
```

Low confidence insights show disclaimer: *"Ko'proq ma'lumot kerak — hozircha taxminiy."*

---

## 11. Coach Output Types

### 11.1 Daily Advice

| Attribute | Spec |
|-----------|------|
| **Trigger** | First app open after 6 AM; dashboard load |
| **Surface** | `DashboardCoachCard`, coach screen hero |
| **Content** | 1 headline + 1 body + 1 action |
| **Sources** | RecommendationEngine top priority |
| **Refresh** | On task/habit/journal complete; pull-to-refresh |

**Example:**

> **Bugun Career maqsadi ustuvor**  
> "Portfolio yangilash" 9 kundan beri harakatsiz. Bugun kamida 30 daqiqa ajrating.  
> *Ishonch: Yuqori · 9 kun maqsadsiz*  
> [Vazifani boshlash →]

### 11.2 Weekly Review

| Attribute | Spec |
|-----------|------|
| **Trigger** | Sunday 18:00 push OR CEO Review screen |
| **Surface** | `/boshqa/ceo-hisobot` enhanced |
| **Content** | Wins, misses, pattern, next week focus |
| **LLM** | Premium full narrative; Free rule-based bullets |

### 11.3 Monthly Review

| Attribute | Spec |
|-----------|------|
| **Trigger** | 1st of month |
| **Surface** | Coach screen tab |
| **Content** | Life score delta, domain breakdown, future letter prompt |
| **LLM** | Premium only |

### 11.4 Life Insights (On-demand)

Correlation cards in analytics hub. Tap "Batafsil" → LLM expands pattern into narrative.

### 11.5 Chat (Life Twin)

Not a separate brain — `AiCoachFacade.chat()` with full profile + memory + last 6 messages.

---

## 12. Intervention System

### 12.1 InterventionEngine

```dart
class InterventionEngine {
  CoachIntervention? evaluate(CoachContext ctx) {
    // Only one active intervention at a time
    if (ctx.burnout != null) return _burnoutIntervention(ctx);
    if (_taskAvoidanceDetected(ctx)) return _procrastinationIntervention(ctx);
    if (ctx.inbox.unprocessed > 20) return _inboxIntervention(ctx);
    return null;
  }
}
```

### 12.2 Trigger Table

| Trigger | Threshold | Escalation | Action |
|---------|-----------|------------|--------|
| Task postponed | 3× same task | gentle → firm → focus | `start_focus` |
| Inbox backlog | >20 items, 48h | single | `navigate /boshqa/inbox` |
| Habit streak break | was ≥7 days | recovery quest | `navigate /hayot/odatlar` |
| No app open | 48h | push notification | open app |
| Task screen idle | 10 min, 0 complete | 2-minute rule | micro-task split |
| Burnout signal | L1 detector | rest quest | `open_journal` |

### 12.3 Escalation Ladder (Procrastination)

```
Level 1 (gentle):  "X vazifasi 3 kundan beri kutilmoqda."
Level 2 (direct):  "2 daqiqalik qoidani sinab ko'ramizmi? Faqat 2 daqiqa."
Level 3 (action):  [Fokus rejimini boshlash] → /fokus?taskId=X
```

### 12.4 Burnout Override

When `BurnoutSignal.level >= moderate`:
- Suppress procrastination escalations
- Offer rest quest instead
- Coach tone → gentle
- RPG: suggest `rest_quest`, not discipline pressure

---

## 13. Commitment Tracking

### 13.1 CoachCommitmentEntity (Phase 4 — New)

```dart
@collection
class CoachCommitmentEntity {
  Id id = Isar.autoIncrement;
  late String text;
  DateTime? dueAt;
  bool isFulfilled = false;
  DateTime? fulfilledAt;
  late String source;           // journal | coach | manual | goal
  String? sourceEntityId;
  late DateTime createdAt;
}
```

### 13.2 Commitment Sources

| Source | Detection |
|--------|-----------|
| `manual` | User types in coach chat: "Men ... qilaman" |
| `journal` | Keyword extract: "men", "reja", "qilaman", "maqsadim" |
| `coach` | User confirms coach suggestion |
| `goal` | Goal creation with target date |

### 13.3 CommitmentExtractor

```dart
class CommitmentExtractor {
  List<String> extractFromJournal(String content) {
    // Regex + keyword patterns for Uzbek
    // "Ertaga 6 da uyg'onaman" → commitment
    // "Bu hafta 3 marta sport qilaman" → commitment
  }
}
```

### 13.4 Lifecycle

```
Detected → Store CoachCommitmentEntity
         → Surface in daily advice if due within 48h
         → User completes matching action → isFulfilled = true
         → Missed + 24h → empathetic follow-up (not guilt)
         → Fulfilled → XP bonus (spiritual +10)
```

---

## 14. Voice & Conversation

### 14.1 CoachConversationEntity (Shipped)

| Field | Description |
|-------|-------------|
| `role` | user \| coach |
| `message` | Text content |
| `timestamp` | Indexed |
| `inputType` | text \| voice |
| `contextType` | daily_checkin \| voice_chat \| weekly_review \| twin_insight \| twin_chat |

### 14.2 Voice Coach Flow

```
VoiceCoachScreen
  → STT (voice_ai_service)
  → lifeTwinProfileProvider (full profile)
  → AiCoachFacade.chat(transcript, inputType: 'voice')
  → TTS response (optional Phase 4+)
  → Save CoachConversationEntity × 2
```

### 14.3 Conversation Context Window

For chat LLM calls, include:
- Last 6 messages from `CoachConversationRepository`
- Current `CoachContext` summary (token-budgeted)
- Top 3 memories
- User profile block

**Max history tokens:** 1,500

---

## 15. Database Schema

### 15.1 Isar Collections (Coach-related)

| Collection | Status | Purpose |
|------------|--------|---------|
| `AiMemoryEntity` | ✅ Shipped | Long-term learned insights |
| `CoachConversationEntity` | ✅ Shipped | Chat history |
| `TwinProfileEntity` | ✅ Shipped | Computed personality |
| `CoachCommitmentEntity` | Phase 4 | User promises |
| `CoachPreferenceEntity` | Phase 4 | Tone, dismissals, quotas |
| `CoachAdviceLogEntity` | Phase 4 optional | Advice audit + feedback |

### 15.2 CoachPreferenceEntity (Phase 4)

```dart
@collection
class CoachPreferenceEntity {
  Id id = Isar.autoIncrement;
  late String preferredTone;         // encouraging | direct | gentle
  late int dailyLlmQuotaUsed;        // reset daily
  late DateTime quotaResetAt;
  late String dismissedPatternsJson; // JSON array of pattern IDs
  bool interventionEnabled = true;
  bool weeklyReviewPush = true;
}
```

### 15.3 Supabase (V4 Sync)

```sql
CREATE TABLE coach_memories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  category TEXT NOT NULL,
  insight TEXT NOT NULL,
  confidence REAL NOT NULL,
  reference_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  last_referenced_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE coach_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  role TEXT NOT NULL,
  message TEXT NOT NULL,
  input_type TEXT DEFAULT 'text',
  context_type TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE coach_commitments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  text TEXT NOT NULL,
  due_at TIMESTAMPTZ,
  is_fulfilled BOOLEAN DEFAULT FALSE,
  source TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE user_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) UNIQUE,
  persona TEXT,
  chronotype TEXT,
  productivity_style TEXT,
  coach_tone TEXT DEFAULT 'encouraging',
  traits JSONB,
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

---

## 16. Provider & Infrastructure

### 16.1 AiOrchestrator (Shipped)

**File:** `lib/core/ai/ai_orchestrator.dart`

| Feature | Behavior |
|---------|----------|
| Multi-provider | Gemini → OpenAI → OpenRouter → Groq → Cloudflare |
| Key rotation | `AiRotationState` — per provider, model, key index |
| Retry | Quota/rate-limit → advance key → advance model → advance provider |
| Timeout | Configurable `requestTimeoutMs` |
| Fallback | Throws only after all routes exhausted |

### 16.2 AiService Facade

```dart
// Used by coach — wraps AiOrchestrator
class AiService {
  Future<String?> chat({
    required String systemPrompt,
    required String prompt,
    int? maxOutputTokens,
    double temperature = 0.7,
  });
}
```

### 16.3 LlmSynthesizer

```dart
class LlmSynthesizer {
  Future<CoachAdvice?> synthesize({
    required CoachContext context,
    required List<CoachAdvice> candidates,
    required CoachTask task,
  }) async {
    final messages = [
      AiMessage(role: 'system', content: PromptRegistry.system(task, context.profile)),
      AiMessage(role: 'user', content: ContextSummarizer.toJson(context)),
      if (candidates.isNotEmpty)
        AiMessage(role: 'user', content: 'Top candidates: ${candidates.map((c) => c.headline).join("; ")}'),
    ];

    final result = await _orchestrator.complete(AiCompletionRequest(
      messages: messages,
      maxOutputTokens: task.maxOutputTokens,
      temperature: task.temperature,
    ));

    return CoachAdviceJsonParser.parse(result.text) ?? _fallbackFromCandidates(candidates);
  }
}
```

### 16.4 API Key Security

| Risk | Mitigation |
|------|------------|
| `assets/ai.env` in APK | Build-time injection; empty in release |
| PII in prompts | Never send user name to cloud if opted out |
| Conversation logs | Local only until V4 sync with encryption |

---

## 17. UI Surfaces & Providers

### 17.1 Surfaces

| Surface | Route / location | Data source |
|---------|------------------|-------------|
| Dashboard coach card | `/` | `dailyCoachAdviceProvider` |
| Coach screen | `/boshqa/murabbiy` | `coachRecommendationsProvider` |
| Voice coach | `/boshqa/murabbiy/ovoz` | `AiCoachFacade.chat()` |
| CEO review | `/boshqa/ceo-hisobot` | `weeklyCoachReviewProvider` |
| Life Twin | `/boshqa/life-twin` | Redirect → coach with profile tab |
| Decision assistant | `/boshqa/qaror-yordam` | Filtered recommendations |
| Intervention banner | App shell | `activeInterventionProvider` |

### 17.2 Provider Map (Target)

```dart
final coachContextProvider = FutureProvider<CoachContext>(...);
final dailyCoachAdviceProvider = FutureProvider<CoachAdvice>(...);
final coachRecommendationsProvider = FutureProvider<List<CoachAdvice>>(...);
final weeklyCoachReviewProvider = FutureProvider<CoachReview>(...);
final monthlyCoachReviewProvider = FutureProvider<CoachReview>(...);
final activeInterventionProvider = Provider<CoachIntervention?>(...);
final coachMemoriesProvider = StreamProvider<List<AiMemoryEntity>>(...);
final userProfileProvider = FutureProvider<UserProfile>(...);
```

### 17.3 Invalidation (`provider_sync.dart`)

Invalidate on:
- Task/habit/journal/finance/inbox/time log changes
- `aiTipsProvider` (legacy, deprecate)
- `coachContextProvider`
- `dailyCoachAdviceProvider`
- `lifeBrainInsightsProvider` (until merged)
- `lifeTwinProfileProvider`

---

## 18. Premium Gating & Quotas

| Feature | Free | Premium |
|---------|------|---------|
| Daily rule-based advice | ✅ Unlimited | ✅ |
| Daily LLM advice | 1/day | Unlimited |
| Weekly LLM review | Rule bullets only | Full narrative |
| Monthly review | ❌ | ✅ |
| Correlation insights visible | 3 | All |
| Voice coach | 3 sessions/day | Unlimited |
| Interventions | Basic (level 1) | Full ladder + focus |
| Chat history | 30 days local | Unlimited + sync (V4) |

### Quota tracking

```dart
// CoachPreferenceEntity.dailyLlmQuotaUsed
// Reset at midnight local
if (!isPremium && quotaUsed >= 1) skip LlmSynthesizer;
```

---

## 19. Security & Trust

### 19.1 Trust UI Pattern

Every insight displays:
- **Evidence bullets** — data points used
- **Confidence badge** — Yuqori / O'rta / Past
- **Action button** — one tap
- **Feedback** — Foydali / Foydasi yo'q / Yopish

### 19.2 Wellness Disclaimers

Coach must never:
- Diagnose medical conditions
- Recommend medication
- Claim certainty on <14 days data without disclaimer

Show on coach screen footer:
*"REJABON AI tibbiy maslahat bermaydi. Jiddiy holatlar uchun mutaxassisga murojaat qiling."*

### 19.3 Privacy

- All coach data local-first (Isar)
- LLM calls send summarized context, not raw database exports
- User can delete all memories in settings
- Opt-out of LLM: rules-only mode

---

## 20. Testing Strategy

| Test | Type | File |
|------|------|------|
| RuleEvaluator all branches | Unit | `recommendation_engine_test.dart` |
| Pattern confidence scoring | Unit | `pattern_engine_test.dart` |
| JSON parse fallback | Unit | `llm_synthesizer_test.dart` |
| Priority ranking order | Unit | `priority_ranker_test.dart` |
| Memory retrieval scoring | Unit | `memory_retriever_test.dart` |
| Coach offline → rules only | Integration | `coach_offline_test.dart` |
| Context assemble <200ms | Benchmark | `context_assembler_benchmark.dart` |
| No PII in LLM payload | Security | manual review |
| Commitment extract Uzbek | Unit | `commitment_extractor_test.dart` |

### Fixture-based context tests

```dart
test('burnout outranks overdue tasks', () {
  final ctx = CoachContextFixture.withBurnout();
  final advice = RecommendationEngine().generateSync(ctx);
  expect(advice.first.id, startsWith('burnout_'));
});
```

---

## 21. Phase 4 Implementation Sprints

| Sprint | Weeks | Deliverables | Exit criteria |
|--------|-------|--------------|---------------|
| **P4-S1** | 1–2 | Expand `CoachContext`; `RecommendationEngine` with L0 rules; unify `LifeBrainFacade` | Dashboard shows evidence-based advice |
| **P4-S2** | 3–4 | `LlmSynthesizer` JSON prompts; wire `analyzeAndStore` weekly | LLM advice with JSON fallback |
| **P4-S3** | 5–6 | `TwinProfile` in context; `MemoryRetriever`; tone adaptation | Coach cites memory + profile |
| **P4-S4** | 7–8 | `CoachCommitmentEntity`; extractor; follow-up loop | Commitments surface in advice |
| **P4-S5** | 9–10 | `InterventionEngine`; shell banner; escalation | Procrastination trigger works |
| **P4-S6** | 11–12 | Weekly/monthly review; voice through facade; deprecate parallel routes | Single coach brain; 6 routes merged |

### Definition of Done (Coach features)

- [ ] Works offline (L0+L1 minimum)
- [ ] Evidence shown in UI
- [ ] One action per insight
- [ ] Uzbek strings in `app_strings.dart`
- [ ] Provider invalidation in `provider_sync.dart`
- [ ] Unit test for service logic
- [ ] LLM JSON parse fallback tested
- [ ] Memory write on weekly sync
- [ ] No `getAll()` in hot path

---

## Appendix A — Example Insights (Target Quality)

| Insight | Evidence required | Confidence |
|---------|-------------------|------------|
| "Your productivity falls after sleeping less than 6 hours." | 14+ days sleep + task data | High |
| "You perform best on Tuesday mornings." | 21+ days hourly completion | High |
| "You are 34% more likely to skip habits after stressful days." | mood proxy + habit misses, 21 days | Medium |
| "Finance: spending up 22% vs 4-week avg." | 30+ transactions | Medium |
| "Inbox backlog correlates with 2× overdue tasks." | 7+ days inbox + task data | Medium |
| "Career goal inactive 9 days — drift detected." | goal entity + task FK | High |

---

## Appendix B — Quick Reference

```
BRAIN:     AiCoachFacade
CONTEXT:   LifeContextAssembler → CoachContext
RULES:     RecommendationEngine L0 (AiCoachService rules)
PATTERNS:  CoachPatternEngine + MoodTrendService
MEMORY:    AiMemoryEntity via MemoryRetriever
PROFILE:   TwinProfileEntity + onboardingPersona
LLM:       LlmSynthesizer → AiOrchestrator → JSON CoachAdvice
RANK:      PriorityRanker (burnout > mood > overdue > rules > patterns)
SURFACE:   DashboardCoachCard, /boshqa/murabbiy, interventions
OFFLINE:   L0 + L1 always; L2 only when configured + quota
```

---

*REJABON AI Life Coach — Phase 4. Evidence first. Action always. Uzbek heart.*
