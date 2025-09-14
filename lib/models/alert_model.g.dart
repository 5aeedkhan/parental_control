// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlertModelAdapter extends TypeAdapter<AlertModel> {
  @override
  final int typeId = 4;

  @override
  AlertModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlertModel(
      id: fields[0] as String,
      type: fields[1] as AlertType,
      severity: fields[2] as AlertSeverity,
      title: fields[3] as String,
      description: fields[4] as String,
      deviceId: fields[5] as String?,
      userId: fields[6] as String?,
      timestamp: fields[7] as DateTime,
      isRead: fields[8] as bool,
      isResolved: fields[9] as bool,
      metadata: (fields[10] as Map).cast<String, dynamic>(),
      actionTaken: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AlertModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.severity)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.deviceId)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.timestamp)
      ..writeByte(8)
      ..write(obj.isRead)
      ..writeByte(9)
      ..write(obj.isResolved)
      ..writeByte(10)
      ..write(obj.metadata)
      ..writeByte(11)
      ..write(obj.actionTaken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlertTypeAdapter extends TypeAdapter<AlertType> {
  @override
  final int typeId = 2;

  @override
  AlertType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AlertType.cyberbullying;
      case 1:
        return AlertType.inappropriateContent;
      case 2:
        return AlertType.locationAlert;
      case 3:
        return AlertType.screenTimeExceeded;
      case 4:
        return AlertType.appUsageAlert;
      case 5:
        return AlertType.unknownContact;
      case 6:
        return AlertType.systemAlert;
      default:
        return AlertType.cyberbullying;
    }
  }

  @override
  void write(BinaryWriter writer, AlertType obj) {
    switch (obj) {
      case AlertType.cyberbullying:
        writer.writeByte(0);
        break;
      case AlertType.inappropriateContent:
        writer.writeByte(1);
        break;
      case AlertType.locationAlert:
        writer.writeByte(2);
        break;
      case AlertType.screenTimeExceeded:
        writer.writeByte(3);
        break;
      case AlertType.appUsageAlert:
        writer.writeByte(4);
        break;
      case AlertType.unknownContact:
        writer.writeByte(5);
        break;
      case AlertType.systemAlert:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlertSeverityAdapter extends TypeAdapter<AlertSeverity> {
  @override
  final int typeId = 3;

  @override
  AlertSeverity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AlertSeverity.low;
      case 1:
        return AlertSeverity.medium;
      case 2:
        return AlertSeverity.high;
      case 3:
        return AlertSeverity.critical;
      default:
        return AlertSeverity.low;
    }
  }

  @override
  void write(BinaryWriter writer, AlertSeverity obj) {
    switch (obj) {
      case AlertSeverity.low:
        writer.writeByte(0);
        break;
      case AlertSeverity.medium:
        writer.writeByte(1);
        break;
      case AlertSeverity.high:
        writer.writeByte(2);
        break;
      case AlertSeverity.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertSeverityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
