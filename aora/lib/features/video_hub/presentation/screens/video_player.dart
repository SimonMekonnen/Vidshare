import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../domain/entities/video.dart';

class ChewieVideoPlayer extends StatefulWidget {
  final Video video;

  const ChewieVideoPlayer({super.key, required this.video});

  @override
  State<ChewieVideoPlayer> createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showThumbnail = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Get the video URL from the video entity
      final videoUrl = widget.video.videoUrl;

      // Validate URL
      if (videoUrl.isEmpty) {
        throw Exception("Video URL is empty");
      }

      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        httpHeaders: {'User-Agent': 'Mozilla/5.0', 'Accept': '*/*'},
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        placeholder: _buildPlaceholder(),
        errorBuilder: (context, errorMessage) {
          return _buildErrorDisplay();
        },
        customControls: const MaterialControls(),
        materialProgressColors: ChewieProgressColors(
          playedColor: Theme.of(context).colorScheme.primary,
          handleColor: Theme.of(context).colorScheme.primary,
          bufferedColor: Colors.grey.withOpacity(0.5),
          backgroundColor: Colors.grey.withOpacity(0.2),
        ),
        // Hide options that might be causing layout issues
        showOptions: false,
        showControlsOnInitialize: false,
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  Widget _buildErrorDisplay() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 36),
            SizedBox(height: 8),
            Text(
              'Unable to load video',
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingDisplay() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildPlaceholder() {
    if (widget.video.thumbnailUrl.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.video.thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(color: Colors.black);
    }
  }

  Widget _buildThumbnailWithPlayButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showThumbnail = false;
        });
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          image:
              widget.video.thumbnailUrl.isNotEmpty
                  ? DecorationImage(
                    image: NetworkImage(widget.video.thumbnailUrl),
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 42),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorDisplay();
    }

    if (!_isInitialized) {
      return _buildLoadingDisplay();
    }

    if (_showThumbnail) {
      return _buildThumbnailWithPlayButton();
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                // Add black background to cover any potential artifacts
                Container(color: Colors.black),
                // Custom aspect ratio container to clip the bottom edge
                AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Stack(
                    children: [
                      // The actual video player
                      Chewie(controller: _chewieController!),
                      // Add a thin black overlay at the very bottom to cover the green line
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 2, // Slightly taller to ensure coverage
                        child: Container(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
