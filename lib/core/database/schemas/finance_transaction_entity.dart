import 'package:isar/isar.dart';

part 'finance_transaction_entity.g.dart';

@collection
class FinanceTransactionEntity {
  Id id = Isar.autoIncrement;

  /// 0 = income, 1 = expense
  @Index()
  late int type;

  late double amount;

  @Index()
  late String category;

  String? description;

  @Index()
  late DateTime date;

  FinanceTransactionEntity();

  FinanceTransactionEntity.create({
    required this.type,
    required this.amount,
    required this.category,
    this.description,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'category': category,
        'description': description,
        'date': date.toIso8601String(),
      };

  static FinanceTransactionEntity fromJson(Map<String, dynamic> json) {
    final entity = FinanceTransactionEntity.create(
      type: json['type'] as int,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
