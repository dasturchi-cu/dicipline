# REJABON AI — Ma'lumot Arxitekturasi

## Navigatsiya ierarxiyasi

```
REJABON AI
├── Boshqaruv paneli (/)
├── Vazifalar (/vazifalar)
│   ├── Vazifa yaratish
│   └── Vazifa tahrirlash
├── Hayot (/hayot)
│   ├── Odatlar (/hayot/odatlar)
│   ├── Maqsadlar (/hayot/maqsadlar)
│   ├── Kundalik (/hayot/kundalik)
│   ├── Mashq (/hayot/mashq)
│   └── Ta'lim (/hayot/ta'lim)
├── Moliya (/moliya)
├── Boshqa (/boshqa)
│   ├── Eslatmalar (/boshqa/eslatmalar)
│   ├── Kalendar (/boshqa/kalendar)
│   ├── Hujjatlar (/boshqa/hujjatlar)
│   ├── AI Murabbiy (/boshqa/murabbiy)
│   └── Sozlamalar (/boshqa/sozlamalar)
```

## Bottom Navigation (5 tab)

| Tab | Yo'l | Ikonka |
|-----|------|--------|
| Bosh sahifa | / | home |
| Vazifalar | /vazifalar | check_circle |
| Hayot | /hayot | favorite |
| Moliya | /moliya | account_balance_wallet |
| Boshqa | /boshqa | more_horiz |

## Kontent turlari

| Tur | Saqlash | Modul |
|-----|---------|-------|
| Vazifa | Isar TaskEntity | Vazifalar |
| Odat | Isar HabitEntity | Odatlar |
| Maqsad | Isar GoalEntity | Maqsadlar |
| Eslatma | Isar NoteEntity | Eslatmalar |
| Kundalik | Isar JournalEntity | Kundalik |
| Mashq | Isar WorkoutEntity | Mashq |
| Ta'lim | Isar StudyEntity | Ta'lim |
| Moliya | Isar FinanceEntity | Moliya |
| Tadbir | Isar EventEntity | Kalendar |
| Hujjat | Isar DocumentEntity | Hujjatlar |

## Qidiruv nuqtalari

- Eslatmalar: global qidiruv
- Vazifalar: kategoriya filtri
- Hujjatlar: nom bo'yicha

## Ma'lumot oqimi

```
UI (Widget) → Provider (Riverpod) → Repository → Isar Database
                                      ↓
                              SharedPreferences (sozlamalar)
                              Secure Storage (maxfiy)
```
