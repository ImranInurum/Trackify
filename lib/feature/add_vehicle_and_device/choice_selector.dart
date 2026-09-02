import 'package:flutter/material.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/l10n/app_localizations.dart';

import 'add_vehicle/presentation/view/add_vehicle_screen.dart';
import '../device_installation/presentation/pages/device_installation_screen.dart';
import 'package:trackify/core/widgets/logout_confirmation_dialog.dart';

class ChoiceSelector extends StatefulWidget {
  const ChoiceSelector({super.key});

  @override
  State<ChoiceSelector> createState() => _ChoiceSelectorState();
}

class _ChoiceSelectorState extends State<ChoiceSelector> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canPop = Navigator.of(context).canPop();
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async => canPop,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: canPop
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                )
              : null,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // Install Trackify Device Card
                      _buildEnhancedChoiceCard(
                        context: context,
                        title: l10n.installDevice,
                        subtitle: l10n.installDeviceDesc,
                        imagePath: AppImages.installDevices,
                        imageWidth: 95,
                        imageHeight: 95,
                        accentColor: theme.colorScheme.primary,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DeviceInstallationScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Explore Our Free App Card
                      _buildEnhancedChoiceCard(
                        context: context,
                        title: l10n.exploreFreeApp,
                        subtitle: l10n.exploreFreeAppDesc,
                        imagePath: AppImages.exploreApp,
                        imageWidth: 85,
                        imageHeight: 95,
                        accentColor: const Color(0xFF00B4D8),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AddVehicleScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextButton.icon(
                  onPressed: () => LogoutConfirmationDialog.show(context),
                  icon: Icon(
                    Icons.logout,
                    color: theme.colorScheme.onSurface.withOpacity( 0.5),
                    size: 20,
                  ),
                  label: Text(
                    l10n.logout,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity( 0.5),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedChoiceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imagePath,
    required Color accentColor,
    double imageWidth = 85,
    double imageHeight = 85,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity( 0.4),
          width: 0.8,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primaryContainer.withOpacity( 0.25),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity( 0.65),
                          fontSize: 13.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: imageWidth,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity( 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.devices_other_outlined,
                            size: 40,
                            color: theme.hintColor.withOpacity( 0.5),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity( 0.85),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: theme.colorScheme.onSurface.withOpacity( 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
