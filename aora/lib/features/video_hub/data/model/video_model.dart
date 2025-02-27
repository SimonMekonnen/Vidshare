// lib/features/video_gallery/data/models/video_model.dart
import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.title,
    required super.thumbnailUrl,
    required super.description,
    required super.videoUrl,
    required super.uploadDate,
    required super.viewCount,
    required super.uploader,
    required super.likeCount,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnail'],
      description: json['description'],
      videoUrl: json['video_file'],
      uploadDate: DateTime.parse(json['created_at']),
      viewCount: json['views'],
      uploader: UserModel.fromJson(json['uploader']),
      likeCount: json['like_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail_url': thumbnailUrl,
      'description': description,
      'video_url': videoUrl,
      'created_at': uploadDate.toIso8601String(),
      'view_count': viewCount,
      'uploader_id': uploader,
    };
  }
}
