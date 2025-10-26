// GENERATED CODE - Hive Type Adapter
part of 'zone_task.dart';

class ZoneTaskAdapter extends TypeAdapter<ZoneTask> {
  @override
  final int typeId = 0;

  @override
  ZoneTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ZoneTask(
      id: fields[0] as String,
      task: fields[1] as String,
      howTo: fields[2] as String,
      zone: fields[3] as String,
      day: fields[4] as String,
      isCompleted: fields[5] as bool,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ZoneTask obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.task)
      ..writeByte(2)
      ..write(obj.howTo)
      ..writeByte(3)
      ..write(obj.zone)
      ..writeByte(4)
      ..write(obj.day)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZoneTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
