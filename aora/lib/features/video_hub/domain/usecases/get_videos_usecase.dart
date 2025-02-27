// lib/features/video_gallery/domain/usecases/get_videos_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/video.dart';
import '../repositories/video_repository.dart';

class GetVideosUseCase implements UseCase<List<Video>, NoParams> {
  final VideoRepository repository;
  
  GetVideosUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<Video>>> call(NoParams params) async {
    return await repository.getVideos();
  }
}