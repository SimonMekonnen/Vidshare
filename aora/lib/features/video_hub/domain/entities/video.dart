// lib/features/video_gallery/domain/entities/video.dart
import 'package:aora/features/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String description;
  final String videoUrl;
  final DateTime uploadDate;
  final int viewCount;
  final User uploader;
  final int likeCount;

  const Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.description,
    required this.videoUrl,
    required this.uploadDate,
    required this.viewCount,
    required this.uploader,
    required this.likeCount,
  });

  @override
  List<Object> get props => [
    id,
    title,
    thumbnailUrl,
    description,
    videoUrl,
    uploader,
    uploadDate,
    viewCount,
    likeCount,
  ];
}
