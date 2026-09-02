import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';

class SwipeToLock extends StatefulWidget {
  final VoidCallback onSwipe;
  final String text;

  const SwipeToLock({
    super.key,
    required this.onSwipe,
    required this.text,
  });

  @override
  State<SwipeToLock> createState() => _SwipeToLockState();
}

class _SwipeToLockState extends State<SwipeToLock> {
  double _position = 0.0;
  final double _buttonSize = 48.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxPosition = (maxWidth - _buttonSize - 8.0).clamp(0.0, double.infinity);

        return Container(
          height: 56,
          width: maxWidth,
          decoration: BoxDecoration(
            color: const Color(0xFFE1F5FE), // Light blue background
            borderRadius: BorderRadius.circular(28),
          ),
          child: Stack(
            children: [
              // Swipe indicators (>>>) in the middle
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 48), // Offset for the thumb
                    Icon(Icons.chevron_right, color: Colors.blue.withOpacity( 0.3), size: 20),
                    Icon(Icons.chevron_right, color: Colors.blue.withOpacity( 0.5), size: 20),
                    Icon(Icons.chevron_right, color: Colors.blue.withOpacity( 0.7), size: 20),
                    const SizedBox(width: 12),
                    Text(
                      widget.text.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              // Draggable thumb
              Positioned(
                left: _position + 4,
                top: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _position += details.delta.dx;
                      if (_position < 0) _position = 0;
                      if (_position > maxPosition) _position = maxPosition;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_position >= maxPosition * 0.9) {
                      widget.onSwipe();
                    }
                    setState(() {
                      _position = 0;
                    });
                  },
                  child: Container(
                    width: _buttonSize,
                    height: _buttonSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red.withOpacity( 0.3), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity( 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_open_outlined,
                      color: Colors.redAccent,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
