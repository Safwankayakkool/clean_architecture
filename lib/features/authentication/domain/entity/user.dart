import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.createdAt,
    required this.name,
  });

  final int id;
  final String name;
  final String createdAt;

  // For testing unit test for empty params
  const User.empty() : this(
      id: 1,
      createdAt: '_empty.createdAt',
      name: '_empty.name'
  );

  @override
  List<Object?> get props => [id,name,createdAt];
}
