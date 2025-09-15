import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserTypeAdapter extends TypeAdapter<UserType> {
  @override
  final int typeId = 101; // Unique typeId for UserType

  @override
  UserType read(BinaryReader reader) {
    final index = reader.readByte();
    return UserType.values[index];
  }

  @override
  void write(BinaryWriter writer, UserType obj) {
    writer.writeByte(obj.index);
  }
}
