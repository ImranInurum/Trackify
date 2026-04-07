import 'package:flutter/material.dart';

class TripEmptyState extends StatelessWidget {
  const TripEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/tripScreenBike.png", height: 160),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "“Group your rides into trips, add memories, and relive the journey”",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 24),

        /// LOCK STATUS BOX
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 18, color: Color(0xFF555555)),
              const SizedBox(width: 10),
              Text(
                "Rides completed: 0/3",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "You need at least 3 rides to unlock trips",
          style: TextStyle(color: Color(0xFF888888), fontSize: 12),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
