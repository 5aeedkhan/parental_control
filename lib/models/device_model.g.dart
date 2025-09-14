// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceModelAdapter extends TypeAdapter<DeviceModel> {
  @override
  final int typeId = 1;

  @override
  DeviceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceModel(
      id: fields[0] as String,
      name: fields[1] as String,
      platform: fields[2] as String,
      model: fields[3] as String,
      osVersion: fields[4] as String,
      ownerId: fields[5] as String?,
      isOnline: fields[6] as bool,
      lastSeen: fields[7] as DateTime?,
      batteryLevel: fields[8] as int,
      isCharging: fields[9] as bool,
      dataUsage: fields[10] as double,
      settings: (fields[11] as Map).cast<String, dynamic>(),
      createdAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.platform)
      ..writeByte(3)
      ..write(obj.model)
      ..writeByte(4)
      ..write(obj.osVersion)
      ..writeByte(5)
      ..write(obj.ownerId)
      ..writeByte(6)
      ..write(obj.isOnline)
      ..writeByte(7)
      ..write(obj.lastSeen)
      ..writeByte(8)
      ..write(obj.batteryLevel)
      ..writeByte(9)
      ..write(obj.isCharging)
      ..writeByte(10)
      ..write(obj.dataUsage)
      ..writeByte(11)
      ..write(obj.settings)
      ..writeByte(12)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
