// lib/features/video_gallery/domain/repositories/video_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/video.dart';
import '../entities/video_upload.dart';

abstract class VideoRepository {
  /// Get all videos
  Future<Either<Failure, List<Video>>> getVideos();
  
  /// Search videos by query
  Future<Either<Failure, List<Video>>> searchVideos(String query);
  
  /// Get video by ID
  Future<Either<Failure, Video>> getVideoById(String id);
  
  /// Upload a new video
  Future<Either<Failure, bool>> uploadVideo(VideoUpload videoUpload);
  
  /// Increment view count for a video
  Future<Either<Failure, bool>> incrementViewCount(String videoId);
}