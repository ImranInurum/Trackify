import 'package:flutter/material.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_empty_state.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_tooltip.dart';

class Trips extends StatefulWidget {
  const Trips({super.key});

  @override
  State<Trips> createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  bool _showOverlay = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// BACKGROUND CONTENT (Always visible)
        const TripEmptyState(),

        /// TOOLTIP & OVERLAY
        if (_showOverlay) ...[
          /// SEMI-TRANSPARENT OVERLAY
          GestureDetector(
            onTap: () => setState(() => _showOverlay = false),
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),

          /// FLOATING TOOLTIP
          Positioned(
            bottom: 40, // Lowered significantly to avoid overlapping the lock box
            child: TripTooltip(
              onSkip: () {
                setState(() {
                  _showOverlay = false;
                });
              },
            ),
          ),
        ],
      ],
    );
  }
}
