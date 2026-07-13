// TrackifyLoader — progress-fill wordmark loader (Flutter)
//
// Usage:
//   TrackifyLoader(progress: 65, message: 'Loading fleet data...')
//
// Setup:
// 1. Copy assets/trackify_wordmark.png into your app's assets/ folder.
// 2. Register it in pubspec.yaml:
//      flutter:
//        assets:
//          - assets/trackify_wordmark.png
//
// Note: the source PNG has a flattened white background (no alpha channel).
// This widget looks correct on white / very light backgrounds, matching the
// web version. If you need it on a dark or colored background, ask design
// for a transparent-background export of the wordmark.

import 'package:flutter/material.dart';

class TrackifyLoader extends StatefulWidget {
  final double progress; // 0-100. Ignored if animated is true.
  final double size;
  final String? message;
  final bool showPercentage;
  final bool animated; // true = auto-loops demo 0→25→50→75→100→reset
  final Duration transitionDuration;

  const TrackifyLoader({
    super.key,
    this.progress = 0,
    this.size = 260,
    this.message,
    this.showPercentage = false,
    this.animated = false,
    this.transitionDuration = const Duration(milliseconds: 400),
  });

  @override
  State<TrackifyLoader> createState() => _TrackifyLoaderState();
}

class _TrackifyLoaderState extends State<TrackifyLoader> {
  double _progress = 0;
  int _stopIndex = 0;
  static const _stops = [0.0, 25.0, 50.0, 75.0, 100.0];

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _progress = 0;
      _scheduleLoop();
    } else {
      _progress = widget.progress;
    }
  }

  @override
  void didUpdateWidget(covariant TrackifyLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.animated && widget.progress != oldWidget.progress) {
      setState(() => _progress = widget.progress);
    }
  }

  void _scheduleLoop() {
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || !widget.animated) return;
      _stopIndex = (_stopIndex + 1) % _stops.length;
      setState(() => _progress = _stops[_stopIndex]);
      if (_stops[_stopIndex] == 100) {
        Future.delayed(const Duration(milliseconds: 1400), () {
          if (!mounted) return;
          _stopIndex = 0;
          setState(() => _progress = 0);
          _scheduleLoop();
        });
      } else {
        _scheduleLoop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final clamped = _progress.clamp(0, 100).toDouble();
    final height = widget.size * (292 / 793);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: height,
          child: Stack(
            children: [
              // base outline layer — greyscale + low opacity
              Positioned.fill(
                child: Opacity(
                  opacity: 0.4,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0, 0, 0, 1, 0,
                    ]),
                    child: Image.asset(
                      'assets/icons/appLogo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // filled layer — animates left → right
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: clamped / 100),
                duration: widget.transitionDuration,
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return ClipRect(
                    clipper: _LeftToRightClipper(value),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/icons/appLogo.png',
                  width: widget.size,
                  height: height,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        if (widget.showPercentage) ...[
          const SizedBox(height: 16),
          Text(
            '${clamped.round()}%',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0091C9),
            ),
          ),
        ],
        if (widget.message != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.message!,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ],
      ],
    );
  }
}

class _LeftToRightClipper extends CustomClipper<Rect> {
  final double progress; // 0..1
  _LeftToRightClipper(this.progress);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * progress, size.height);

  @override
  bool shouldReclip(covariant _LeftToRightClipper oldClipper) => oldClipper.progress != progress;
}
