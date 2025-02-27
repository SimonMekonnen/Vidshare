// lib/features/video_gallery/presentation/bloc/video_gallery_event.dart
part of 'video_gallery_bloc.dart';


sealed class VideoGalleryEvent extends Equatable {
  const VideoGalleryEvent();

  @override
  List<Object> get props => [];
}

class FetchVideos extends VideoGalleryEvent {}

class SearchVideos extends VideoGalleryEvent {
  final String query;

  const SearchVideos({required this.query});

  @override
  List<Object> get props => [query];
}