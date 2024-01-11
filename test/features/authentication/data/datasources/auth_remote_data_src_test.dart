import 'dart:convert';

import 'package:clean_architecture/core/errors/exception.dart';
import 'package:clean_architecture/core/utils/constants.dart';
import 'package:clean_architecture/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_architecture/features/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource authRemoteDataSource;
  setUp(() {
    client = MockClient();
    authRemoteDataSource = AuthenticationRemoteDataSourceImpl(client);
    registerFallbackValue(Uri());
  });
  group('createUser', () {
    test("should complete successfully when the status code 200 0r 201 ",
        () async {
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('User created successfully', 201));
      
      final method = authRemoteDataSource.createUser;
      expect(method( name: 'name', createdAt: 'createdAt'), completes);

      verify(()=>client.post(Uri.https(kBaseUrl,kCreateUserEndpoint),
      body: jsonEncode({
        'createdAt':'createdAt',
        'id':1,
        'name':'name'
      }))).called(1);

      verifyNoMoreInteractions(client);
    });


    test("should throw [APIException] when the status code is not 200 0r 201 ",
            () async {
          when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
                  (_) async => http.Response('Invalid response', 400));

          final method = authRemoteDataSource.createUser;
          expect(method( name: 'name', createdAt: 'createdAt'), throwsA(const APIException(message: 'Invalid response', statusCode: 400)));

          verify(()=>client.post(Uri.https(kBaseUrl,kCreateUserEndpoint),
              body: jsonEncode({
                'createdAt':'createdAt',
                'id':1,
                'name':'name'
              }))).called(1);

          verifyNoMoreInteractions(client);
        });
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    test("should return [List<User>] when the status code 200",
            () async {
          when(() => client.get(any())).thenAnswer(
                  (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 201));

          final result =await authRemoteDataSource.getUsers();
          expect(result, tUsers);
          // We can use [Uri.https] for passing query param in our url like {'id':3}
          verify(()=>client.get(Uri.https(kBaseUrl,kGetUserEndpoint))).called(1);

          verifyNoMoreInteractions(client);
        });


    test("should throw [APIException] when the status code is not 200",
            () async {
              when(() => client.get(any())).thenAnswer(
                      (_) async => http.Response('Server down', 500));

          final method = authRemoteDataSource.getUsers;
          expect(method, throwsA(const APIException(message: 'Server down', statusCode: 500)));

          verify(()=>client.get(Uri.https(kBaseUrl,kGetUserEndpoint),)).called(1);

          verifyNoMoreInteractions(client);
        });
  });

}
