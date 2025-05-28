import 'package:flutter/foundation.dart' show debugPrint;
import 'package:local_persistence_form_sample/Core/result.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack_error.dart';
import 'package:local_persistence_form_sample/Core/user_repository_abstract.dart';
import 'package:local_persistence_form_sample/Data/DTO/user_model.dart';

class UserRepository
    implements UserRepositoryAbstract<UserModel, SqfliteStackError> {
  @override
  Future<Result<UserModel, SqfliteStackError>> save(
    Map<String, Object?> props,
  ) async {
    final user = UserModel(
      userName: props[UserModel.columnUserName] as String? ?? "",
      email: props[UserModel.columnEmail] as String? ?? "",
      timestamp: DateTime.now(),
    );
    try {
      final storedCount = await SqfliteStack.instance.save(user);
      if (storedCount == 0) {
        return Failure(CannotStore());
      }
      return Success(user);
    } on SqfliteStackError catch (error) {
      return Failure(error);
    } catch (error) {
      debugPrint("Error $error");
      return Failure(Unknown());
    }
  }

  @override
  Future<Result<int, SqfliteStackError>> cleanOldUsers() async {
    debugPrint("Calling repository to clean old users");
    final users = await SqfliteStack.instance.fetchUsersFrom();
    var count = 0;
    if (users == null) return Success(0);
    for (final user in users) {
      count += await SqfliteStack.instance.deleteUser(user.id);
    }
    if (count == 0) {
      return Failure(CannotDelete());
    }
    return Success(count);
  }
}
