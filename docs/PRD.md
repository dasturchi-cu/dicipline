# REJABON AI — Mahsulot Talablari Hujjati (PRD)

## Versiya: 1.0.0 | Sana: 2026-06-21

---

## 1. Umumiy ma'lumot

| Maydon | Qiymat |
|--------|--------|
| Mahsulot nomi | REJABON AI |
| Platforma | Android (asosiy), iOS (keyingi) |
| Til | O'zbek (Lotin) |
| Arxitektura | Local-first, offline-first |

## 2. Foydalanuvchi muammolari

- Ko'p ilova ishlatish charchatadi
- Ma'lumotlar sinxronlanmaydi yoki yo'qoladi
- Ingliz tilidagi ilovalar noqulay
- Murakkab interfeyslar chalg'itadi

## 3. Funksional talablar

### 3.1 Boshqaruv paneli
- Kunlik xulosa: vazifalar, odatlar, moliya
- AI murabbiy tavsiyasi (bosilganda tegishli modulga o'tish)
- Tez harakatlar paneli
- Sodda, fokuslangan interfeys — ortiqcha bezaklarsiz

### 3.2 Vazifalar
- Yaratish, tahrirlash, o'chirish, bajarish
- Ustuvorlik (past, o'rta, yuqori)
- Kategoriyalar
- Muddat belgilash

### 3.3 Odatlar
- Kunlik kuzatuv
- Streak (ketma-ket kunlar)
- Statistika va grafiklar

### 3.4 Maqsadlar
- Progress kuzatuvi (0–100%)
- Bosqichlar (milestones)
- Muddat

### 3.5 Eslatmalar
- Sarlavha va matn
- Qidiruv
- Teglar

### 3.6 Kundalik
- Kunlik yozuvlar
- Kayfiyat kuzatuvi (1–5)
- Sana bo'yicha ko'rish

### 3.7 Jismoniy mashq
- Mashqlar ro'yxati
- Sessiya tarixi
- Statistika

### 3.8 Ta'lim
- Fanlar
- O'qish sessiyalari
- Progress

### 3.9 Moliya
- Daromad va xarajat
- Kategoriyalar
- Statistika va balans

### 3.10 Kalendar
- Tadbirlar
- Eslatmalar

### 3.11 Shaxsiy hujjatlar
- Hujjat saqlash (nom, tavsif, tur)

### 3.12 AI Murabbiy
- Kunlik tavsiyalar
- Mahalliy ma'lumotlarga asoslangan tahlil

### 3.13 Sozlamalar
- Zaxira nusxa (backup)
- Tiklash (restore)
- Mavzu (yorug'/qorong'u/tizim)
- Bildirishnomalar

## 4. Nofunksional talablar

| Talab | Mezon |
|-------|-------|
| Ochilish vaqti | < 2 soniya |
| Offline ishlash | 100% funksiyalar |
| Ma'lumot saqlash | Doimiy (Isar) |
| Xavfsizlik | Secure Storage |
| Test qamrovi | > 70% kritik yo'llar |

## 5. Cheklovlar

- Supabase ishlatilmaydi
- Internet talab qilinmaydi (AI mahalliy)
- Barcha UI o'zbek tilida

## 6. Qabul mezonlari

- [ ] Barcha modullar ishlaydi
- [ ] Backup/restore ishlaydi
- [ ] flutter analyze xatosiz
- [ ] Barcha testlar o'tadi
- [ ] Release APK muvaffaqiyatli yig'iladi
