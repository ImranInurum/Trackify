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
        color: const Color(0xFFFCF4E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_rounded, color: Color(0xFFD48A1C), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.secureYourVehicleDesc,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFD48A1C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
