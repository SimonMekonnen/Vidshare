// lib/injection/video_hub_injection.dart
import 'package:get_it/get_it.dart';

import '../core/network/authenticated_client.dart';
import '../features/video_hub/data/datasources/video_remote_datasource.dart';
import '../features/video_hub/data/repositories/video_repository_impl.dart';
import '../features/video_hub/domain/repositories/video_repository.dart';
import '../features/video_hub/domain/usecases/get_videos_usecase.dart';
import '../features/video_hub/domain/usecases/search_videos_usecase.dart';
import '../features/video_hub/presentation/bloc/video_gallery/video_gallery_bloc.dart';

final sl = GetIt.instance;

Future<void> videoHubInit() async {
  // Bloc
  sl.registerFactory(
    () => VideoGalleryBloc(getVideosUseCase: sl(), searchVideosUseCase: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetVideosUseCase(sl()));
  sl.registerLazySingleton(() => SearchVideosUseCase(sl()));

  // Repository
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<VideoRemoteDataSource>(
    () => VideoRemoteDataSourceImpl(
      client: sl<AuthenticatedClient>(),
      baseUrl: 'https://backend-web-latest-2pq2.onrender.com/api',
    ),
  );
}
