import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:trackify/feature/map/data/entity/promo_video_model.dart';

class PromoVideoCard extends StatefulWidget {
  final PromoVideoModel video;

  const PromoVideoCard({Key? key, required this.video}) : super(key: key);

  @override
  State<PromoVideoCard> createState() => _PromoVideoCardState();
}

class _PromoVideoCardState extends State<PromoVideoCard> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _initializeAndPlay() async {
    setState(() {
      _isLoading = true;
      _isPlaying = true;
    });

    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl));
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        showControls: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error initializing video: $e');
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load video')),
        );
      }
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Video or Thumbnail Area
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _isPlaying
                  ? (_isLoading || _chewieController == null)
                      ? const Center(child: CircularProgressIndicator())
                      : Chewie(controller: _chewieController!)
                  : GestureDetector(
                      onTap: _initializeAndPlay,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.video.thumbnailUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                            ),
                          ),
                          Container(
                            color: Colors.black.withOpacity(0.3),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                                size: 64,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          // Title Area
          Padding(
            padding: const EdgeInsets.all(12.0),
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
