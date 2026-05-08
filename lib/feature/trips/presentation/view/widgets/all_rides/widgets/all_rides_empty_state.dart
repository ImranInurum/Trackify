import 'package:flutter/material.dart';

import '../../../../../../../l10n/app_localizations.dart';

class AllRidesEmptyState extends StatelessWidget {
  const AllRidesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            ),
            const SizedBox(height: 30),
            Text(
              l10n.noDailyRides,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.getStartedFirstRide,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}