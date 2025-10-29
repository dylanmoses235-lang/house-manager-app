import 'package:hive/hive.dart';

part 'supply_item.g.dart';

@HiveType(typeId: 3)
class SupplyItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String category; // 'cleaning', 'pantry', 'pet', 'other'

  @HiveField(3)
  bool isNeeded;

  @HiveField(4)
  bool isPurchased;

  @HiveField(5)
  int quantity;

  @HiveField(6)
  String? notes;

  @HiveField(7)
  DateTime? addedDate;

  SupplyItem({
    required this.id,
    required this.name,
    required this.category,
    this.isNeeded = true,
    this.isPurchased = false,
    this.quantity = 1,
    this.notes,
    DateTime? addedDate,
  }) : addedDate = addedDate ?? DateTime.now();
}
