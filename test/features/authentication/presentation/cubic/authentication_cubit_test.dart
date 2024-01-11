import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/core/errors/failure.dart';
import 'package:clean_architecture/features/authentication/data/models/user_model.dart';
import 'package:clean_architecture/features/authentication/domain/usecase/create_user.dart';
import 'package:clean_architecture/features/authentication/domain/usecase/get_users.dart';
import 'package:clean_architecture/features/authentication/presentation/cubic/authentication_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateUser extends Mock implements CreateUser {}

class MockGetUsers extends Mock implements GetUsers {}

void main() {
  late CreateUser createUser;
  late GetUsers getUsers;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tUsers=[UserModel.empty()];
  const tAPIFailure =
      APIFailure(message: 'Something went wrong', statusCode: 400);

  setUp(() {
    createUser = MockCreateUser();
    getUsers = MockGetUsers();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  // Always close the bloc/cubit after use
  tearDown(() => cubit.close());

  test('initial state should be [AuthenticationInitial]', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, UserCreated] when success',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
          name: tCreateUserParams.name, createdAt: tCreateUserParams.createdAt),
      // act: (bloc) => bloc.add(CreateUserEvent(name: 'name', createdAt: 'createdAt')),
      expect: () => const [CreatingUser(), UserCreated()],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest(
      'should emit [CreatingUser, AuthenticationError] when unsuccessful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Left(tAPIFailure));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
          name: tCreateUserParams.name, createdAt: tCreateUserParams.createdAt),
      expect: () =>
          [const CreatingUser(), AuthenticationError(tAPIFailure.errorMessage)],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUser, UserLoaded] when success',
      build: () {
        when(() => getUsers()).thenAnswer((_) async =>  const Right(tUsers));
        return cubit;
      },
      act: (cubit)=>cubit.getUser(),
      expect: ()=>const [
        GettingUsers(),
        UsersLoaded(tUsers)
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUser, AuthenticationError] when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async =>  const Left(tAPIFailure));
        return cubit;
      },
      act: (cubit)=>cubit.getUser(),
      expect: ()=> [
        const GettingUsers(),
        AuthenticationError(tAPIFailure.errorMessage)
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
