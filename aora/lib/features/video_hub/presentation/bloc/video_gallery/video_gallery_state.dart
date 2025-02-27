// lib/features/video_gallery/presentation/bloc/video_gallery_state.dart
part of 'video_gallery_bloc.dart';

sealed class VideoGalleryState extends Equatable {
  const VideoGalleryState();

  @override
  List<Object> get props => [];
}

class VideoGalleryInitial extends VideoGalleryState {}

class VideoGalleryLoading extends VideoGalleryState {}

class VideoGalleryLoaded extends VideoGalleryState {
  final List<Video> videos;

  const VideoGalleryLoaded({required this.videos});

  @override
  List<Object> get props => [videos];
}

class VideoGalleryFailure extends VideoGalleryState {
  final Failure error;

  const VideoGalleryFailure({required this.error});

  @override
  List<Object> get props => [error];
}