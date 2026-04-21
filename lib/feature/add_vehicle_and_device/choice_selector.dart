import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';
import '../onboarding/presentation/cubit/splash_cubit.dart';
import '../onboarding/presentation/cubit/splash_state.dart';
import 'add_vehicle/presentation/view/add_vehicle_screen.dart';

class ChoiceSelector extends StatefulWidget {
  const ChoiceSelector({super.key});

  @override
  State<ChoiceSelector> createState() => _ChoiceSelectorState();
}

class _ChoiceSelectorState extends State<ChoiceSelector> {
  Widget _buildLogo(SplashState state, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child:
            (state is SplashLoaded &&
                state.logo.path != null &&
                state.logo.path!.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: state.logo.path!,
                height: 160,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                errorWidget: (context, url, error) => Icon(
                  Icons.track_changes_rounded,
                  size: 64,
                  color: colorScheme.primary,
                ),
              )
            : Icon(Icons.track_changes_rounded, size: 64, color: colorScheme.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Logo — dynamic via SplashCubit (same pattern as SignInScreen)
                    BlocBuilder<SplashCubit, SplashState>(
                      builder: (context, splashState) {
                        return _buildLogo(splashState, Theme.of(context).colorScheme);
                      },
                    ),
                    const SizedBox(height: 50),

                    // Cards
                    _buildChoiceCard(
                      context: context,
                      title: l10n.installDevice,
                      subtitle: l10n.installDeviceDesc,
                      imagePath: AppImages.installDevices,
                      imageWidth: 90,
                      imageHeight: 90,
                      onTap: () {
                        // TODO: Navigate to device install
                      },
                    ),

                    _buildChoiceCard(
                      context: context,
                      title: l10n.activateSticker,
                      subtitle: l10n.activateStickerDesc,
                      imagePath: AppImages.activateContactSticker,
                      imageWidth: 70,
                      imageHeight: 70,
                      onTap: () {
                        // TODO: Navigate to sticker activation
                      },
                    ),

                    _buildChoiceCard(
                      context: context,
                      title: l10n.exploreFreeApp,
                      subtitle: l10n.exploreFreeAppDesc,
                      imagePath: AppImages.exploreApp,
                      imageWidth: 70,
                      imageHeight: 90,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddVehicleScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextButton.icon(
                onPressed: () {
                  final prefs = AppPreference.instance;
                  prefs.clearAll();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  size: 20,
                ),
                label: Text(
                  l10n.logout,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imagePath,
    double imageWidth = 70,
    double imageHeight = 70,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).cardColor.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                size: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: imageWidth,
                          height: imageHeight,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.fill,
                            alignment: Alignment.bottomRight,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.inventory_2_outlined,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
