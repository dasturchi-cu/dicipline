/// Emoji to'plamlari — REJABON AI uchun.
class EmojiCatalog {
  EmojiCatalog._();

  static const recentKey = 'recent_emojis';
  static const maxRecent = 24;

  static const categories = <String, List<String>>{
    'Ish': ['💻', '📱', '🖥️', '📧', '📝', '📊', '📈', '🎯', '🚀', '💼', '📅', '⏰'],
    'Ta\'lim': ['📚', '✏️', '🎓', '📖', '🧠', '🔬', '📝', '🌍', '🗣️', '🎯', '📐', '💡'],
    'Sog\'liq': ['💪', '🏃', '🧘', '😴', '💧', '🥗', '🍎', '❤️', '🏋️', '🚴', '⚽', '🧘‍♀️'],
    'Moliya': ['💰', '💳', '🏦', '📉', '📈', '💵', '🪙', '🛒', '🏠', '🚗', '✈️', '🎁'],
    'Hayot': ['🏠', '👨‍👩‍👧', '🎉', '🎵', '🎬', '📷', '✈️', '🌟', '☕', '🍕', '🎮', '📱'],
    'Maqsad': ['🎯', '🏆', '⭐', '🔥', '💎', '🌱', '📌', '✅', '🚀', '💡', '📈', '🎖️'],
  };

  static List<String> get all {
    return categories.values.expand((list) => list).toSet().toList();
  }
}
