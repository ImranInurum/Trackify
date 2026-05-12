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

  const TutorialScreen({super.key, required this.type, required this.title});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {

  VideoPlayerController? _controller;
  int? playingIndex;

  @override
  void initState() {
    super.initState();
    context.read<TutorialCubit>().load(widget.type);
  }

  void playVideo(String url, int index) async {
    await _controller?.dispose();

    _controller = VideoPlayerController.networkUrl(Uri.parse(url));

    await _controller!.initialize();

    _controller!.play();

    setState(() {
      playingIndex = index;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

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
            fontWeight: FontWeightManager.medium,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      body: BlocBuilder<TutorialCubit, TutorialState>(
        builder: (context, state) {

          if (state is TutorialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TutorialLoaded) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, i) {
                final video = state.list[i];

                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [

                      /// 🖼️ THUMBNAIL ONLY (VIDEO PART COMMENTED)
                      GestureDetector(
                        onTap: () => playVideo(video.videoUrl, i),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: SizedBox(
                            height: 200,
                            width: double.infinity,

                            child: playingIndex == i &&
                                    _controller != null &&
                                    _controller!.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio:
                                        _controller!.value.aspectRatio,
                                    child: VideoPlayer(_controller!),
                                  )
                                : Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  video.thumbnail,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),

                                /// ▶ PLAY ICON (UI only)
                                const Icon(
                                  Icons.play_circle_fill,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// TITLE
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
              },
            );
          }

          if (state is TutorialError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}