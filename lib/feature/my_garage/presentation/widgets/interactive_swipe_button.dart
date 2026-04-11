import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';

class InteractiveSwipeButton extends StatefulWidget {
  final VoidCallback onSwipe;
  const InteractiveSwipeButton({super.key, required this.onSwipe});

  @override
  State<InteractiveSwipeButton> createState() => _InteractiveSwipeButtonState();
}

class _InteractiveSwipeButtonState extends State<InteractiveSwipeButton> {
  double _dragPosition = 0;
  final double _sliderHeight = 48.0;
  final double _handleSize = 36.0;
  bool _isWaiting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDrag = constraints.maxWidth - 32 - _handleSize - 8;
        return Container(
          height: _sliderHeight,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFD6E9F3),
            borderRadius: BorderRadius.circular(_sliderHeight / 2),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Centered Arrow Icons
              if (!_isWaiting)
                Opacity(
                  opacity: (1.0 - (_dragPosition / (maxDrag * 0.3))).clamp(0.0, 1.0),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
                        Icon(Icons.chevron_right, color: Colors.grey.shade500, size: 20),
                        Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
                      ],
                    ),
                  ),
                ),

              // Right-aligned "SWIPE TO LOCK" Text
              if (!_isWaiting)
                Positioned(
                  right: 20,
                  child: Opacity(
                    opacity: (1.0 - (_dragPosition / maxDrag)).clamp(0.0, 1.0),
                    child: Text(
                      l10n.swipeToLock,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF444444),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              // Revealed "WAITING TO LOCK" from the left as we drag
              if (!_isWaiting)
                Positioned(
                  left: 5,
                  child: Opacity(
                    opacity: (_dragPosition / maxDrag).clamp(0.0, 1.0),
                    child: SizedBox(
                      width: _dragPosition + _handleSize,
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                "WAITING...",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF444444),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Final Waiting State
              if (_isWaiting)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isWaiting = false;
                                _dragPosition = 0;
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "WAITING TO LOCK",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF444444),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFC7514D).withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Color(0xFFC7514D),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),

              // The Draggable Handle
              if (!_isWaiting)
                Positioned(
                  left: 4 + _dragPosition,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _dragPosition += details.delta.dx;
                        _dragPosition = _dragPosition.clamp(0.0, maxDrag);
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (_dragPosition >= maxDrag * 0.9) {
                        setState(() {
                          _isWaiting = true;
                          _dragPosition = maxDrag;
                        });
                        widget.onSwipe();
                      } else {
                        setState(() {
                          _dragPosition = 0;
                        });
                      }
                    },
                    child: Container(
                      width: _handleSize,
                      height: _handleSize,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_open_rounded,
                        color: Color(0xFFC7514D),
                        size: 20,
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
