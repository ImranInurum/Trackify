import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/app_navigation.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../data/repositories/vehicle_control_repository_impl.dart';
import '../cubit/vehicle_control_cubit.dart';
import '../state/vehicle_control_state.dart';
import '../widgets/metric_card.dart';
import '../widgets/lock_card.dart';
import '../widgets/vehicle_on_map_card.dart';
import '../widgets/journey_card.dart';
import '../widgets/documents_card.dart';
import 'notification_controls_screen.dart';


class VehicleControlScreen extends StatelessWidget {
  const VehicleControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleControlCubit(VehicleControlRepositoryImpl())..loadVehicleDetails("1"),
      child: const VehicleControlView(),
    );
  }
}

class VehicleControlView extends StatelessWidget {
  const VehicleControlView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    final bgColor = isDark ? const Color(0xFF0C0C0C) : theme.scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : theme.cardColor;
    final primaryTextColor = theme.colorScheme.onSurface;
    final secondaryTextColor = theme.colorScheme.onSurface.withOpacity(0.6);

    return Scaffold(
      backgroundColor: bgColor,
      body: BlocBuilder<VehicleControlCubit, VehicleControlState>(
        builder: (context, state) {
          if (state is VehicleControlLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VehicleControlError) {
            return Center(child: Text(state.message, style: TextStyle(color: theme.colorScheme.error)));
          }
          if (state is VehicleControlLoaded) {
            final vehicle = state.vehicle;
            return SingleChildScrollView(
              child: Column(
                children: [
                  /// 🔹 TOP IMAGE SECTION
                  Stack(
                    children: [
                      Container(
                        height: size.height * 0.45,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.bikeImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.6, 0.9, 1.0],
                              colors: [
                                Colors.transparent,
                                bgColor.withOpacity(0.8),
                                bgColor,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface.withOpacity(0.5), size: 24),
                        ),
                      ),
                      Positioned(
                        bottom: size.height * 0.1,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Icon(Icons.camera_alt_outlined, color: theme.colorScheme.onSurface, size: 28),
                        ),
                      ),
                    ],
                  ),

                  /// 🔹 VEHICLE DETAILS
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      children: [
                        Text(
                          vehicle.vehicleName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: primaryTextColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${vehicle.vehicleNumber} | ${vehicle.fuelType}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade600,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, color: Colors.black, size: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 TANK & MILEAGE CARDS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            value: vehicle.tankCapacity,
                            unit: "L",
                            label: l10n.tankCapacity,
                            cardColor: cardColor,
                            onEdit: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MetricCard(
                            value: vehicle.vehicleMileage,
                            unit: "Km/L",
                            label: "Vehicle Mileage",
                            cardColor: cardColor,
                            onEdit: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 LOCK & UNLOCK VEHICLE CARD
                  LockCard(
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    onLock: () {},
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 VEHICLE ON MAP CARD
                  VehicleOnMapCard(
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    accentColor: const Color(0xFFD6B57B),
                    selectedIcon: state.tempIcon,
                    selectedColor: state.tempColor,
                    onIconChanged: (icon) {
                      context.read<VehicleControlCubit>().updateLocalIcon(icon);
                    },
                    onColorChanged: (color) {
                      context.read<VehicleControlCubit>().updateLocalColor(color);
                    },
                    onSave: () {
                      context.read<VehicleControlCubit>().saveChanges(vehicle.id);
                    },
                    showSaveButton: state.tempIcon != vehicle.selectedIcon || state.tempColor != vehicle.selectedColor,
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 JOURNEY CARD
                  JourneyCard(
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      AppNavigation.setIndex(2);
                    },
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 DOCUMENTS CARD
                  DocumentsCard(
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                  ),

                  const SizedBox(height: 20),

                  Divider(height: 1, color: theme.colorScheme.onSurface.withOpacity(0.15)),

                  /// 🔹 NOTIFICATION CONTROLS
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationControlsScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Row(
                        children: [
                          Icon(Icons.settings_outlined, color: secondaryTextColor, size: 28),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Notification controls",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: primaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Change your notification preferences",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: secondaryTextColor, size: 16),
                        ],
                      ),
                    ),
                  ),

                  Divider(height: 1, color: theme.colorScheme.onSurface.withOpacity(0.15)),
                  const SizedBox(height: 32),

                  /// 🔹 UNMAP SECTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Unmap your Ajjas",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Step 1: To un-map device, call at +918061971443",
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Step 2: Remove vehicle",
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
