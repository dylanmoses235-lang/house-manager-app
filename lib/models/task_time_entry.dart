import 'package:hive/hive.dart';

part 'task_time_entry.g.dart';

@HiveType(typeId: 10)
class TaskTimeEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String taskId;

  @HiveField(2)
  String taskName;

  @HiveField(3)
  String category; // 'zone', 'schedule', 'declutter'

  @HiveField(4)
  DateTime startTime;

  @HiveField(5)
  DateTime? endTime;

  @HiveField(6)
  int? durationSeconds;

  @HiveField(7)
  String? notes;

  @HiveField(8)
  bool isManualEntry;

  TaskTimeEntry({
    required this.id,
    required this.taskId,
    required this.taskName,
    required this.category,
    required this.startTime,
    this.endTime,
    this.durationSeconds,
    this.notes,
    this.isManualEntry = false,
  });

  int get duration {
    if (durationSeconds != null) return durationSeconds!;
    if (endTime != null) {
      return endTime!.difference(startTime).inSeconds;
    }
    return 0;
  }

  bool get isActive => endTime == null;

  void stop() {
    endTime = DateTime.now();
    durationSeconds = endTime!.difference(startTime).inSeconds;
  }
}
