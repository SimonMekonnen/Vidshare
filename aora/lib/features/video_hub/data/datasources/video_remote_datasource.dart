// lib/features/video_gallery/data/datasources/video_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../model/video_model.dart';
import '../../domain/entities/video_upload.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> getVideos();
  Future<List<VideoModel>> searchVideos(String query);
  Future<VideoModel> getVideoById(String id);
  Future<bool> uploadVideo(VideoUpload videoUpload, String token);
  Future<bool> incrementViewCount(String videoId);
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  const VideoRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<VideoModel>> getVideos() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/videos/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> jsonList = json.decode(response.body);
        print(jsonList);
        return jsonList.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        final errorBody = json.decode(response.body);
        print(errorBody);
        throw ServerException(
          message: errorBody['detail'] ?? 'Failed to fetch videos',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'An error occurred while fetching videos: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<VideoModel>> searchVideos(String query) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/videos/search/?q=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        final errorBody = json.decode(response.body);
        throw ServerException(
          message: errorBody['message'] ?? 'Failed to search videos',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'An error occurred while searching videos: ${e.toString()}',
      );
    }
  }

  @override
  Future<VideoModel> getVideoById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/videos/$id/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return VideoModel.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw ServerException(
          message: errorBody['message'] ?? 'Failed to get video details',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message:
            'An error occurred while fetching video details: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> incrementViewCount(String videoId) {
    // TODO: implement incrementViewCount
    throw UnimplementedError();
  }

  @override
  Future<bool> uploadVideo(VideoUpload videoUpload, String token) {
    // TODO: implement uploadVideo
    throw UnimplementedError();
  }
}
