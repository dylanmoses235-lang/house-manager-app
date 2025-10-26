// GENERATED CODE - Hive Type Adapter
part of 'declutter_day.dart';

class DeclutterDayAdapter extends TypeAdapter<DeclutterDay> {
  @override
  final int typeId = 2;

  @override
  DeclutterDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeclutterDay(
      day: fields[0] as int,
      area: fields[1] as String,
      task: fields[2] as String,
      isCompleted: fields[3] as bool,
      completedDate: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DeclutterDay obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.area)
      ..writeByte(2)
      ..write(obj.task)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.completedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeclutterDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
