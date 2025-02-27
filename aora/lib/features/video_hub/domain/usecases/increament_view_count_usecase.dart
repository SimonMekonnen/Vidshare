// lib/features/video_gallery/domain/usecases/increment_view_count_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/video_repository.dart';

class IncrementViewCountUseCase implements UseCase<bool, VideoIdParams> {
  final VideoRepository repository;
  
  IncrementViewCountUseCase(this.repository);
  
  @override
  Future<Either<Failure, bool>> call(VideoIdParams params) async {
    return await repository.incrementViewCount(params.videoId);
  }
}

class VideoIdParams extends Equatable {
  final String videoId;
  
  const VideoIdParams({required this.videoId});
  
  @override
  List<Object> get props => [videoId];
}