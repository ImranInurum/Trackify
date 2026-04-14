// import 'package:flutter/material.dart';
// import '../../../../l10n/app_localizations.dart';
//
// class InteractiveSwipeButton extends StatefulWidget {
//   final VoidCallback onSwipe;
//   const InteractiveSwipeButton({super.key, required this.onSwipe});
//
//   @override
//   State<InteractiveSwipeButton> createState() => _InteractiveSwipeButtonState();
// }
//
// class _InteractiveSwipeButtonState extends State<InteractiveSwipeButton> {
//   double _dragValue = 0.0;
//   bool _isSuccess = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFD5DDE5), Color(0xFFB6C7D8)],
//           ),
//         ),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final double maxWidth = constraints.maxWidth;
//             final double buttonSize = 46.0;
//             final double endPadding = 4.0;
//             final double totalDragDistance = maxWidth - buttonSize - (endPadding * 2);
//
//             return Stack(
//               children: [
//                 Center(
//                   child: Text(
//                     l10n.swipeToLock,
//                     style: TextStyle(
//                       color: Colors.grey.shade800,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 13,
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: endPadding + (_dragValue * totalDragDistance),
//                   top: 2,
//                   child: GestureDetector(
//                     onHorizontalDragUpdate: (details) {
//                       if (_isSuccess) return;
//                       setState(() {
//                         _dragValue += details.primaryDelta! / totalDragDistance;
//                         _dragValue = _dragValue.clamp(0.0, 1.0);
//                       });
//                     },
//                     onHorizontalDragEnd: (details) {
//                       if (_isSuccess) return;
//                       if (_dragValue > 0.8) {
//                         setState(() {
//                           _dragValue = 1.0;
//                           _isSuccess = true;
//                         });
//                         widget.onSwipe();
//                         Future.delayed(const Duration(seconds: 2), () {
//                           if (mounted) {
//                             setState(() {
//                               _dragValue = 0.0;
//                               _isSuccess = false;
//                             });
//                           }
//                         });
//                       } else {
//                         setState(() {
//                           _dragValue = 0.0;
//                         });
//                       }
//                     },
//                     child: Container(
//                       width: buttonSize,
//                       height: buttonSize,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//                       ),
//                       child: Center(
//                         child: Icon(
//                           _isSuccess ? Icons.lock_rounded : Icons.lock_open_rounded,
//                           color: _isSuccess ? Colors.green : Colors.redAccent,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

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
                        border: Border.all(color: Colors.black, width: 1.5),
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
