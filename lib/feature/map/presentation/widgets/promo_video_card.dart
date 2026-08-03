import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:trackify/core/utils/active_video_manager.dart';
import 'package:trackify/feature/map/data/entity/promo_video_model.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

/// Returns YouTube video ID if URL is a YouTube URL, otherwise null.
String? _extractYouTubeId(String url) {
  return YoutubePlayer.convertUrlToId(url);
}

bool _isYouTubeUrl(String url) {
  return _extractYouTubeId(url) != null;
}

// ─────────────────────────────────────────────
// PromoVideoCard
// ─────────────────────────────────────────────

class PromoVideoCard extends StatefulWidget {
  final PromoVideoModel video;

  const PromoVideoCard({Key? key, required this.video}) : super(key: key);

  @override
  State<PromoVideoCard> createState() => _PromoVideoCardState();
}

class _PromoVideoCardState extends State<PromoVideoCard> {
  // --- Direct video (non-YouTube) ---
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  // --- YouTube ---
  YoutubePlayerController? _youtubeController;

  bool _isInitialized = false;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isYoutube = false;

  @override
  void dispose() {
    _disposeAll();
    super.dispose();
  }

  Future<void> _disposeAll() async {
    try {
      _videoPlayerController?.removeListener(_videoListener);
      await _videoPlayerController?.pause();
      _chewieController?.dispose();
      await _videoPlayerController?.dispose();

      _youtubeController?.pause();
      _youtubeController?.dispose();

      _chewieController = null;
      _videoPlayerController = null;
      _youtubeController = null;

      if (mounted) {
        setState(() {
          _isInitialized = false;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      debugPrint("VIDEO DISPOSE ERROR: $e");
    }
  }

  void _videoListener() {
    if (_videoPlayerController == null || !mounted) return;
    if (_videoPlayerController!.value.isPlaying) {
      ActiveVideoManager.currentDispose = _disposeAll;
    }
  }

  Future<void> _startVideo() async {
    if (_isLoading) return;

    final videoUrl = widget.video.videoUrl.trim();
    if (videoUrl.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Video URL is missing.")),
        );
      }
      return;
    }

    final youtubeId = _extractYouTubeId(videoUrl);

    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Stop any other active video
      await ActiveVideoManager.stopCurrentVideo();

      if (youtubeId != null) {
        // ── YouTube ──────────────────────────────────
        _youtubeController = YoutubePlayerController(
          initialVideoId: youtubeId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: false,
            forceHD: false,
          ),
        );

        ActiveVideoManager.currentDispose = _disposeAll;

        if (mounted) {
          setState(() {
            _isYoutube = true;
            _isInitialized = true;
            _isLoading = false;
          });
        }
      } else {
        // ── Direct video URL ─────────────────────────
        debugPrint("PROMO VIDEO: Initializing direct URL: $videoUrl");

        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: false,
          ),
        );

        await _videoPlayerController!.initialize().timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException("Video loading timed out after 30s"),
        );

        // Check if player reported an internal error after initialize
        if (_videoPlayerController!.value.hasError) {
          final errMsg = _videoPlayerController!.value.errorDescription ?? "Unknown player error";
          debugPrint("PROMO VIDEO: Player error after init: $errMsg");
          throw Exception("Player error: $errMsg");
        }

        debugPrint("PROMO VIDEO: Init success, duration: ${_videoPlayerController!.value.duration}");

        _videoPlayerController!.addListener(_videoListener);

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
          allowMuting: true,
          showControls: true,
          aspectRatio: _videoPlayerController!.value.aspectRatio > 0
              ? _videoPlayerController!.value.aspectRatio
              : 16 / 9,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        );

        ActiveVideoManager.currentDispose = _disposeAll;

        if (mounted) {
          setState(() {
            _isYoutube = false;
            _isInitialized = true;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("PROMO VIDEO PLAY ERROR: $e");
      await _disposeAll();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialized = false;
          _hasError = true;
        });

        final errStr = e.toString().toLowerCase();
        final bool isCodecError = errStr.contains('codec') ||
            errStr.contains('decoder') ||
            errStr.contains('platformexception') ||
            errStr.contains('mediacodec') ||
            errStr.contains('0xfffffff');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCodecError
                  ? "This video format is not supported on your device."
                  : "Unable to play video. Please try again.",
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // ─────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
              child: _buildPlayer(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.video.title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    // YouTube player
    if (_isInitialized && _isYoutube && _youtubeController != null) {
      return YoutubePlayer(
        controller: _youtubeController!,
        showVideoProgressIndicator: true,
        progressColors: const ProgressBarColors(
          playedColor: Colors.yellow,
          handleColor: Colors.yellowAccent,
        ),
        onReady: () {
          _youtubeController!.play();
        },
      );
    }

    // Direct video (Chewie)
    if (_isInitialized && !_isYoutube && _chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    // Thumbnail + overlay
    return GestureDetector(
      onTap: _startVideo,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Thumbnail
          CachedNetworkImage(
            imageUrl: widget.video.thumbnailUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) =>
                const Center(child: TrackifyLoader()),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image,
                  color: Colors.grey, size: 50),
            ),
          ),

          // YouTube badge (small pill)
          if (_isYouTubeUrl(widget.video.videoUrl) && !_isLoading && !_hasError)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_filled,
                        color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text("YouTube",
                        style:
                            TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
              ),
            ),

          // Loading
          if (_isLoading) const TrackifyLoader(size: 185, animated: true),

          // Error overlay
          if (!_isLoading && _hasError)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.shade700.withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline,
                  color: Colors.white, size: 36),
            ),

          // Play button
          if (!_isLoading && !_hasError)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow,
                  color: Colors.white, size: 42),
            ),
        ],
      ),
    );
  }
}
