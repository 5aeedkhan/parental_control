// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationModelAdapter extends TypeAdapter<LocationModel> {
  @override
  final int typeId = 9;

  @override
  LocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationModel(
      id: fields[0] as String,
      deviceId: fields[1] as String,
      userId: fields[2] as String,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      address: fields[5] as String?,
      placeName: fields[6] as String?,
      accuracy: fields[7] as double,
      timestamp: fields[8] as DateTime,
      isSafeZone: fields[9] as bool,
      safeZoneId: fields[10] as String?,
      metadata: (fields[11] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, LocationModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.deviceId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.placeName)
      ..writeByte(7)
      ..write(obj.accuracy)
      ..writeByte(8)
      ..write(obj.timestamp)
      ..writeByte(9)
      ..write(obj.isSafeZone)
      ..writeByte(10)
      ..write(obj.safeZoneId)
      ..writeByte(11)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SafeZoneModelAdapter extends TypeAdapter<SafeZoneModel> {
  @override
  final int typeId = 10;

  @override
  SafeZoneModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SafeZoneModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      radius: fields[5] as double,
      isActive: fields[6] as bool,
      createdAt: fields[7] as DateTime,
      lastModified: fields[8] as DateTime?,
      deviceIds: (fields[9] as List).cast<String>(),
      settings: (fields[10] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SafeZoneModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.radius)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastModified)
      ..writeByte(9)
      ..write(obj.deviceIds)
      ..writeByte(10)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SafeZoneModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
