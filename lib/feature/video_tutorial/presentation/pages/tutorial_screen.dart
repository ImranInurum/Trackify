import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/feature/video_tutorial/presentation/cubit/tutorial_cubit.dart';
import 'package:trackify/feature/video_tutorial/presentation/cubit/tutorial_state.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class TutorialScreen extends StatefulWidget {
  final String categoryId;
  final String title;

  const TutorialScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  State<TutorialScreen> createState() =>
      _TutorialScreenState();
}

class _TutorialScreenState
    extends State<TutorialScreen> {

  // YOUTUBE
  YoutubePlayerController? _youtubeController;

  // NORMAL VIDEO
  VideoPlayerController?
  _videoPlayerController;

  ChewieController? _chewieController;

  int? playingIndex;

  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    context
        .read<TutorialCubit>()
        .load(widget.categoryId);
  }

  @override
  void dispose() {

    _youtubeController?.dispose();

    _chewieController?.dispose();

    _videoPlayerController?.dispose();

    super.dispose();
  }

  bool _isYoutubeUrl(String url) {

    return url.contains("youtube.com") ||
        url.contains("youtu.be");
  }

  Future<void> _disposeNormalVideo() async {

    await _videoPlayerController?.pause();

    _chewieController?.dispose();

    await _videoPlayerController?.dispose();

    _chewieController = null;

    _videoPlayerController = null;
  }

  Future<void> _handleVideoTap(
      String url,
      int index,
      ) async {

    print("VIDEO URL => $url");

    // =========================
    // YOUTUBE VIDEO
    // =========================

    if (_isYoutubeUrl(url)) {

      final videoId =
      YoutubePlayer.convertUrlToId(
        url,
      );

      if (videoId == null) {
        debugPrint(
          "Invalid YouTube URL",
        );
        return;
      }

      // SAME VIDEO TOGGLE
      if (playingIndex == index &&
          _youtubeController != null) {

        if (_isPlaying) {

          _youtubeController!.pause();

          setState(() {
            _isPlaying = false;
          });

        } else {

          _youtubeController!.play();

          setState(() {
            _isPlaying = true;
          });
        }

        return;
      }

      // NEW YOUTUBE VIDEO

      await _disposeNormalVideo();

      _youtubeController?.dispose();

      _youtubeController =
          YoutubePlayerController(
            initialVideoId: videoId,

            flags:
            const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          );

      setState(() {
        playingIndex = index;
        _isPlaying = true;
      });

      return;
    }

    // =========================
    // NORMAL MP4 VIDEO
    // =========================

    try {

      if (_isLoading) return;

      _youtubeController?.pause();

      await _disposeNormalVideo();

      setState(() {
        _isLoading = true;
        playingIndex = index;
      });

      _videoPlayerController =
          VideoPlayerController.networkUrl(
            Uri.parse(url),
          );

      await _videoPlayerController!
          .initialize();

      _chewieController =
          ChewieController(
            videoPlayerController:
            _videoPlayerController!,
            autoPlay: true,
            looping: false,
            showControls: true,
            allowMuting: true,
            allowFullScreen: true,
            aspectRatio:
            _videoPlayerController!
                .value
                .aspectRatio,
          );

      setState(() {
        _isInitialized = true;
        _isPlaying = true;
        _isLoading = false;
      });

    } catch (e) {

      debugPrint("VIDEO ERROR: $e");

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildVideoCard(
      dynamic video,
      int index,
      ) {

    final bool isCurrentVideo =
        playingIndex == index;

    return Container(
      margin: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius:
        BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          GestureDetector(
            onTap: () =>
                _handleVideoTap(
                  video.videoUrl,
                  index,
                ),

            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(
                top: Radius.circular(12),
              ),

              child: AspectRatio(
                aspectRatio: 16 / 9,

                child: Stack(
                  alignment: Alignment.center,

                  children: [

                    // ====================
                    // VIDEO PLAYER
                    // ====================

                    if (isCurrentVideo)

                      _isYoutubeUrl(
                        video.videoUrl,
                      )

                          ? YoutubePlayer(
                        controller:
                        _youtubeController!,
                        showVideoProgressIndicator:
                        true,
                      )

                          : Chewie(
                        controller:
                        _chewieController!,
                      )

                    // ====================
                    // THUMBNAIL
                    // ====================

                    else
                      CachedNetworkImage(
                        imageUrl:
                        video.thumbnail,

                        fit: BoxFit.cover,

                        width:
                        double.infinity,

                        height:
                        double.infinity,

                        placeholder:
                            (
                            context,
                            url,
                            ) =>
                        const Center(child: TrackifyLoader()),

                        errorWidget:
                            (
                            context,
                            url,
                            error,
                            ) =>
                        const Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                      ),

                    // ====================
                    // LOADER
                    // ====================

                    if (_isLoading &&
                        playingIndex ==
                            index)
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),

                    // ====================
                    // PLAY BUTTON
                    // ====================

                    if (!isCurrentVideo)
                      Container(
                        padding:
                        const EdgeInsets.all(
                          14,
                        ),

                        decoration:
                        BoxDecoration(
                          color: Colors.black
                              .withOpacity(0.7),

                          shape:
                          BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.all(12),

            child: Text(
              video.title,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Scaffold(
      backgroundColor:
      colorScheme.surface,

      appBar: AppBar(
        backgroundColor:
        colorScheme.surface,

        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          widget.title,

          style: TextStyle(
            color:
            colorScheme.onSurface,

            fontWeight:
            FontWeightManager.medium,
          ),
        ),

        iconTheme: IconThemeData(
          color:
          colorScheme.onSurface,
        ),
      ),

      body: BlocBuilder<
          TutorialCubit,
          TutorialState>(
        builder: (context, state) {

          if (state
          is TutorialLoading) {

            return const Center(child: TrackifyLoader());
          }

          if (state
          is TutorialError) {

            return Center(
              child:
              Text(state.message),
            );
          }

          if (state
          is TutorialLoaded) {

            if (state.list.isEmpty) {

              return const Center(
                child: Text(
                  "No videos found",
                ),
              );
            }

            return ListView.builder(
              itemCount:
              state.list.length,

              itemBuilder:
                  (
                  context,
                  index,
                  ) {

                final video =
                state.list[index];

                return _buildVideoCard(
                  video,
                  index,
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}