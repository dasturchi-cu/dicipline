/// Foydalanuvchi emoji qo'shganda sarlavhani ko'rsatish.
String displayWithEmoji({required String title, required String emoji}) {
  if (emoji.isEmpty) return title;
  return '$emoji $title';
}
