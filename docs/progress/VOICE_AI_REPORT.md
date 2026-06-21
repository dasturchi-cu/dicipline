# Voice AI Report

**Date:** 2026-06-21  
**Status:** Production-ready (STT + commands; TTS optional future)

## Overview

Voice AI Assistant supports speech-to-text input, voice commands for task/habit/plan creation, and Life Twin powered conversational responses.

## Architecture

| Component | Path |
|-----------|------|
| STT | `lib/core/voice/speech_capture_service.dart` |
| Command parser | `lib/core/voice/voice_command_parser.dart` |
| Voice service | `lib/core/voice/voice_ai_service.dart` |
| Chat history | `lib/core/database/schemas/coach_conversation_entity.dart` |
| UI | `lib/features/voice_ai/presentation/screens/voice_coach_screen.dart` |

## Voice commands

| Command pattern | Action |
|-----------------|--------|
| `vazifa qo\'sh ...` | Creates `TaskEntity` |
| `odat qo\'sh ...` | Creates `HabitEntity` |
| `reja tuz ...` | Creates/updates today `PlanEntity` |
| Other text | Life Twin chat (LLM when configured) |

Locale: `uz_UZ` (dictation mode)

## Flow

```
Mic → SpeechCaptureService → VoiceCommandParser
  ├─ create_task / create_habit / create_plan → Repository save
  └─ chat → LifeTwinService.chat() → CoachConversationEntity
```

## UI feedback

- Partial transcript shown while listening
- SnackBar on successful command actions
- Chat history from `coachConversationProvider`

## Provider

`voiceAiServiceProvider` — wired with task, habit, plan repositories

## Tests

- `test/features/voice_command_parser_test.dart` — task, habit, plan, chat fallback

## Route

`/boshqa/murabbiy/ovoz`

## Known limitations

- TTS (spoken responses) not yet implemented
- Commands use Uzbek keyword matching (not LLM intent classification)

## Related

- Decision Assistant: `/boshqa/qaror-yordam`
- Life Twin: `/boshqa/life-twin`
