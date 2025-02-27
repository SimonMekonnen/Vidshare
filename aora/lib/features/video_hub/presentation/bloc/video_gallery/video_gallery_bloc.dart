// lib/features/video_gallery/presentation/bloc/video_gallery_bloc.dart
import 'package:aora/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/video.dart';
import '../../../domain/usecases/get_videos_usecase.dart';
import '../../../domain/usecases/search_videos_usecase.dart';


part 'video_gallery_event.dart';
part 'video_gallery_state.dart';

class VideoGalleryBloc extends Bloc<VideoGalleryEvent, VideoGalleryState> {
  final GetVideosUseCase getVideosUseCase;
  final SearchVideosUseCase searchVideosUseCase;

  VideoGalleryBloc({
    required this.getVideosUseCase,
    required this.searchVideosUseCase,
  }) : super(VideoGalleryInitial()) {
    on<FetchVideos>(_onFetchVideos);
    on<SearchVideos>(_onSearchVideos);
  }

  Future<void> _onFetchVideos(
      FetchVideos event, Emitter<VideoGalleryState> emit) async {
    emit(VideoGalleryLoading());

    final result = await getVideosUseCase(NoParams());

    result.fold(
      (failure) => emit(VideoGalleryFailure(error: failure)),
      (videos) => emit(VideoGalleryLoaded(videos: videos)),
    );
  }

  Future<void> _onSearchVideos(
      SearchVideos event, Emitter<VideoGalleryState> emit) async {
    emit(VideoGalleryLoading());

    final result = await searchVideosUseCase(SearchParams(query: event.query));

    result.fold(
      (failure) => emit(VideoGalleryFailure(error: failure)),
      (videos) => emit(VideoGalleryLoaded(videos: videos)),
    );
  }
}