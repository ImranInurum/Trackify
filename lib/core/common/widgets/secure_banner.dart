import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class SecureBanner extends StatelessWidget {
  const SecureBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_rounded, color: Theme.of(context).colorScheme.secondary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.secureYourVehicleDesc,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
