import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/get_more_out/presentation/pages/rides_statistics_screen.dart';
import 'package:trackify/feature/get_more_out/presentation/pages/safety_security_screen.dart';
import 'package:trackify/feature/get_more_out/presentation/pages/vehicle_device_screen.dart';
import 'package:trackify/feature/get_more_out/presentation/pages/vehicle_tracking_screen.dart';
import 'package:trackify/l10n/app_localizations_ar.dart';

import '../../../../l10n/app_localizations.dart';
import '../cubit/discover_cubit.dart';
import '../cubit/disocver_state.dart';


class DiscoverFeaturesScreen
    extends StatefulWidget {

  const DiscoverFeaturesScreen({super.key});

  @override
  State<DiscoverFeaturesScreen> createState() =>
      _DiscoverFeaturesScreenState();
}

class _DiscoverFeaturesScreenState
    extends State<DiscoverFeaturesScreen> {

  @override
  void initState() {
    context.read<DiscoverCubit>().loadFeatures();
    super.initState();
  }

  late final l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onSurface,
            size: 18,
          ),
        ),
        title: Text(
          l10n.discoverTrackifyFeatures,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// ================= BODY =================
      body: BlocBuilder<DiscoverCubit, DiscoverState>(
        builder: (context, state) {
          /// ================= LOADED =================
          if (state is DiscoverLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.features.length,
              itemBuilder: (context, index) {
                final feature = state.features[index];

                return GestureDetector(
                  onTap: () {
                    /// SAFETY
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SafetySecurityScreen(),
                        ),
                      );
                    }
                    /// TRACKING
                    else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VehicleTrackingScreen(),
                        ),
                      );
                    }
                    /// RIDES
                    else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RidesStatisticsScreen(),
                        ),
                      );
                    }
                    /// DEVICE
                    else if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VehicleDeviceScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withOpacity(0.2),
                      ),
                      image: DecorationImage(
                        image: AssetImage(feature.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            colorScheme.surface.withValues(alpha: 0.95),
                            colorScheme.surface.withValues(alpha: 0.65),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ================= TOP ROW =================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// FEATURE EXPLORED
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface.withOpacity(0.54),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  feature.exploredText,
                                  style: TextStyle(
                                    color: index == 1 || index == 3
                                        ? colorScheme.primary
                                        : Colors.green, // Keep green as status color
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                              /// ARROW BUTTON
                              Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface.withOpacity(0.45),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: colorScheme.onSurface,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          /// ================= TITLE =================
                          Text(
                            feature.title,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// ================= SUBTITLE =================
                          Text(
                            feature.subtitle,
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          /// ================= LOADING =================
          return Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}
