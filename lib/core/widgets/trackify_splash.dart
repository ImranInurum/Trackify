import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TrackifySplash extends StatefulWidget {
  final VoidCallback? onFinished;
  const TrackifySplash({super.key, this.onFinished});

  @override
  State<TrackifySplash> createState() => _TrackifySplashState();
}

class _TrackifySplashState extends State<TrackifySplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final size = MediaQuery.of(context).size;
    final double lottieSize = size.width * 1.3;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Center(
        child: SizedBox(
          width: lottieSize,
          height: lottieSize,
          child: Lottie.asset(
            'assets/lottie/trackify-splash.json',
            controller: _controller,
            fit: BoxFit.contain,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward().then((value) {
                  widget.onFinished?.call();
                });
            },
          ),
        ),
      ),
    );
  }
}
