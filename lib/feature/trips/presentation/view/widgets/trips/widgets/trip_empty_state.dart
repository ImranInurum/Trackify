import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../../../../../../core/constants/app_images.dart';



class TripEmptyState extends StatelessWidget {
  const TripEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppImages.bikeInfoImage, height: 160),
        const SizedBox(height: 20),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            l10n.tripEmptyQuote,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
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
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.5)),
              const SizedBox(width: 10),
              Text(
                l10n.ridesCompletedCount("0", "3"),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.unlockTripsRequirement,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.5), fontSize: 12),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
