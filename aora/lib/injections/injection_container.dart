import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/authenticated_client.dart';
import '../core/network/network_info.dart';
import '../core/routes/app_router.dart';
import '../core/services/auth_manager.dart';
import 'auth_injection.dart';
import 'video_hub_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = SharedPreferences.getInstance();
  sl.registerLazySingletonAsync(() => sharedPreferences);
  await GetIt.instance.isReady<SharedPreferences>();
  sl.registerLazySingleton(() => AuthManager(sl()));
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => AuthenticatedClient(sl(), sl()));
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker(),
  );
  sl.registerFactory<NetworkInfo>(() => NetworkInfoImpl(sl()));

  authInit();
  videoHubInit();

  sl.registerLazySingleton(() => AppRouter(sl()));
}
