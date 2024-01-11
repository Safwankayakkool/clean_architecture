// What does the Class depend on
// answer ->  AuthenticationRepo
// How can we make a fake version of dependency
// answer -> Mocktail
// How do we control what our dependencies do
// answer -> Using the Mocktail API

import 'package:clean_architecture/features/authentication/domain/entity/user.dart';
import 'package:clean_architecture/features/authentication/domain/repostitory/authentication_repo.dart';
import 'package:clean_architecture/features/authentication/domain/usecase/get_users.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repo.mock.dart';


void main() {
  late AuthenticationRepo repository;
  late GetUsers getUsers;
  // setUp initialize object every individual test && setUpAll only initialize object in first test (use same object to the remaining test)
  setUp(() {
    repository = MockAuthRepo();
    getUsers = GetUsers(repository);
  });

  const tResponse = [ User.empty()];

  test('should call [AuthRepo.getUser] and return [List<User>]', () async {
    // any only work generic dart type. if we have to add a class we need to make a registerFallbackValue(ClassName) in setUp;
    // any only work positional parameter, if we have name parameter we need to give any(name: 'name of the params')
    when(
          () => repository.getUser(),
    ).thenAnswer((_) async => const Right(tResponse));

    // here the useCase is calling the "call" method of CreateUser class of domain usecase. we can call a function with object name by using dart inBuild "call" method
    final result = await getUsers();

    // Here we write the expected value so Right is success and Left is failure in our case. the dynamic is used to assign the fail type, but not required
    expect(result, equals(const Right<dynamic,List<User>>(tResponse)));
    // we can call like this also
    // expect(result, const Right(null));

    // Here we are verify the repository call is happened and in 1 times
    verify(()=>repository.getUser()).called(1);

    // Then checking there is no more other call is happening in this repo
    verifyNoMoreInteractions(repository);
  });
}
