// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supply_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupplyItemAdapter extends TypeAdapter<SupplyItem> {
  @override
  final int typeId = 3;

  @override
  SupplyItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SupplyItem(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      isNeeded: fields[3] as bool,
      isPurchased: fields[4] as bool,
      quantity: fields[5] as int,
      notes: fields[6] as String?,
      addedDate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SupplyItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.isNeeded)
      ..writeByte(4)
      ..write(obj.isPurchased)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.addedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplyItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
