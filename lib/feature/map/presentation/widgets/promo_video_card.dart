import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:trackify/core/utils/active_video_manager.dart';
import 'package:trackify/feature/map/data/entity/promo_video_model.dart';
import 'package:video_player/video_player.dart';

class PromoVideoCard extends StatefulWidget {
  final PromoVideoModel video;

  const PromoVideoCard({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  State<PromoVideoCard> createState() => _PromoVideoCardState();
}

class _PromoVideoCardState extends State<PromoVideoCard> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = false;

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
        });
      }
    } catch (e) {
      debugPrint("VIDEO DISPOSE ERROR: $e");
    }
  }

  Future<void> _handleVideoTap() async {
    try {
      if (_isLoading) return;

      // Pause/dispose previous playing video globally
      if (ActiveVideoManager.currentDispose != null &&
          ActiveVideoManager.currentDispose != _disposeCurrentVideo) {
        await ActiveVideoManager.currentDispose!();
      }

      // FIRST INITIALIZATION
      if (!_isInitialized) {
        setState(() {
          _isLoading = true;
        });

        final directory = await getTemporaryDirectory();
        
        final uri = Uri.parse(widget.video.videoUrl);
        String fileExtension = 'mp4';
        final segments = uri.pathSegments;
        if (segments.isNotEmpty) {
          final lastSegment = segments.last;
          if (lastSegment.contains('.')) {
            fileExtension = lastSegment.split('.').last;
          }
        }
        
        final fileName = 'promo_video_${widget.video.id}.$fileExtension';
        final file = File('${directory.path}/$fileName');

        if (!await file.exists()) {
          final response = await http.get(uri);
          if (response.statusCode == 200) {
            await file.writeAsBytes(response.bodyBytes);
          } else {
            throw Exception('Failed to download video: HTTP ${response.statusCode}');
          }
        }

        _videoPlayerController = VideoPlayerController.file(file);

        await _videoPlayerController!.initialize();

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
          allowMuting: true,
          showControls: true,
          aspectRatio: 16 / 9,
        );

        ActiveVideoManager.currentDispose = _disposeCurrentVideo;

        setState(() {
          _isInitialized = true;
          _isPlaying = true;
          _isLoading = false;
        });

        return;
      }

      // TOGGLE PLAY / PAUSE
      if (_videoPlayerController!.value.isPlaying) {
        await _videoPlayerController!.pause();

        setState(() {
          _isPlaying = false;
        });
      } else {
        await _videoPlayerController!.play();

        ActiveVideoManager.currentDispose = _disposeCurrentVideo;

        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint("VIDEO ERROR: $e");

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: GestureDetector(
                onTap: _handleVideoTap,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // VIDEO
                    if (_isInitialized &&
                        _chewieController != null)
                      Chewie(
                        controller: _chewieController!,
                      )

                    // THUMBNAIL
                    else
                      CachedNetworkImage(
                        imageUrl: widget.video.thumbnailUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) =>
                            const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                      ),

                    // LOADING
                    if (_isLoading)
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),

                    // PLAY BUTTON
                    if (!_isLoading && !_isPlaying)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
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
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.video.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}