// GENERATED CODE - Hive Type Adapter
part of 'daily_recurring_task.dart';

class DailyRecurringTaskAdapter extends TypeAdapter<DailyRecurringTask> {
  @override
  final int typeId = 6;

  @override
  DailyRecurringTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyRecurringTask(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      emoji: fields[3] as String,
      lastCompleted: fields[4] as DateTime?,
      accumulationDays: fields[5] as int,
      isCompletedToday: fields[6] as bool,
      totalCompletions: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyRecurringTask obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.emoji)
      ..writeByte(4)
      ..write(obj.lastCompleted)
      ..writeByte(5)
      ..write(obj.accumulationDays)
      ..writeByte(6)
      ..write(obj.isCompletedToday)
      ..writeByte(7)
      ..write(obj.totalCompletions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyRecurringTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
