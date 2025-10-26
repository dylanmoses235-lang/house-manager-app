import 'package:hive/hive.dart';

part 'declutter_day.g.dart';

@HiveType(typeId: 2)
class DeclutterDay extends HiveObject {
  @HiveField(0)
  final int day;

  @HiveField(1)
  final String area;

  @HiveField(2)
  final String task;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime? completedDate;

  DeclutterDay({
    required this.day,
    required this.area,
    required this.task,
    this.isCompleted = false,
    this.completedDate,
  });
}
