# REJABON AI — Foydalanuvchi Oqimlari

## UF-01: Vazifa yaratish

```
Bosh sahifa → [+] tugma / Vazifalar tab
    → Vazifa yaratish ekrani
    → Sarlavha kiritish (majburiy)
    → Ustuvorlik tanlash
    → Kategoriya tanlash
    → Muddat (ixtiyoriy)
    → [Saqlash]
    → Muvaffaqiyat → Vazifalar ro'yxati
```

## UF-02: Odat belgilash

```
Hayot tab → Odatlar
    → Bugungi odatlar ro'yxati
    → Odat yonidagi checkbox
    → Streak yangilanadi
    → Progress animatsiya
```

## UF-03: Moliya qo'shish

```
Moliya tab → [+ Daromad] yoki [+ Xarajat]
    → Summa kiritish
    → Kategoriya
    → Izoh (ixtiyoriy)
    → [Saqlash]
    → Balans yangilanadi
```

## UF-04: Kundalik yozish

```
Hayot → Kundalik
    → Bugungi sana (default)
    → Kayfiyat tanlash (1-5 emoji)
    → Matn yozish
    → [Saqlash]
    → "Yozuv saqlandi" xabari
```

## UF-05: Backup

```
Boshqa → Sozlamalar → Zaxira nusxa
    → [Eksport qilish]
    → Fayl joylashuvi tanlash
    → JSON yaratiladi
    → "Zaxira muvaffaqiyatli yaratildi"
```

## UF-06: Restore

```
Sozlamalar → Tiklash
    → Ogohlantirish dialog
    → Fayl tanlash
    → Ma'lumotlar import
    → Ilova qayta yuklanadi
```

## UF-07: AI Murabbiy

```
Boshqa → AI Murabbiy
    → Kunlik tavsiyalar ro'yxati
    → Har bir tavsiya modulga havola
    → Yangilash tugmasi
```

## Holatlar oqimi

| Holat | Trigger | UI |
|-------|---------|-----|
| Loading | Ma'lumot yuklanmoqda | Skeleton/shimmer |
| Empty | Ma'lumot yo'q | Illustration + CTA |
| Error | DB xatosi | Xato xabari + Qayta urinish |
| Success | Amal bajarildi | Snackbar/toast |
