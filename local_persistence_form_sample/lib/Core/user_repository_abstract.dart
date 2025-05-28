import 'package:local_persistence_form_sample/Core/result.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack_error.dart'
    show SqfliteStackError;
import 'package:local_persistence_form_sample/Data/DTO/user_model.dart';

typedef SqfliteUserRepository =
    UserRepositoryAbstract<UserModel, SqfliteStackError>;

abstract class UserRepositoryAbstract<T extends UserModel?, E extends Error> {
  Future<Result<T, E>> save(Map<String, Object?> props);
  Future<Result<int, SqfliteStackError>> cleanOldUsers();
}
