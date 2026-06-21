import 'package:isar/isar.dart';

import '../database/schemas/monthly_focus_entity.dart';

class MonthlyFocusRepository {
  MonthlyFocusRepository(this._isar);

  final Isar _isar;

  Stream<MonthlyFocusEntity?> watchForMonth(DateTime date) {
    final key = MonthlyFocusEntity.monthKeyFor(date);
    return _isar.monthlyFocusEntitys
        .filter()
        .monthKeyEqualTo(key)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<MonthlyFocusEntity?> getForMonth(DateTime date) async {
    final key = MonthlyFocusEntity.monthKeyFor(date);
    return _isar.monthlyFocusEntitys.filter().monthKeyEqualTo(key).findFirst();
  }

  Future<MonthlyFocusEntity> setFocus({
    required DateTime month,
    required int goalId,
    required String focusTitle,
    String emoji = '🎯',
    String? focusDescription,
  }) async {
    final key = MonthlyFocusEntity.monthKeyFor(month);
    final existing =
        await _isar.monthlyFocusEntitys.filter().monthKeyEqualTo(key).findFirst();

    final focus = existing ??
        MonthlyFocusEntity.create(
          monthKey: key,
          goalId: goalId,
          focusTitle: focusTitle,
          emoji: emoji,
          focusDescription: focusDescription,
        );

    focus.goalId = goalId;
    focus.focusTitle = focusTitle;
    focus.emoji = emoji;
    focus.focusDescription = focusDescription;
    focus.setAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.monthlyFocusEntitys.put(focus);
    });
    return focus;
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() => _isar.monthlyFocusEntitys.delete(id));
  }

  Future<List<MonthlyFocusEntity>> getAll() {
    return _isar.monthlyFocusEntitys.where().sortBySetAtDesc().findAll();
  }
}
