import 'package:shared_preferences/shared_preferences.dart';

import 'emoji_catalog.dart';

/// So'nggi ishlatilgan emojilarni saqlaydi.
class EmojiService {
  EmojiService(this._prefs);

  final SharedPreferences _prefs;

  static Future<EmojiService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return EmojiService(prefs);
  }

  List<String> getRecent() {
    return _prefs.getStringList(EmojiCatalog.recentKey) ?? [];
  }

  Future<void> remember(String emoji) async {
    if (emoji.isEmpty) return;
    final recent = getRecent().where((e) => e != emoji).toList();
    recent.insert(0, emoji);
    await _prefs.setStringList(
      EmojiCatalog.recentKey,
      recent.take(EmojiCatalog.maxRecent).toList(),
    );
  }
}
