import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/repositories/habit_repository.dart';

import '../helpers/isar_test_helper.dart';

DateTime _day(int offset) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + offset);
}

void main() {
  late TestIsarHandle handle;
  late HabitRepository repository;

  setUpAll(() async {
    await ensureIsarCoreInitialized();
  });

  setUp(() async {
    handle = await openTestIsar();
    repository = HabitRepository(handle.isar);
  });

  tearDown(() async {
    await closeTestIsar(handle);
  });

  test('calculateStreak counts consecutive days including today', () {
    final habit = HabitEntity.create(
      name: 'O\'qish',
      completedDates: [_day(0), _day(-1), _day(-2)],
    );

    expect(repository.calculateStreak(habit), 3);
  });

  test('calculateStreak continues from yesterday when today missing', () {
    final habit = HabitEntity.create(
      name: 'Sport',
      completedDates: [_day(-1), _day(-2)],
    );

    expect(repository.calculateStreak(habit), 2);
  });

  test('calculateStreak breaks on gap', () {
    final habit = HabitEntity.create(
      name: 'Meditatsiya',
      completedDates: [_day(0), _day(-2)],
    );

    expect(repository.calculateStreak(habit), 1);
  });

  test('calculateStreak is zero with no completions', () {
    final habit = HabitEntity.create(name: 'Yangi');
    expect(repository.calculateStreak(habit), 0);
  });

  test('toggleToday adds and removes today completion', () async {
    final created = await repository.create(name: 'Suv ichish');
    expect(repository.isCompletedToday(created), isFalse);

    final done = await repository.toggleToday(created.id);
    expect(done, isNotNull);
    expect(repository.isCompletedToday(done!), isTrue);

    final undone = await repository.toggleToday(created.id);
    expect(repository.isCompletedToday(undone!), isFalse);
  });

  test('getStatistics aggregates habits and streaks', () async {
    await repository.create(name: 'A');
    final b = await repository.create(name: 'B');
    b.completedDates.add(_day(0));
    b.completedDates.add(_day(-1));
    await repository.update(b);

    final stats = await repository.getStatistics();
    expect(stats.totalHabits, 2);
    expect(stats.completedToday, 1);
    expect(stats.longestStreak, greaterThanOrEqualTo(2));
  });
}


