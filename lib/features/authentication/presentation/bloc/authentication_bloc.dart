import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture/features/authentication/domain/entity/user.dart';
import 'package:clean_architecture/features/authentication/domain/usecase/create_user.dart';
import 'package:clean_architecture/features/authentication/domain/usecase/get_users.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(const AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
  }

  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> _createUserHandler(
      CreateUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const CreatingUser());
    final result = await _createUser(
        CreateUserParams(name: event.name, createdAt: event.createdAt));

    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (success) => emit(const UserCreated()));
  }

  Future<void> _getUsersHandler(
      GetUsersEvent event, Emitter<AuthenticationState> emit) async {
    emit(const GettingUsers());

    final result = await _getUsers();

    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (users) => emit(UsersLoaded(users)));
  }
}
