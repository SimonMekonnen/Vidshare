// lib/features/video_gallery/domain/usecases/search_videos_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/video.dart';
import '../repositories/video_repository.dart';

class SearchVideosUseCase implements UseCase<List<Video>, SearchParams> {
  final VideoRepository repository;
  
  SearchVideosUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<Video>>> call(SearchParams params) async {
    return await repository.searchVideos(params.query);
  }
}

class SearchParams extends Equatable {
  final String query;
  
  const SearchParams({required this.query});
  
  @override
  List<Object> get props => [query];
}