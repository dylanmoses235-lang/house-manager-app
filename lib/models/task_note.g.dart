// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskNoteAdapter extends TypeAdapter<TaskNote> {
  @override
  final int typeId = 4;

  @override
  TaskNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskNote(
      id: fields[0] as String,
      taskId: fields[1] as String,
      note: fields[2] as String,
      photoUrls: (fields[3] as List?)?.cast<String>(),
      createdDate: fields[4] as DateTime?,
      updatedDate: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskNote obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.photoUrls)
      ..writeByte(4)
      ..write(obj.createdDate)
      ..writeByte(5)
      ..write(obj.updatedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
