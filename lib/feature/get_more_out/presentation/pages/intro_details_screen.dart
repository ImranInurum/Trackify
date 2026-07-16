import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../cubit/geo_fenc_cubit.dart';
import '../cubit/geo_fenc_state.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/geo_fence/presentation/pages/geo_fence_screen.dart';
import 'package:trackify/feature/location_sharing/presentation/pages/location_sharing_screen.dart';
import 'package:trackify/feature/safe_parking/presentation/pages/safe_parking_screen.dart';
import 'package:trackify/feature/emergency_sos/presentation/pages/emergency_alert_screen.dart';
import 'package:trackify/feature/overspeed_alert/presentation/screens/overspeed_alert_screen.dart';
import 'package:trackify/feature/map/presentation/cubit/map_cubit.dart';
import 'package:trackify/feature/map/presentation/cubit/map_state.dart';

class IntroDetailsScreen extends StatefulWidget {
  final String title;
  final String categoryId;
  const IntroDetailsScreen({
    super.key,
    required this.title,
    required this.categoryId,
  });

  @override
  State<IntroDetailsScreen> createState() => _IntroDetailsScreenState();
}

class _IntroDetailsScreenState extends State<IntroDetailsScreen> {
  final PageController pageController = PageController();

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    context.read<GeoFenceIntroCubit>().loadSlides(
      categoryId: widget.categoryId,
    );
  }

  late final l10n = AppLocalizations.of(context)!;

  void _handleNavigation(BuildContext context) {
    Widget? targetScreen;
    final titleLower = widget.title.toLowerCase();

    String? vehicleName;
    String? imei;
    var selectedDevice; // Using var or dynamic if we don't import Vehicle explicitly

    final mapState = context.read<MapCubit>().state;
    if (mapState is MapLoaded) {
      final vehicles = mapState.vehicleList.vehicles ?? [];
      if (vehicles.isNotEmpty) {
        final selectedUid = AppPreference.instance.getSync(
          key: AppPreference.KEY_SELECTED_UID,
        );
        selectedDevice = vehicles.firstWhere(
          (v) => v.id == selectedUid,
          orElse: () => vehicles.first,
        );
        vehicleName =
            "${selectedDevice.vehicleMaker} ${selectedDevice.vehicleNumber}";
        imei = selectedDevice.imei;
      }
    }

    if (titleLower.contains('geofence')) {
      targetScreen = GeoFenceScreen(vehicleName: vehicleName, imei: imei);
    } else if (titleLower.contains('location') ||
        titleLower.contains('share')) {
      targetScreen = const LocationSharingScreen();
    } else if (titleLower.contains('safe') || titleLower.contains('parking')) {
      targetScreen = const SafeParkingScreen();
    } else if (titleLower.contains('emergency') || titleLower.contains('sos')) {
      targetScreen = const EmergencyAlertScreen();
    } else if (titleLower.contains('overspeed') ||
        titleLower.contains('speed')) {
      targetScreen = OverSpeedAlertScreen(vehicle: selectedDevice);
    } else {
      // Fallback if needed, just pop out or do nothing
      Navigator.pop(context);
      return;
    }

    if (targetScreen != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => targetScreen!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 18,
          ),
        ),
        title: Text(
          "${widget.title} Intro",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      body: BlocBuilder<GeoFenceIntroCubit, GeoFenceIntroState>(
        builder: (context, state) {
          if (state is GeoFenceIntroLoaded) {
            final slides = state.slides;

            if (slides.isEmpty) {
              return Center(child: Text(l10n.noIntroDataAvailable));
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// PAGEVIEW
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: slides.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final slide = slides[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 400,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                  color: colorScheme.outlineVariant.withOpacity(
                                    0.1,
                                  ),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  slide.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: colorScheme.onSurface
                                            .withOpacity(0.5),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            Text(
                              slide.title,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              slide.description,
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 16,
                                height: 1.6,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  /// INDICATOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(slides.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: currentIndex == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? colorScheme.primary
                              : colorScheme.onSurface.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _handleNavigation(context),
                      child: Text(
                        slides[currentIndex].buttonText.isNotEmpty
                            ? slides[currentIndex].buttonText
                            : "Go to ${widget.title}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 11.5),
                ],
              ),
            );
          }

          if (state is GeoFenceIntroError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.onErrorContainer),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<GeoFenceIntroCubit>().loadSlides(
                          categoryId: widget.categoryId,
                        );
                      },
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: TrackifyLoader());
        },
      ),
    );
  }
}
