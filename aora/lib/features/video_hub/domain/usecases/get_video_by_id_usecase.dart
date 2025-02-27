// lib/features/video_gallery/domain/usecases/get_video_by_id_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/video.dart';
import '../repositories/video_repository.dart';

class GetVideoByIdUseCase implements UseCase<Video, VideoParams> {
  final VideoRepository repository;
  
  GetVideoByIdUseCase(this.repository);
  
  @override
  Future<Either<Failure, Video>> call(VideoParams params) async {
    return await repository.getVideoById(params.id);
  }
}

class VideoParams extends Equatable {
  final String id;
  
  const VideoParams({required this.id});
  
  @override
  List<Object> get props => [id];
}