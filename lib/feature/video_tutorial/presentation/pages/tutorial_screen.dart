import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/config/font_manager.dart';
import '../cubit/tutorial_cubit.dart';
import '../cubit/tutorial_state.dart';

class TutorialScreen extends StatefulWidget {
  final String type;
  final String title;

  const TutorialScreen({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  int? playingIndex;

  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<TutorialCubit>().load(widget.type);
  }

  @override
  void dispose() {
    _disposeCurrentVideo();
    super.dispose();
  }

  Future<void> _disposeCurrentVideo() async {
    try {
      await _videoPlayerController?.pause();

      _chewieController?.dispose();
      await _videoPlayerController?.dispose();

      _chewieController = null;
      _videoPlayerController = null;

      if (mounted) {
        setState(() {
          _isInitialized = false;
          _isPlaying = false;
          _isLoading = false;
          playingIndex = null;
        });
      }
    } catch (e) {
      debugPrint("VIDEO DISPOSE ERROR: $e");
    }
  }

  Future<void> _handleVideoTap(
    String url,
    int index,
  ) async {

    try {

      if (_isLoading) return;

      // SAME VIDEO TOGGLE
      if (playingIndex == index &&
          _videoPlayerController != null &&
          _isInitialized) {

        if (_videoPlayerController!.value.isPlaying) {

          await _videoPlayerController!.pause();

          setState(() {
            _isPlaying = false;
          });

        } else {

          await _videoPlayerController!.play();

          setState(() {
            _isPlaying = true;
          });
        }

        return;
      }

      // NEW VIDEO
      await _disposeCurrentVideo();

      setState(() {
        _isLoading = true;
        playingIndex = index;
      });

      _videoPlayerController =
          VideoPlayerController.networkUrl(
        Uri.parse(url),
      );

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
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

  Widget _buildVideoCard(dynamic video, int index) {

    final bool isCurrentVideo =
        playingIndex == index &&
        _isInitialized &&
        _chewieController != null;

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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

                    // VIDEO
                    if (isCurrentVideo)
                      Chewie(
                        controller:
                            _chewieController!,
                      )

                    // THUMBNAIL
                    else
                      CachedNetworkImage(
                        imageUrl: video.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),

                    // LOADER
                    if (_isLoading &&
                        playingIndex == index)
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),

                    // PLAY BUTTON
                    if ((!isCurrentVideo ||
                            !_isPlaying) &&
                        !_isLoading)
                      Container(
                        padding:
                            const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black
                              .withOpacity(0.7),
                          shape: BoxShape.circle,
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
            padding: const EdgeInsets.all(10),
            child: Text(
              video.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        centerTitle: false,
        elevation: 0,

        title: Text(
          widget.title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight:
                FontWeightManager.medium,
          ),
        ),

        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
      ),

      body: BlocBuilder<
          TutorialCubit,
          TutorialState>(
        builder: (context, state) {

          if (state is TutorialLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TutorialError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is TutorialLoaded) {

            return ListView.builder(
              itemCount: state.list.length,

              itemBuilder: (context, index) {

                final video = state.list[index];

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