// lib/features/video_gallery/domain/entities/video_upload.dart
import 'package:equatable/equatable.dart';

class VideoUpload extends Equatable {
  final String title;
  final String description;
  final String thumbnailPath;
  final String videoPath;
  
  const VideoUpload({
    required this.title,
    required this.description,
    required this.thumbnailPath,
    required this.videoPath,
  });
  
  @override
  List<Object> get props => [
    title, 
    description, 
    thumbnailPath, 
    videoPath, 
  ];
}