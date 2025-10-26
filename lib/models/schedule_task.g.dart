// GENERATED CODE - Hive Type Adapter
part of 'schedule_task.dart';

class ScheduleTaskAdapter extends TypeAdapter<ScheduleTask> {
  @override
  final int typeId = 1;

  @override
  ScheduleTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleTask(
      id: fields[0] as String,
      time: fields[1] as String,
      task: fields[2] as String,
      details: fields[3] as String,
      dayType: fields[4] as String,
      isCompleted: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleTask obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.task)
      ..writeByte(3)
      ..write(obj.details)
      ..writeByte(4)
      ..write(obj.dayType)
      ..writeByte(5)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
