import 'package:get_it/get_it.dart';

import '../core/network/authenticated_client.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/presentation/bloc/auth_state/auth_state_bloc.dart';
import '../features/auth/presentation/bloc/login/login_bloc.dart';
import '../features/auth/presentation/bloc/signup/signup_bloc.dart';

final sl = GetIt.instance;
Future<void> authInit() async {
  //Bloc
  sl.registerLazySingleton(() => AuthStateBloc(sl()));
  sl.registerFactory(() => LoginBloc(loginUseCase: sl(), authStateBloc: sl()));
  sl.registerFactory(() => SignupBloc(registerUseCase: sl()));
  // usecases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  //Repository

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl<AuthenticatedClient>(),
      baseUrl: 'https://backend-web-latest-2pq2.onrender.com',
    ),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
