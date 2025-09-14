// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppModelAdapter extends TypeAdapter<AppModel> {
  @override
  final int typeId = 8;

  @override
  AppModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppModel(
      id: fields[0] as String,
      name: fields[1] as String,
      packageName: fields[2] as String,
      iconUrl: fields[3] as String?,
      category: fields[4] as AppCategory,
      status: fields[5] as AppStatus,
      timeLimit: fields[6] as Duration?,
      dailyUsage: fields[7] as Duration?,
      allowedTimes: (fields[8] as List).cast<String>(),
      isSystemApp: fields[9] as bool,
      version: fields[10] as String,
      installedDate: fields[11] as DateTime,
      lastUsed: fields[12] as DateTime?,
      metadata: (fields[13] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.packageName)
      ..writeByte(3)
      ..write(obj.iconUrl)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.timeLimit)
      ..writeByte(7)
      ..write(obj.dailyUsage)
      ..writeByte(8)
      ..write(obj.allowedTimes)
      ..writeByte(9)
      ..write(obj.isSystemApp)
      ..writeByte(10)
      ..write(obj.version)
      ..writeByte(11)
      ..write(obj.installedDate)
      ..writeByte(12)
      ..write(obj.lastUsed)
      ..writeByte(13)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppCategoryAdapter extends TypeAdapter<AppCategory> {
  @override
  final int typeId = 6;

  @override
  AppCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppCategory.games;
      case 1:
        return AppCategory.social;
      case 2:
        return AppCategory.education;
      case 3:
        return AppCategory.entertainment;
      case 4:
        return AppCategory.productivity;
      case 5:
        return AppCategory.communication;
      case 6:
        return AppCategory.utilities;
      case 7:
        return AppCategory.other;
      default:
        return AppCategory.games;
    }
  }

  @override
  void write(BinaryWriter writer, AppCategory obj) {
    switch (obj) {
      case AppCategory.games:
        writer.writeByte(0);
        break;
      case AppCategory.social:
        writer.writeByte(1);
        break;
      case AppCategory.education:
        writer.writeByte(2);
        break;
      case AppCategory.entertainment:
        writer.writeByte(3);
        break;
      case AppCategory.productivity:
        writer.writeByte(4);
        break;
      case AppCategory.communication:
        writer.writeByte(5);
        break;
      case AppCategory.utilities:
        writer.writeByte(6);
        break;
      case AppCategory.other:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppStatusAdapter extends TypeAdapter<AppStatus> {
  @override
  final int typeId = 7;

  @override
  AppStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppStatus.allowed;
      case 1:
        return AppStatus.blocked;
      case 2:
        return AppStatus.restricted;
      case 3:
        return AppStatus.pending;
      default:
        return AppStatus.allowed;
    }
  }

  @override
  void write(BinaryWriter writer, AppStatus obj) {
    switch (obj) {
      case AppStatus.allowed:
        writer.writeByte(0);
        break;
      case AppStatus.blocked:
        writer.writeByte(1);
        break;
      case AppStatus.restricted:
        writer.writeByte(2);
        break;
      case AppStatus.pending:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
