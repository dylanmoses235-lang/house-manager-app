import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 13)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String category; // 'cleaning_supplies', 'maintenance', 'groceries', 'utilities', 'other'

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String? store;

  @HiveField(6)
  String? receiptPhotoPath;

  @HiveField(7)
  List<ExpenseItem> items;

  @HiveField(8)
  String? notes;

  @HiveField(9)
  bool isRecurring;

  @HiveField(10)
  int? recurringIntervalDays;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    this.store,
    this.receiptPhotoPath,
    List<ExpenseItem>? items,
    this.notes,
    this.isRecurring = false,
    this.recurringIntervalDays,
  }) : items = items ?? [];
}

@HiveType(typeId: 14)
class ExpenseItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double price;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String? category;

  ExpenseItem({
    required this.name,
    required this.price,
    required this.quantity,
    this.category,
  });

  double get total => price * quantity;
}

@HiveType(typeId: 15)
class Budget extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String category;

  @HiveField(2)
  double monthlyLimit;

  @HiveField(3)
  bool alertWhenNearLimit;

  @HiveField(4)
  double? alertThresholdPercent; // Alert when at X% of budget

  Budget({
    required this.id,
    required this.category,
    required this.monthlyLimit,
    this.alertWhenNearLimit = true,
    this.alertThresholdPercent = 80.0,
  });
}
