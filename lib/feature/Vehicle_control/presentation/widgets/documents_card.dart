import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../document_folder/presentation/pages/document_ss.dart';
import '../../../document_folder/presentation/pages/document_vehicalRC_screen.dart';

// Note: These screens need to be imported once they are created/available
// import 'package:trackify/feature/documents/presentation/pages/document_vehicle_rc_screen.dart';
// import 'package:trackify/feature/documents/presentation/pages/document_sub_screen.dart';

class DocumentsCard extends StatelessWidget {
  final Color cardColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final VoidCallback? onTap;
  final String imei;

  const DocumentsCard({
    super.key,
    required this.cardColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.onTap,
    required this.imei,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
             onTap: onTap,
            child: Row(
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
                Icon(Icons.arrow_forward, color: colorScheme.onSurfaceVariant, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _docTile(context, colorScheme, title: l10n.vehicleRC, onTap: () {
                  if (imei.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.selectVehicle)),
                    );
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => DocumentVehicleRCScreen(
                      title: l10n.vehicleRCTitle,
                      vehicleId: imei,
                    ),
                  ));
                }),
                const SizedBox(width: 12),
                _docTile(context, colorScheme, title: l10n.insurance, onTap: () {
                  if (imei.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.selectVehicle)),
                    );
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => DocumentSubScreen(
                      title: l10n.insuranceTitle,
                      vehicleId: imei,
                      subtype: 'insurance',
                    ),
                  ));
                }),
                const SizedBox(width: 12),
                _docTile(context, colorScheme, title: l10n.puc, onTap: () {
                  if (imei.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.selectVehicle)),
                    );
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => DocumentSubScreen(
                      title: l10n.pucTitle,
                      vehicleId: imei,
                      subtype: 'puc',
                    ),
                  ));
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
            width: screenWidth * 0.25,
            height: screenWidth * 0.25,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
            ),
            child: customContent ??
                Center(
                  child: Icon(Icons.note_add_outlined,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5), size: 24),
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
