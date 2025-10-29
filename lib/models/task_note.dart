import 'package:hive/hive.dart';

part 'task_note.g.dart';

@HiveType(typeId: 4)
class TaskNote extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String taskId; // zone_taskIndex_date format

  @HiveField(2)
  String note;

  @HiveField(3)
  List<String> photoUrls;

  @HiveField(4)
  DateTime createdDate;

  @HiveField(5)
  DateTime? updatedDate;

  TaskNote({
    required this.id,
    required this.taskId,
    required this.note,
    List<String>? photoUrls,
    DateTime? createdDate,
    this.updatedDate,
  })  : photoUrls = photoUrls ?? [],
        createdDate = createdDate ?? DateTime.now();
}
