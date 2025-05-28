import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';
import 'package:local_persistence_form_sample/Core/result.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack_error.dart';
import 'package:local_persistence_form_sample/Core/user_repository_abstract.dart';
import 'package:local_persistence_form_sample/Data/user_repository.dart';

class BackgroundTasks {
  static final instance = BackgroundTasks._internal();

  final _platform = MethodChannel(
    "com.local-persistence-form-sample.dev/db.cleaning",
  );

  BackgroundTasks._internal();

  factory BackgroundTasks() {
    return instance;
  }
}

extension BackgroundTasksDB on BackgroundTasks {
  Future<bool> isCleanDue() async {
    final lastCleaned = await SqfliteStack.instance.lastCleaned;
    final now = DateTime.now();
    final oneWeek = Duration(seconds: 7 * 24 * 60 * 60);
    return now.compareTo(lastCleaned.add(oneWeek)) > 0;
  }

  Future<void> scheduleCleanTask() async {
    //Comment out the code to run tests in Xcode
    //Read https://developer.apple.com/documentation/backgroundtasks/starting-and-terminating-tasks-during-development
    final shouldClean = await isCleanDue();
    if (!shouldClean) {
      return;
    }
    try {
      await _platform.invokeMethod("scheduleCleanDB");
    } on PlatformException catch (e) {
      debugPrint('Failed to schedule clean: $e');
    }
  }

  void cleanDB(UserRepositoryAbstract repository) {
    _platform.setMethodCallHandler((call) async {
      if (call.method == 'cleanDB') {
        debugPrint("[cleanDB] Method called from native");
        return clean(repository);
      }
    });
  }

  Future<int> clean(UserRepositoryAbstract repository) async {
    if (repository is UserRepository) {
      debugPrint("Cleaning users");
      final result = await repository.cleanOldUsers();
      if (result is Success<int, SqfliteStackError>) {
        debugPrint("Deleted ${result.value} users");
        return result.value;
      }
    }
    return 0;
  }
}
