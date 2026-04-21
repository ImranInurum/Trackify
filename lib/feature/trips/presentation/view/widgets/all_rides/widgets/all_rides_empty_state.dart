import 'package:flutter/material.dart';

class AllRidesEmptyState extends StatelessWidget {
  const AllRidesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/allRidesMap.png", height: 140),
        const SizedBox(height: 30),
        Text(
          "No daily rides to show",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Get started by taking your first ride",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        ),
      ],
    );
  }
}
