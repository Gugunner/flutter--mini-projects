import 'package:uuid/uuid.dart';

class UserModel {
  late final String id;
  final String userName;
  final String email;
  final DateTime timestamp;

  static final columnId = "id";
  static final columnUserName = "userName";
  static final columnEmail = "email";
  static final columnTimestamp = "timestamp";
  static final tableName = "users";

  UserModel({
    required this.userName,
    required this.email,
    required this.timestamp,
    String? id,
  }) {
    this.id = id ?? Uuid().v1();
  }

  Map<String, Object?> toMap() {
    return {
      UserModel.columnId: id,
      UserModel.columnUserName: userName,
      UserModel.columnEmail: email,
      UserModel.columnTimestamp: timestamp.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, Object?> map) {
    return UserModel(
      userName: map[columnUserName] as String? ?? "",
      email: map[columnEmail] as String? ?? "",
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map[columnTimestamp] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
      id: map[columnId] as String? ?? "",
    );
  }

  @override
  String toString() {
    return """
    User{${UserModel.columnId}: $id,
    ${UserModel.columnUserName}: $userName,
    ${UserModel.columnEmail}: $email,
    ${UserModel.columnTimestamp}: $timestamp};
    """;
  }
}
