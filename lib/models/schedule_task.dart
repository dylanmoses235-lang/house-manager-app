import 'package:hive/hive.dart';

part 'schedule_task.g.dart';

@HiveType(typeId: 1)
class ScheduleTask extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String time;

  @HiveField(2)
  final String task;

  @HiveField(3)
  final String details;

  @HiveField(4)
  final String dayType; // "Weekday" or "Weekend"

  @HiveField(5)
  bool isCompleted;

  ScheduleTask({
    required this.id,
    required this.time,
    required this.task,
    required this.details,
    required this.dayType,
    this.isCompleted = false,
  });
}
