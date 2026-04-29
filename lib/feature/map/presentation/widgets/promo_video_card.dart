import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trackify/feature/map/data/entity/promo_video_model.dart';

class PromoVideoCard extends StatefulWidget {
  final PromoVideoModel video;

  const PromoVideoCard({Key? key, required this.video}) : super(key: key);

  @override
  State<PromoVideoCard> createState() => _PromoVideoCardState();
}

class _PromoVideoCardState extends State<PromoVideoCard> {
  // Video player logic commented out as requested
  /*
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _cleanupVideo();
    super.dispose();
  }

  Future<void> _cleanupVideo() async {
    try {
      final oldChewie = _chewieController;
      final oldVideo = _videoPlayerController;
      
      _chewieController = null;
      _videoPlayerController = null;
      
      oldChewie?.dispose();
      await oldVideo?.pause();
      await oldVideo?.dispose();
      
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isLoading = false;
        });
      }
      debugPrint("VIDEO: Resources released for ${widget.video.title}");
    } catch (e) {
      debugPrint("VIDEO CLEANUP ERROR: $e");
    }
  }

  Future<void> _initializeAndPlay() async {
    // Prevent multiple clicks while loading
    if (_isLoading) return;

    if (widget.video.videoUrl.isEmpty) {
      debugPrint("VIDEO ERROR: URL is empty");
      return;
    }

    setState(() {
      _isLoading = true;
      _isPlaying = true;
    });

    try {
      debugPrint("VIDEO: Initializing ${widget.video.videoUrl}");
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.videoUrl),
      );

      await _videoPlayerController!.initialize();

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
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
      debugPrint("VIDEO: Ready and Playing");
    } catch (e) {
      debugPrint("VIDEO PLAY ERROR: $e");
      _cleanupVideo();
    }
  }
  */

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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: widget.video.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.video.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
