import 'package:clean_architecture/core/errors/exception.dart';
import 'package:clean_architecture/core/errors/failure.dart';
import 'package:clean_architecture/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_architecture/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:clean_architecture/features/authentication/domain/entity/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource authRemoteDataSource;
  late AuthenticationRepositoryImplementation authRepoImpl;

  setUp(() {
    authRemoteDataSource = MockAuthRemoteDataSource();
    authRepoImpl = AuthenticationRepositoryImplementation(authRemoteDataSource);
  });
  const tException =
  APIException(message: "Unknown error occurred", statusCode: 500);

  group('createUser', () {
    const id = 1;
    const createdAt = "whatever.createdAt";
    const name = "whatever.name";


    test(
        'should call the [RemoteDataSource.createUser] and complete '
        'successfully when the call to remote source is successful', () async {
      when(() => authRemoteDataSource.createUser(
              name: any(named: 'name'),
              createdAt: any(named: 'createdAt')))
          .thenAnswer((_) async => Future.value());

      final result = await authRepoImpl.createUser(
          createdAt: createdAt, name: name);

      expect(result, const Right(null));
      verify(() => authRemoteDataSource.createUser(
          name: name, createdAt: createdAt)).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    });

    test(
        'should return a [APIFailure] when the call to the remote'
        'source is unsuccessful', () async {
      when(() => authRemoteDataSource.createUser(

          name: any(named: 'name'),
          createdAt: any(named: 'createdAt'))).thenThrow(tException);

      final result = await authRepoImpl.createUser(
        createdAt: createdAt, name: name);
      expect(
          result,
          Left(APIFailure(
              message: tException.message, statusCode: tException.statusCode)));
      verify(() => authRemoteDataSource.createUser(
       name: name, createdAt: createdAt)).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    });
  });


  group('getUsers', () {
    test(
        'should call the [RemoteDataSource.getUser] and return [List<User>] '
            'when call to remote source is successful', () async {
      when(() => authRemoteDataSource.getUsers())
          .thenAnswer((_) async => Future.value([]));

      final result = await authRepoImpl.getUser();

      expect(result, isA<Right<dynamic,List<User>>>());
      verify(() => authRemoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    });

    test(
        'should return a [APIFailure] when the call to the remote'
            'source is unsuccessful', () async {
      when(() => authRemoteDataSource.getUsers())
          .thenThrow(tException);

      final result = await authRepoImpl.getUser();

      expect(result, Left(APIFailure.fromException(tException)));
      verify(() => authRemoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    }); 
  });
}
