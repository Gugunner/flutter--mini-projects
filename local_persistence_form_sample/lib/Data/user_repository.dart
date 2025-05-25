import 'package:flutter/foundation.dart' show debugPrint;
import 'package:local_persistence_form_sample/Core/result.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack_error.dart';
import 'package:local_persistence_form_sample/Core/user_repository_abstract.dart';
import 'package:local_persistence_form_sample/Data/DTO/user_model.dart';


class UserRepository implements UserRepositoryAbstract<UserModel, SqfliteStackError> {
  @override
  Future<Result<UserModel, SqfliteStackError>> save(Map<String, Object?> props) async {
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
}
