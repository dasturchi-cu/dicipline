# REJABON AI — Texnik Arxitektura

## Umumiy arxitektura

```
┌─────────────────────────────────────────┐
│              Presentation               │
│  (Screens, Widgets, GoRouter)           │
├─────────────────────────────────────────┤
│              Application                │
│  (Riverpod Providers, Notifiers)        │
├─────────────────────────────────────────┤
│                Domain                   │
│  (Entities, Repository Interfaces)      │
├─────────────────────────────────────────┤
│                 Data                    │
│  (Isar DAOs, Repository Impl, Backup)   │
├─────────────────────────────────────────┤
│              Infrastructure             │
│  (Isar DB, Secure Storage, Prefs, Notif) │
└─────────────────────────────────────────┘
```

## Texnologiya stack

| Qatlam | Texnologiya |
|--------|-------------|
| Framework | Flutter 3.38+ |
| Til | Dart 3.10+ |
| State | flutter_riverpod |
| Routing | go_router |
| DB | isar + isar_flutter_libs |
| Sozlamalar | shared_preferences |
| Xavfsizlik | flutter_secure_storage |
| Bildirishnomalar | flutter_local_notifications |
| Grafiklar | fl_chart |
| UUID | uuid |
| Sana | intl |
| Fayl | path_provider, share_plus, file_picker |

## Loyiha strukturasi

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── database/
│   │   ├── isar_service.dart
│   │   └── schemas/
│   ├── router/
│   │   └── app_router.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_typography.dart
│   ├── backup/
│   │   └── backup_service.dart
│   ├── notifications/
│   │   └── notification_service.dart
│   └── utils/
├── features/
│   ├── onboarding/
│   ├── dashboard/
│   ├── tasks/
│   ├── habits/
│   ├── goals/
│   ├── notes/
│   ├── journal/
│   ├── workout/
│   ├── study/
│   ├── finance/
│   ├── calendar/
│   ├── documents/
│   ├── ai_coach/
│   └── settings/
└── shared/
    └── widgets/
```

## Dizayn patternlar

- **Clean Architecture** — qatlamlar ajratilgan
- **Feature-first** — har modul mustaqil
- **Repository Pattern** — ma'lumot abstraksiyasi
- **Provider Pattern** — Riverpod DI
- **SOLID** — barcha tamoyillar

## Routing

GoRouter shell route bilan bottom navigation:
- `/` — Dashboard
- `/vazifalar` — Tasks
- `/hayot/*` — Life hub
- `/moliya` — Finance
- `/boshqa/*` — More hub

## Xavfsizlik

- Ma'lumotlar faqat qurilmada (Isar)
- Secure Storage — maxfiy sozlamalar
- Backup fayl — foydalanuvchi nazorati
- Network talab qilinmaydi

## Performance

- Isar indekslar — tez qidiruv
- Lazy loading — ro'yxatlar
- const widgets — rebuild kamaytirish
- Isar watch — reaktiv UI

## Build

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build apk --release
```
