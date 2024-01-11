import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/features/authentication/domain/entity/user.dart';

abstract class AuthenticationRepo {
  const AuthenticationRepo();

  ResultVoid createUser(
      { required String createdAt, required String name});

  ResultFuture<List<User>> getUser();
}
