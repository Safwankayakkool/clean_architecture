import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/features/authentication/domain/repostitory/authentication_repo.dart';
import 'package:equatable/equatable.dart';

class CreateUser extends UseCaseWithParams<void,CreateUserParams>{
 const CreateUser(this._repository);

  final AuthenticationRepo _repository;

  @override
  ResultVoid call(CreateUserParams params) async{
   return _repository.createUser(createdAt: params.createdAt, name: params.name );
  }

//   ResultVoid createUser({
//    required String createdAt,
//    required String name,
// }) async {
//     return _repository.createUser(
//         createdAt: createdAt, name: name);
//   }
}


class CreateUserParams extends Equatable{
  const CreateUserParams({required this.name,required this.createdAt});
  final String createdAt;
  final String name;
  // For testing unit test for empty params
  const CreateUserParams.empty(): this(name: '_empty.name',createdAt: '_empty.createdAt');

  @override
  List<Object?> get props => [name,createdAt];

}
