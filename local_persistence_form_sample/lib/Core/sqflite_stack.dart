import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:local_persistence_form_sample/Core/sqflite_stack_error.dart';
import 'package:local_persistence_form_sample/Data/DTO/user_model.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final class SqfliteStack {
  static final _lastCleanedKey = "lastCleaned";

  static final _instance = SqfliteStack._internal();

  Database? _database;

  factory SqfliteStack() => _instance;

  static SqfliteStack get instance => _instance;

  SqfliteStack._internal();

  Future<void> init() async {
    await _setDataBase();
  }

  Future<void> _setDataBase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "user_database.db"),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE ${UserModel.tableName}(${UserModel.columnId} TEXT PRIMARY KEY,
          ${UserModel.columnUserName} TEXT, ${UserModel.columnEmail} TEXT,
          ${UserModel.columnTimestamp} INT)''',
        );
      },
      version: 1,
    );
  }

  Future<Database>? get database async {
    if (_database != null) {
      return _database!;
    }
    await init();
    return _database!;
  }

  Future<DateTime> get lastCleaned async {
    final prefs = await SharedPreferences.getInstance();
    final lastCleaned = prefs.getString(SqfliteStack._lastCleanedKey);
    return lastCleaned != null ? DateTime.parse(lastCleaned) : DateTime.now();
  }

  Future<void> setLastCleaned(DateTime date) async {
    final isoString = date.toIso8601String();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SqfliteStack._lastCleanedKey, isoString);
  }
}

extension SqfliteStackUserStorage on SqfliteStack {
  Future<int> deleteUser(String userId) async {
    debugPrint("Deleting a user $userId");
    final deleteCount = await _database?.delete(
      UserModel.tableName,
      where: "${UserModel.columnId} = ?",
      whereArgs: [userId],
    );
    return deleteCount ?? 0;
  }

  Future<int> save(UserModel user) async {
    final foundUser = await fetchUserBy(
      userName: user.userName,
      email: user.email,
    );
    debugPrint("Found User $foundUser");
    if (foundUser != null) {
      throw AlreadyExists();
    }
    final storeCount =
        await _database?.insert(
          UserModel.tableName,
          user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        ) ??
        0;

    debugPrint("Storing user ${user.toString()} store count $storeCount");
    return storeCount;
  }

  Future<List<UserModel>?> fetchUsersFrom({
    Duration timeAgo = const Duration(seconds: 60),
  }) async {
    final curDate = DateTime.now();
    final startDate = curDate.subtract(timeAgo);
    final timestamp = startDate.millisecondsSinceEpoch;
    debugPrint("Getting raw users");
    final rawUsers = await _database?.query(
      UserModel.tableName,
      where: '${UserModel.columnTimestamp} <= ?',
      whereArgs: [timestamp],
    );
    return rawUsers?.map((ru) => UserModel.fromMap(ru)).toList();
  }

  Future<UserModel?> fetchUserBy({
    required String userName,
    required String email,
  }) async {
    final rawUser = await _database?.query(
      UserModel.tableName,
      where:
          "${UserModel.columnUserName} = ? COLLATE NOCASE OR ${UserModel.columnEmail} = ? COLLATE NOCASE ",
      whereArgs: [userName, email],
    );
    if (rawUser == null || rawUser.isEmpty) return null;
    return UserModel.fromMap(rawUser.first);
  }
}
