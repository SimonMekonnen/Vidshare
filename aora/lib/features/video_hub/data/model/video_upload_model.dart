// lib/features/video_gallery/data/models/video_upload_model.dart
import '../../domain/entities/video_upload.dart';

class VideoUploadModel extends VideoUpload {
  const VideoUploadModel({
    required super.title,
    required super.description,
    required super.thumbnailPath,
    required super.videoPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'thumbnail_path': thumbnailPath,
      'video_path': videoPath,
    };
  }
}