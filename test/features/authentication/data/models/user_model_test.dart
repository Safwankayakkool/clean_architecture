import 'dart:convert';

import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/features/authentication/data/models/user_model.dart';
import 'package:clean_architecture/features/authentication/domain/entity/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  const tModel = UserModel.empty();
  test("should be a subclass of [User] entity", () {
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return a [UserModel] with the right data ', () {
      final result = UserModel.fromMap(tMap);
      expect(result, tModel);
    });
  });

  group('fromJson', () {
    test('should return a [UserModel] with the right data ', () {
      final result = UserModel.fromJson(tJson);
      expect(result, tModel);
    });
  });

  group('toMap', () {
    test('should return a [Map] with the right data ', () {
      final result = tModel.toMap();
      expect(result, tMap);
    });
  });

  group('toJson', () {
    test('should return a [JSON] string with the right data ', () {
      final result = tModel.toJson();
      final tJson = jsonEncode({
        "id": 1,
        "createdAt": "_empty_createdAt",
        "name": "_empty_name"
      });
      expect(result, tJson);
    });
  });


  group('copyWith', () {
    test('should return a [UserModel] with different data ', () {
      final result = tModel.copyWith(name: "Abu");

      expect(result.name,  "Abu");

    });
  });
}
