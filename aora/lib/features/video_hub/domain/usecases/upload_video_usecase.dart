// lib/features/video_gallery/domain/usecases/upload_video_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/video_upload.dart';
import '../repositories/video_repository.dart';

class UploadVideoUseCase implements UseCase<bool, VideoUpload> {
  final VideoRepository repository;
  
  UploadVideoUseCase(this.repository);
  
  @override
  Future<Either<Failure, bool>> call(VideoUpload params) async {
    return await repository.uploadVideo(params);
  }
}