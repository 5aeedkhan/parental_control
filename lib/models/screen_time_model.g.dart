// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_time_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScreenTimeModelAdapter extends TypeAdapter<ScreenTimeModel> {
  @override
  final int typeId = 5;

  @override
  ScreenTimeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScreenTimeModel(
      id: fields[0] as String,
      deviceId: fields[1] as String,
      userId: fields[2] as String,
      date: fields[3] as DateTime,
      totalTime: fields[4] as Duration,
      limit: fields[5] as Duration,
      appUsage: (fields[6] as Map).cast<String, Duration>(),
      categoryUsage: (fields[7] as Map).cast<String, Duration>(),
      unlockCount: fields[8] as int,
      notificationCount: fields[9] as int,
      lastActivity: fields[10] as DateTime?,
      isLimitExceeded: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScreenTimeModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.deviceId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.totalTime)
      ..writeByte(5)
      ..write(obj.limit)
      ..writeByte(6)
      ..write(obj.appUsage)
      ..writeByte(7)
      ..write(obj.categoryUsage)
      ..writeByte(8)
      ..write(obj.unlockCount)
      ..writeByte(9)
      ..write(obj.notificationCount)
      ..writeByte(10)
      ..write(obj.lastActivity)
      ..writeByte(11)
      ..write(obj.isLimitExceeded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenTimeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
