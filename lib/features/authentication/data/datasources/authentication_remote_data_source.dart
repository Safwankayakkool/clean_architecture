import 'dart:convert';

import 'package:clean_architecture/core/errors/exception.dart';
import 'package:clean_architecture/core/utils/constants.dart';
import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/features/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser(
      { required String name, required String createdAt});

  //When function have return type there we only use the /data/models class, because we need to access the toJson,fromJson etc.. not Domain/entity class in data source
  Future<List<UserModel>> getUsers();
}

// List of end points
const kCreateUserEndpoint = '/api/create_user';
const kGetUserEndpoint = '/api/users';

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImpl(this._client);

  final http.Client _client;

  @override
  Future<void> createUser(
      {
      required String name,
      required String createdAt}) async {
    // 1. check to make sure that it returns the right data when the status
    // code is 200 or the proper response code
    // 2. check make sure that it "THROWS AN CUSTOM EXCEPTION" with the right message
    // when the status code is bad one
    try {
      final response = await _client.post(
        Uri.https(kBaseUrl,kCreateUserEndpoint),
        body: jsonEncode({'createdAt': createdAt,  'name': name}),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
    } on APIException {
      // this is for throwing the correct error when the api calls failed, when we haven't add this it always throw catch error as 505
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(
        Uri.https(kBaseUrl, kGetUserEndpoint),
      );
      if (response.statusCode != 200) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      } else {
        return List<DataMap>.from(jsonDecode(response.body) as List)
            .map((userData) => UserModel.fromMap(userData))
            .toList();
      }
    } on APIException {
      // this is for throwing the correct error when the api calls failed, when we haven't add this it always throw catch error as 505
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}
