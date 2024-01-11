import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/features/authentication/domain/entity/user.dart';
import 'package:clean_architecture/features/authentication/domain/repostitory/authentication_repo.dart';

class GetUsers extends UseCaseWithoutParams<List<User>> {
  const GetUsers(this._repo);

  final AuthenticationRepo _repo;

  @override
  ResultFuture<List<User>> call() {
    return _repo.getUser();
  }
}
