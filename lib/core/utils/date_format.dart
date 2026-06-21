import 'package:intl/intl.dart';

/// O'zbek tilida sana formatlash.
class AppDateFormat {
  AppDateFormat._();

  static const _uzMonths = [
    'yanvar',
    'fevral',
    'mart',
    'aprel',
    'may',
    'iyun',
    'iyul',
    'avgust',
    'sentyabr',
    'oktyabr',
    'noyabr',
    'dekabr',
  ];

  static const _uzWeekdays = [
    'dushanba',
    'seshanba',
    'chorshanba',
    'payshanba',
    'juma',
    'shanba',
    'yakshanba',
  ];

  static String formatDate(DateTime date) {
    return '${date.day} ${_uzMonths[date.month - 1]} ${date.year}';
  }

  static String formatMonthYear(DateTime date) {
    return '${_uzMonths[date.month - 1]} ${date.year}';
  }

  static String formatDateTime(DateTime date) {
    final time = DateFormat('HH:mm').format(date);
    return '${formatDate(date)}, $time';
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatWeekday(DateTime date) {
    return _uzWeekdays[date.weekday - 1];
  }

  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isToday(DateTime date) => isSameDay(date, DateTime.now());
}
