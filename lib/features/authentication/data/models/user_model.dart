import 'dart:convert';

import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/features/authentication/domain/entity/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.id, required super.createdAt, required super.name});

  factory UserModel.fromJson(String source)=>UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
    id: map['id'] as int,
    createdAt: map['createdAt'] as String,
    name: map['name'] as String,
  );

  const UserModel.empty()
      : this(id: 1,createdAt: '_empty_createdAt',name: '_empty_name');



  UserModel copyWith({
    int? id,
    String? createdAt,
    String? name,
  }) {
    return UserModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        name: name ?? this.name);
  }

  DataMap toMap() => {
    "id": id,
    "createdAt": createdAt,
    "name": name
  };

  String toJson() => jsonEncode(toMap());
}
