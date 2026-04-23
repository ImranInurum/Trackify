import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../widgets/sticker_badge.dart';
import '../widgets/feature_card.dart';
import '../widgets/feature_list_item.dart';
import '../widgets/sticker_action_buttons.dart';

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Top Badge
            Center(child: StickerBadge(text: l10n.smartContactSticker)),

            const SizedBox(height: 16),

            // Subtitle
            Text(
              l10n.stickerSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodySmall?.color,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            // Banner Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/scanner_image.png',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: theme.cardColor,
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            StickerActionButtons(
              activateLabel: l10n.activateContactSticker,
              buyLabel: l10n.buyNewContactSticker,
              onActivate: () {
                // TODO: Implement activation
              },
              onBuy: () {
                // TODO: Implement buy
              },
            ),

            const SizedBox(height: 40),

            // Beyond Parking Problems Section
            Text(
              l10n.beyondParkingProblems,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                FeatureCard(
                  icon: Icons.not_interested_rounded,
                  label: l10n.noParkings,
                ),
                const SizedBox(width: 12),
                FeatureCard(
                  icon: Icons.medical_services_outlined,
                  label: l10n.emergencies,
                ),
                const SizedBox(width: 12),
                FeatureCard(
                  icon: Icons.car_repair_outlined,
                  label: l10n.vehicleTowing,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Info Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.getInformedStayConnected,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(height: 22),

                  FeatureListItem(
                    icon: Icons.verified_user_rounded,
                    title: l10n.securedCalls,
                    description: l10n.securedCallsDesc,
                  ),
                  FeatureListItem(
                    icon: Icons.notification_important_rounded,
                    title: l10n.notificationHistory,
                    description: l10n.notificationHistoryDesc,
                  ),
                  FeatureListItem(
                    icon: Icons.qr_code_2_rounded,
                    title: l10n.beInformed,
                    description: l10n.beInformedDesc,
                  ),
                  FeatureListItem(
                    icon: Icons.edit_note_rounded,
                    title: l10n.controlWhatOthersSee,
                    description: l10n.controlWhatOthersSeeDesc,
                  ),
                  FeatureListItem(
                    icon: Icons.warning_rounded,
                    title: l10n.preventFrustrationDamage,
                    description: l10n.preventFrustrationDamageDesc,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Repeat Buttons at bottom
            StickerActionButtons(
              activateLabel: l10n.activateContactSticker,
              buyLabel: l10n.buyNewContactSticker,
              onActivate: () {},
              onBuy: () {},
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
