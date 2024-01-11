import 'package:clean_architecture/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_architecture/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:clean_architecture/features/authentication/domain/repostitory/authentication_repo.dart';
import 'package:clean_architecture/features/authentication/domain/usecase/create_user.dart';
import 'package:clean_architecture/features/authentication/domain/usecase/get_users.dart';
import 'package:clean_architecture/features/authentication/presentation/cubic/authentication_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // App Logic
    ..registerFactory(
        () => AuthenticationCubit(createUser: sl(), getUsers: sl()))

    // Use cases
    // here create user have a dependency with authenticationRepo but it is inside the domain and also it is abstract class
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    // Repositories
    // So here we will assign the above authenticationRepo with authenticationRepoImpl of data class
    ..registerLazySingleton<AuthenticationRepo>(
        () => AuthenticationRepositoryImplementation(sl()))

    // Data sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImpl(sl()))

    // External dependencies
    ..registerLazySingleton(http.Client.new);
  // ..registerLazySingleton(() => http.Client());
}
