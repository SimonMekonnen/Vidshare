import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/video.dart';
import '../bloc/video_gallery/video_gallery_bloc.dart';
import 'video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch videos when page loads
    context.read<VideoGalleryBloc>().add(FetchVideos());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access theme colors from the context
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<VideoGalleryBloc, VideoGalleryState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome back section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'jsmastery',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            'assets/svgs/logo.svg',
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Search bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search for a video topic',
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: colorScheme.tertiary,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (query) {
                                if (query.length > 2) {
                                  context.read<VideoGalleryBloc>().add(
                                    SearchVideos(query: query),
                                  );
                                } else if (query.isEmpty) {
                                  context.read<VideoGalleryBloc>().add(
                                    FetchVideos(),
                                  );
                                }
                              },
                            ),
                          ),
                          Icon(Icons.search, color: Colors.white70),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Videos list with state handling
                    if (state is VideoGalleryLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    else if (state is VideoGalleryFailure)
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Error: ${state.error.message}',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<VideoGalleryBloc>().add(
                                  FetchVideos(),
                                );
                              },
                              child: Text('Try Again'),
                            ),
                          ],
                        ),
                      )
                    else if (state is VideoGalleryLoaded &&
                        state.videos.isEmpty)
                      Center(
                        child: Text(
                          'No videos found',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      )
                    else if (state is VideoGalleryLoaded)
                      _buildVideosList(state.videos)
                    else
                      Center(
                        child: Text(
                          'Start searching for videos',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: colorScheme.surface,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
        ],
      ),
    );
  }

  // Display videos from API data
  Widget _buildVideosList(List<Video> videos) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      'https://ui-avatars.com/api/?name=${video.uploader.username}&background=random',
                    ),
                    onBackgroundImageError: (_, __) {},
                    child: Icon(Icons.person, size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      video.title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white54),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Replace the Image.network with VideoPlayerWidget
              ChewieVideoPlayer(video: video),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'By: ${video.uploader.username}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${video.viewCount} views',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
