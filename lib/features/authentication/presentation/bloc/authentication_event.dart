part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object>  get props => [];
}

class CreateUserEvent extends AuthenticationEvent{
  const CreateUserEvent({required this.createdAt,required this.name});
  final String createdAt;
  final String name;

  @override
  List<Object> get props => [createdAt,name];
}

class GetUsersEvent extends AuthenticationEvent{}