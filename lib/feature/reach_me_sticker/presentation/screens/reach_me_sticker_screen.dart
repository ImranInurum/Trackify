import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../widgets/sticker_badge.dart';
import '../widgets/feature_card.dart';
import '../widgets/feature_list_item.dart';
import '../widgets/sticker_action_buttons.dart';
import '../widgets/dynamic_sticker_preview.dart';
import 'scan_qr_screen.dart';

class ReachMeStickerScreen extends StatefulWidget {
  const ReachMeStickerScreen({super.key});

  @override
  State<ReachMeStickerScreen> createState() => _ReachMeStickerScreenState();
}

class _ReachMeStickerScreenState extends State<ReachMeStickerScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.reachMeSticker,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Badge
            Center(child: StickerBadge(text: l10n.smartContactSticker)),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              l10n.stickerSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.65),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // Dynamic Theme-Responsive Banner Sticker
            const DynamicStickerPreview(),

            const SizedBox(height: 20),

            // Action Buttons
            StickerActionButtons(
              activateLabel: l10n.activateContactSticker,
              buyLabel: l10n.buyNewContactSticker,
              onActivate: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ScanQrScreen()),
                );
              },
              onBuy: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.buyFeatureComingSoon)),
                );
              },
            ),

            const SizedBox(height: 28),

            // Beyond Parking Problems Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.beyondParkingProblems,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                FeatureCard(
                  icon: Icons.not_interested_rounded,
                  label: l10n.noParkings,
                ),
                const SizedBox(width: 10),
                FeatureCard(
                  icon: Icons.medical_services_outlined,
                  label: l10n.emergencies,
                ),
                const SizedBox(width: 10),
                FeatureCard(
                  icon: Icons.car_repair_outlined,
                  label: l10n.vehicleTowing,
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Info Card Section
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? theme.colorScheme.outline.withOpacity(0.2)
                      : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      l10n.getInformedStayConnected,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  FeatureListItem(
                    icon: Icons.verified_user_rounded,
                    title: l10n.securedCalls,
                    description: l10n.securedCallsDesc,
                  ),
                  Divider(height: 1, color: theme.dividerColor.withOpacity(0.3)),
                  FeatureListItem(
                    icon: Icons.notification_important_rounded,
                    title: l10n.notificationHistory,
                    description: l10n.notificationHistoryDesc,
                  ),
                  Divider(height: 1, color: theme.dividerColor.withOpacity(0.3)),
                  FeatureListItem(
                    icon: Icons.qr_code_2_rounded,
                    title: l10n.beInformed,
                    description: l10n.beInformedDesc,
                  ),
                  Divider(height: 1, color: theme.dividerColor.withOpacity(0.3)),
                  FeatureListItem(
                    icon: Icons.edit_note_rounded,
                    title: l10n.controlWhatOthersSee,
                    description: l10n.controlWhatOthersSeeDesc,
                  ),
                  Divider(height: 1, color: theme.dividerColor.withOpacity(0.3)),
                  FeatureListItem(
                    icon: Icons.warning_rounded,
                    title: l10n.preventFrustrationDamage,
                    description: l10n.preventFrustrationDamageDesc,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
