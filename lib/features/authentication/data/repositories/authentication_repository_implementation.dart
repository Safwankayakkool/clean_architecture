import 'package:clean_architecture/core/errors/exception.dart';
import 'package:clean_architecture/core/errors/failure.dart';
import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_architecture/features/authentication/domain/entity/user.dart';
import 'package:clean_architecture/features/authentication/domain/repostitory/authentication_repo.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepositoryImplementation implements AuthenticationRepo {
  AuthenticationRepositoryImplementation(this._repositoryRemoteDataSource);

  final AuthenticationRemoteDataSource _repositoryRemoteDataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
      }) async {
    //Test-Driven Development
    //1. call the remote data source
    //2. check if the method returning proper data
    //3. make sure that if the method returning proper data if there is no exception
    //4. check if the remoteDataSource throws an exception, we return a failure
    try {
      await _repositoryRemoteDataSource.createUser(
           name: name, createdAt: createdAt);
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
      // return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<User>> getUser() async{
  try{
   final result= await _repositoryRemoteDataSource.getUsers();
    return  Right(result);
  }on APIException catch(e){
    return Left(APIFailure.fromException(e));
  }
  }
}
