import 'package:hive/hive.dart';

part 'zone_task.g.dart';

@HiveType(typeId: 0)
class ZoneTask extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String task;

  @HiveField(2)
  final String howTo;

  @HiveField(3)
  final String zone;

  @HiveField(4)
  final String day;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  String? notes;

  ZoneTask({
    required this.id,
    required this.task,
    required this.howTo,
    required this.zone,
    required this.day,
    this.isCompleted = false,
    this.notes,
  });
}
