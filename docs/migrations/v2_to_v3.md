# Migration v2 → v3 (Phase 2)

**Version:** 3  
**Date:** 2026-06-21

## New Collections

- `FutureLetterEntity` — time-capsule letters to future self
- `PartnershipEntity` — local accountability partners + invite codes
- `CoachConversationEntity` — Life Twin / voice coach chat history

## Features Enabled

- AI Life Twin (`LifeTwinService`, `CoachPatternEngine`)
- Future Simulator (`FutureSimulatorService`)
- Future Letters (`FutureLetterService`)
- Voice AI (`SpeechCaptureService`, `VoiceAiService`)
- Social System (`SocialService`)

## Bootstrap

`runPhase2Bootstrap()` runs on app start:
- Delivers due future letters
- Runs `AiMemoryService.analyzeAndStore()`
- Invalidates twin/simulation providers
