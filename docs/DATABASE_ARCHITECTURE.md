# REJABON AI — Ma'lumotlar Bazasi Arxitekturasi

## Texnologiya: Isar Database

Local-first, offline, tez NoSQL ma'lumotlar bazasi.

## Kolleksiyalar

### TaskEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| title | String | ✅ |
| description | String? | |
| isCompleted | bool | ✅ |
| priority | enum (past/o'rta/yuqori) | ✅ |
| category | String | ✅ |
| dueDate | DateTime? | ✅ |
| createdAt | DateTime | ✅ |
| updatedAt | DateTime | |

### HabitEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| name | String | ✅ |
| icon | String | |
| color | int | |
| completedDates | List\<DateTime\> | |
| createdAt | DateTime | |

### GoalEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| title | String | ✅ |
| description | String? | |
| progress | double (0-100) | |
| milestones | List\<Milestone\> (embedded) | |
| targetDate | DateTime? | ✅ |
| createdAt | DateTime | |

### NoteEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| title | String | ✅ |
| content | String | ✅ (full-text) |
| tags | List\<String\> | |
| createdAt | DateTime | ✅ |
| updatedAt | DateTime | |

### JournalEntryEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| date | DateTime | ✅ unique/day |
| content | String | |
| mood | int (1-5) | |
| createdAt | DateTime | |

### WorkoutEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| exerciseName | String | ✅ |
| durationMinutes | int | |
| caloriesBurned | int | |
| date | DateTime | ✅ |
| notes | String? | |

### StudySubjectEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| name | String | ✅ |
| color | int | |
| totalMinutes | int | |
| targetMinutes | int | |

### StudySessionEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| subjectId | int | ✅ |
| durationMinutes | int | |
| date | DateTime | ✅ |
| notes | String? | |

### FinanceTransactionEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| type | enum (daromad/xarajat) | ✅ |
| amount | double | |
| category | String | ✅ |
| description | String? | |
| date | DateTime | ✅ |

### CalendarEventEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| title | String | ✅ |
| description | String? | |
| startTime | DateTime | ✅ |
| endTime | DateTime | |
| hasReminder | bool | |
| reminderMinutes | int | |

### DocumentEntity
| Maydon | Tur | Indeks |
|--------|-----|--------|
| id | Id | PK |
| title | String | ✅ |
| description | String? | |
| type | String | ✅ |
| createdAt | DateTime | |

## Munosabatlar

- StudySession → StudySubject (subjectId FK)
- Boshqa kolleksiyalar mustaqil

## Indeks strategiyasi

- Barcha `createdAt`, `date` maydonlar indekslangan
- Qidiruv maydonlari (`title`, `name`) indekslangan
- `isCompleted`, `type`, `category` filtr indekslari

## Backup tizimi

```json
{
  "version": "1.0.0",
  "exportedAt": "2026-06-21T12:00:00",
  "tasks": [...],
  "habits": [...],
  "goals": [...],
  "notes": [...],
  "journal": [...],
  "workouts": [...],
  "studySubjects": [...],
  "studySessions": [...],
  "finance": [...],
  "events": [...],
  "documents": [...]
}
```

## Restore tizimi

1. JSON fayl o'qiladi
2. Validatsiya (versiya, schema)
3. Mavjud ma'lumotlar tozalash (ixtiyoriy)
4. Batch import Isar ga
5. Providerlar yangilanadi

## Migratsiya

- Isar schema versiyasi: 1
- Kelajak migratsiyalar: `Isar.open()` da schema versiya oshirish

## SharedPreferences (Sozlamalar)

- themeMode: light/dark/system
- onboardingCompleted: bool
- notificationEnabled: bool
- userName: String

## Flutter Secure Storage

- backupEncryptionKey (kelajak)
- appLockPin (kelajak)
