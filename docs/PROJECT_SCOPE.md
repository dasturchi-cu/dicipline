# REJABON AI — Loyiha Doirasi

## Doirada (In Scope)

### MVP (v1.0)
- To'liq offline Flutter ilova
- 12 modul + sozlamalar
- Isar ma'lumotlar bazasi
- Backup/restore JSON formatida
- Local bildirishnomalar
- O'zbek tilidagi UI
- Qorong'u/yorug' mavzu
- Unit, widget, integration testlar
- Android release APK

### Dizayn
- Premium minimal UI
- Bottom navigation
- Dizayn tizimi va tokenlar
- Empty/loading/error/success holatlar

## Doiradan tashqari (Out of Scope)

- Bulut sinxronizatsiya
- Supabase/Firebase backend
- Ko'p foydalanuvchi hisob tizimi
- Onlayn to'lov integratsiyasi (v1.0)
- iOS release (v1.0 — faqat Android build)
- Real LLM API integratsiyasi
- iWatch/wearable qo'llab-quvvatlash

## Texnik chegaralar

| Resurs | Limit |
|--------|-------|
| Minimal Android | API 21+ |
| Ma'lumot bazasi | Isar (local) |
| State management | Riverpod |
| Routing | GoRouter |

## Vaqt rejasi

| Bosqich | Muddati |
|---------|---------|
| Hujjatlar | 1 kun |
| Dizayn tizimi | 1 kun |
| DB + Core | 2 kun |
| Feature modullar | 5 kun |
| Test + Build | 2 kun |

## Xavf va mitigatsiya

| Xavf | Mitigatsiya |
|------|-------------|
| Isar migratsiya | Versiyalangan schema |
| Ma'lumot yo'qolishi | Backup tizimi |
| Katta APK hajmi | ProGuard, split per ABI |
