import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture/features/authentication/domain/entity/user.dart';
import 'package:clean_architecture/features/authentication/domain/usecase/create_user.dart';
import 'package:clean_architecture/features/authentication/domain/usecase/get_users.dart';
import 'package:equatable/equatable.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(const AuthenticationInitial());

  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> createUser(
      {required String name, required String createdAt}) async {
    emit(const CreatingUser());
    final result =
        await _createUser(CreateUserParams(name: name, createdAt: createdAt));

    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (success) => emit(const UserCreated()));
  }

  Future<void> getUser() async {
    emit(const GettingUsers());

    final result = await _getUsers();

    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (users) => emit(UsersLoaded(users)));
  }
}
