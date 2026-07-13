import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

const kCyanLight = Color(0xFF00B8E6);
const kCyanDark = Color(0xFF0091C9);

class TrackifySplash extends StatefulWidget {
  final VoidCallback? onFinished;
  const TrackifySplash({super.key, this.onFinished});

  @override
  State<TrackifySplash> createState() => _TrackifySplashState();
}

class _TrackifySplashState extends State<TrackifySplash> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _c.forward();
    _c.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onFinished?.call();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double _seg(double startMs, double endMs) {
    final t = _c.value * 1500;
    return ((t - startMs) / (endMs - startMs)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final dotT = _seg(0, 200);
          final dotOpacity = (dotT * 3).clamp(0.0, 1.0) * (1 - _seg(180, 240));
          final pinDrawT = _seg(200, 550);
          final routeT = _seg(450, 800);
          final symT = Curves.easeOutCubic.transform(_seg(700, 1000));
          final symScale = 0.9 + 0.1 * symT;
          final glow = math.sin(_seg(700, 1000) * math.pi) * 0.5;
          final wmT = Curves.easeOutCubic.transform(_seg(850, 1200));
          final appT = _seg(1350, 1500);

          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (dotT < 1)
                            Opacity(
                              opacity: dotOpacity,
                              child: Container(
                                width: 12, height: 12,
                                decoration: const BoxDecoration(color: kCyanLight, shape: BoxShape.circle),
                              ),
                            ),
                          if (pinDrawT > 0)
                            Transform.scale(
                              scale: symScale,
                              child: Opacity(
                                opacity: pinDrawT,
                                child: CustomPaint(
                                  size: const Size(140, 180),
                                  painter: _PinPainter(drawT: pinDrawT, glow: glow),
                                ),
                              ),
                            ),
                          if (routeT > 0)
                            Positioned(
                              bottom: 18,
                              child: Opacity(
                                opacity: routeT,
                                child: CustomPaint(
                                  size: const Size(120, 30),
                                  painter: _RoutePainter(carT: routeT),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, 10 * (1 - wmT)),
                      child: Opacity(
                        opacity: wmT,
                        child: Image.asset('assets/icons/appLogo.png', height: 64),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
        },
      ),
    );
  }
}

class _PinPainter extends CustomPainter {
  final double drawT; // 0..1 outline reveal
  final double glow;
  _PinPainter({required this.drawT, required this.glow});

  Path _pinPath(Size size) {
    // teardrop pin, drawn in a 220x240 local space then scaled to `size`
    final path = Path();
    path.moveTo(110, 24);
    path.cubicTo(156, 24, 192, 59, 192, 102);
    path.cubicTo(192, 156, 130, 220, 113, 250);
    path.cubicTo(111, 254, 109, 254, 107, 250);
    path.cubicTo(90, 220, 28, 156, 28, 102);
    path.cubicTo(28, 59, 64, 24, 110, 24);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 220;
    final scaleY = size.height / 260;
    canvas.save();
    canvas.scale(scaleX, scaleY);
    final path = _pinPath(size);

    if (glow > 0) {
      final glowPaint = Paint()
        ..color = kCyanLight.withOpacity(0.18 * glow)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
      canvas.drawCircle(const Offset(110, 100), 70, glowPaint);
    }

    final strokeReveal = (drawT * 1.4).clamp(0.0, 1.0);
    if (strokeReveal < 1) {
      final metrics = path.computeMetrics().first;
      final extract = metrics.extractPath(0, metrics.length * strokeReveal);
      canvas.drawPath(
        extract,
        Paint()
          ..color = kCyanLight
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round,
      );
    }

    final fillIn = ((drawT - 0.6) / 0.4).clamp(0.0, 1.0);
    if (fillIn > 0) {
      final shader = ui.Gradient.linear(
        const Offset(110, 24), const Offset(110, 250),
        [kCyanLight.withOpacity(fillIn), kCyanDark.withOpacity(fillIn)],
      );
      canvas.drawPath(path, Paint()..shader = shader);
      canvas.drawCircle(const Offset(110, 100), 27, Paint()..color = Colors.white.withOpacity(fillIn));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PinPainter old) => old.drawT != drawT || old.glow != glow;
}

class _RoutePainter extends CustomPainter {
  final double carT;
  _RoutePainter({required this.carT});

  @override
  void paint(Canvas canvas, Size size) {
    final dashPaint = Paint()
      ..color = kCyanDark.withOpacity(0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final rect = Rect.fromCenter(center: Offset(size.width / 2, 8), width: size.width, height: 16);
    // simple dashed ellipse approximation
    const dashCount = 14;
    for (int i = 0; i < dashCount; i++) {
      final a0 = (i / dashCount) * 2 * math.pi;
      final a1 = a0 + (math.pi / dashCount) * 0.6;
      final p0 = Offset(rect.center.dx + rect.width / 2 * math.cos(a0), rect.center.dy + rect.height / 2 * math.sin(a0));
      final p1 = Offset(rect.center.dx + rect.width / 2 * math.cos(a1), rect.center.dy + rect.height / 2 * math.sin(a1));
      canvas.drawLine(p0, p1, dashPaint);
    }
    // car
    final carX = size.width * carT;
    final carRect = Rect.fromCenter(center: Offset(carX.clamp(14, size.width - 14), 6), width: 26, height: 12);
    canvas.drawRRect(RRect.fromRectAndRadius(carRect, const Radius.circular(4)), Paint()..color = kCyanDark);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) => old.carT != carT;
}
