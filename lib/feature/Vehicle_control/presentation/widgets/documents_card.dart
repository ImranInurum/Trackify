import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

// Note: These screens need to be imported once they are created/available
// import 'package:trackify/feature/documents/presentation/pages/document_vehicle_rc_screen.dart';
// import 'package:trackify/feature/documents/presentation/pages/document_sub_screen.dart';

class DocumentsCard extends StatelessWidget {
  final Color cardColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const DocumentsCard({
    super.key,
    required this.cardColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _sectionTitle(
                  colorScheme,
                  title: l10n.vehicleDocumentsTitle,
                  subtitle: l10n.personalDocumentsSubtitle,
                ),
              ),
              Icon(Icons.arrow_forward, color: colorScheme.onSurfaceVariant, size: 24),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _docTile(context, colorScheme, title: l10n.vehicleRC, onTap: () {
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (_) => DocumentVehicleRCScreen(title: l10n.vehicleRCTitle),
                  // ));
                }),
                const SizedBox(width: 12),
                _docTile(context, colorScheme, title: l10n.insurance, onTap: () {
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (_) => DocumentSubScreen(title: l10n.insuranceTitle),
                  // ));
                }),
                const SizedBox(width: 12),
                _docTile(context, colorScheme, title: l10n.puc, onTap: () {
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (_) => DocumentSubScreen(title: l10n.pucTitle),
                  // ));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
      ColorScheme colorScheme,
      {required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle,
            textAlign: TextAlign.start,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
      ],
    );
  }

  Widget _docTile(BuildContext context, ColorScheme colorScheme,
      {required String title, required VoidCallback onTap, Widget? customContent}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.30,
            height: screenWidth * 0.30,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
            ),
            child: customContent ??
                Center(
                  child: Icon(Icons.note_add_outlined,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5), size: 32),
                ),
          ),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
        ],
      ),
    );
  }
}
