import 'package:isar/isar.dart';

import '../constants/app_categories.dart';
import '../database/schemas/finance_transaction_entity.dart';

class FinanceBalance {
  const FinanceBalance({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });

  final double totalIncome;
  final double totalExpense;
  final double balance;
}

class CategoryStatistics {
  const CategoryStatistics({
    required this.category,
    required this.income,
    required this.expense,
  });

  final String category;
  final double income;
  final double expense;
}

class FinanceRepository {
  FinanceRepository(this._isar);

  final Isar _isar;

  static const int typeIncome = 0;
  static const int typeExpense = 1;

  static double totalIncome(List<FinanceTransactionEntity> transactions) {
    return transactions
        .where((tx) => tx.type == typeIncome)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  static double totalExpense(List<FinanceTransactionEntity> transactions) {
    return transactions
        .where((tx) => tx.type == typeExpense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  static double balance(List<FinanceTransactionEntity> transactions) {
    return totalIncome(transactions) - totalExpense(transactions);
  }

  Stream<List<FinanceTransactionEntity>> watchAll() {
    return _isar.financeTransactionEntitys
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  Future<FinanceTransactionEntity?> getById(int id) {
    return _isar.financeTransactionEntitys.get(id);
  }

  Future<List<FinanceTransactionEntity>> getAll() {
    return _isar.financeTransactionEntitys.where().sortByDateDesc().findAll();
  }

  Future<FinanceBalance> getBalance() async {
    final transactions = await getAll();
    var income = 0.0;
    var expense = 0.0;
    for (final tx in transactions) {
      if (tx.type == typeIncome) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }
    return FinanceBalance(
      totalIncome: income,
      totalExpense: expense,
      balance: income - expense,
    );
  }

  Future<List<CategoryStatistics>> getStatisticsByCategory() async {
    final transactions = await getAll();
    final map = <String, CategoryStatistics>{};

    for (final tx in transactions) {
      final existing = map[tx.category];
      if (existing == null) {
        map[tx.category] = CategoryStatistics(
          category: tx.category,
          income: tx.type == typeIncome ? tx.amount : 0,
          expense: tx.type == typeExpense ? tx.amount : 0,
        );
      } else {
        map[tx.category] = CategoryStatistics(
          category: tx.category,
          income: existing.income + (tx.type == typeIncome ? tx.amount : 0),
          expense: existing.expense + (tx.type == typeExpense ? tx.amount : 0),
        );
      }
    }

    final results = map.values.toList()
      ..sort((a, b) => b.expense.compareTo(a.expense));
    return results;
  }

  Future<FinanceTransactionEntity> createIncome({
    required double amount,
    String? category,
    String? description,
    DateTime? date,
  }) {
    return create(
      type: typeIncome,
      amount: amount,
      category: category ?? AppCategories.incomeOther,
      description: description,
      date: date,
    );
  }

  Future<FinanceTransactionEntity> createExpense({
    required double amount,
    String? category,
    String? description,
    DateTime? date,
  }) {
    return create(
      type: typeExpense,
      amount: amount,
      category: category ?? AppCategories.expenseOther,
      description: description,
      date: date,
    );
  }

  Future<FinanceTransactionEntity> create({
    required int type,
    required double amount,
    required String category,
    String? description,
    DateTime? date,
  }) async {
    final transaction = FinanceTransactionEntity.create(
      type: type,
      amount: amount,
      category: category,
      description: description,
      date: date,
    );
    await _isar.writeTxn(() async {
      await _isar.financeTransactionEntitys.put(transaction);
    });
    return transaction;
  }

  Future<FinanceTransactionEntity> save(
    FinanceTransactionEntity transaction,
  ) async {
    await _isar.writeTxn(() async {
      await _isar.financeTransactionEntitys.put(transaction);
    });
    return transaction;
  }

  Future<FinanceTransactionEntity> update(
    FinanceTransactionEntity transaction,
  ) async {
    await _isar.writeTxn(() async {
      await _isar.financeTransactionEntitys.put(transaction);
    });
    return transaction;
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.financeTransactionEntitys.delete(id));
  }
}
