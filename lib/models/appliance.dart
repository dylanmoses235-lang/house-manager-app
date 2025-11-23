import 'package:hive/hive.dart';

part 'appliance.g.dart';

@HiveType(typeId: 11)
class Appliance extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String category; // 'kitchen', 'laundry', 'hvac', 'other'

  @HiveField(3)
  String? brand;

  @HiveField(4)
  String? model;

  @HiveField(5)
  DateTime? purchaseDate;

  @HiveField(6)
  DateTime? warrantyExpiry;

  @HiveField(7)
  String? serialNumber;

  @HiveField(8)
  String? photoPath;

  @HiveField(9)
  String? manualPath;

  @HiveField(10)
  List<MaintenanceRecord> maintenanceHistory;

  @HiveField(11)
  int? maintenanceIntervalDays;

  @HiveField(12)
  DateTime? lastMaintenance;

  @HiveField(13)
  String? notes;

  @HiveField(14)
  double? purchasePrice;

  Appliance({
    required this.id,
    required this.name,
    required this.category,
    this.brand,
    this.model,
    this.purchaseDate,
    this.warrantyExpiry,
    this.serialNumber,
    this.photoPath,
    this.manualPath,
    List<MaintenanceRecord>? maintenanceHistory,
    this.maintenanceIntervalDays,
    this.lastMaintenance,
    this.notes,
    this.purchasePrice,
  }) : maintenanceHistory = maintenanceHistory ?? [];

  bool get isWarrantyValid {
    if (warrantyExpiry == null) return false;
    return warrantyExpiry!.isAfter(DateTime.now());
  }

  int? get daysUntilMaintenance {
    if (lastMaintenance == null || maintenanceIntervalDays == null) return null;
    final nextMaintenance = lastMaintenance!.add(Duration(days: maintenanceIntervalDays!));
    return nextMaintenance.difference(DateTime.now()).inDays;
  }

  bool get needsMaintenance {
    final days = daysUntilMaintenance;
    return days != null && days <= 7;
  }
}

@HiveType(typeId: 12)
class MaintenanceRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String description;

  @HiveField(3)
  double? cost;

  @HiveField(4)
  String? technician;

  @HiveField(5)
  String? notes;

  MaintenanceRecord({
    required this.id,
    required this.date,
    required this.description,
    this.cost,
    this.technician,
    this.notes,
  });
}
