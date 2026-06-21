/// Qoidaviy tahlil — AI bo'lmasa ham ishlaydi.
class CaptureSuggestion {
  const CaptureSuggestion({
    required this.action,
    required this.reason,
    required this.confidence,
  });

  final String action;
  final String reason;
  final double confidence;
}

class CaptureProcessingService {
  const CaptureProcessingService();

  CaptureSuggestion analyze({
    required String text,
    required String captureType,
  }) {
    final lower = text.toLowerCase().trim();

    if (captureType == 'link') {
      return const CaptureSuggestion(
        action: 'brain',
        reason: 'Havola — ikkinchi miyaga saqlash tavsiya etiladi',
        confidence: 0.9,
      );
    }

    if (captureType == 'idea') {
      return const CaptureSuggestion(
        action: 'brain',
        reason: 'G\'oya — keyinroq tartibga solish uchun inboxda',
        confidence: 0.85,
      );
    }

    if (_hasAny(lower, ['vazifa', 'qilish', 'bajar', 'ertaga', 'bugun'])) {
      return const CaptureSuggestion(
        action: 'task',
        reason: 'Vazifa ko\'rinishidagi matn',
        confidence: 0.8,
      );
    }

    if (_hasAny(lower, ['maqsad', 'erish', 'yil', 'oy', 'reja'])) {
      return const CaptureSuggestion(
        action: 'goal',
        reason: 'Uzoq muddatli maqsad ko\'rinishi',
        confidence: 0.75,
      );
    }

    if (_hasAny(lower, ['odat', 'har kuni', 'kunlik', 'streak'])) {
      return const CaptureSuggestion(
        action: 'habit',
        reason: 'Odat yaratish uchun mos',
        confidence: 0.75,
      );
    }

    if (_hasAny(
        lower, ['o\'qish', 'ta\'lim', 'dars', 'ielts', 'ingliz', 'kurs'])) {
      return const CaptureSuggestion(
        action: 'learning',
        reason: 'Ta\'lim materiallari uchun',
        confidence: 0.8,
      );
    }

    if (_hasAny(lower, ['kod', 'dastur', 'program', 'flutter', 'python'])) {
      return const CaptureSuggestion(
        action: 'learning',
        reason: 'Dasturlash bo\'yicha yozuv',
        confidence: 0.7,
      );
    }

    return const CaptureSuggestion(
      action: 'brain',
      reason: 'Umumiy ma\'lumot — ikkinchi miyada saqlash',
      confidence: 0.6,
    );
  }

  static String emojiForType(String captureType) => switch (captureType) {
        'note' => '📝',
        'voice' => '🎙️',
        'photo' => '📸',
        'link' => '🔗',
        'document' => '📄',
        'idea' => '💡',
        _ => '📥',
      };

  static bool _hasAny(String text, List<String> keywords) {
    for (final k in keywords) {
      if (text.contains(k)) return true;
    }
    return false;
  }
}
