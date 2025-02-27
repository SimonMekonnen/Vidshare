// lib/features/video_gallery/data/repositories/video_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/video.dart';
import '../../domain/entities/video_upload.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_remote_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  VideoRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Video>>> getVideos() async {
    if (await networkInfo.isConnected) {
      try {
        final videos = await remoteDataSource.getVideos();
        return Right(videos);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(const NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Video>> getVideoById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final video = await remoteDataSource.getVideoById(id);
        return Right(video);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(const NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Video>>> searchVideos(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final videos = await remoteDataSource.searchVideos(query);
        return Right(videos);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(const NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> uploadVideo(VideoUpload videoUpload) async {
    if (await networkInfo.isConnected) {
      try {
        // Note: This would need auth token handling similar to your auth implementation
        // For now focusing on the core functionality
        final result = await remoteDataSource.uploadVideo(videoUpload, ""); // Token handling will be added later
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(const NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> incrementViewCount(String videoId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.incrementViewCount(videoId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(const NetworkFailure());
    }
  }
}