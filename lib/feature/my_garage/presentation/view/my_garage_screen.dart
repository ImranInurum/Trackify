import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/device_data/presentation/pages/device_data_screen.dart';
import 'package:trackify/feature/device_warranty/pages/device_warranty_page.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_cubit.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_state.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';

import '../../../../core/common/widgets/vehicle_card.dart';
import '../../../Vehicle_control/presentation/pages/vehicle_control_screen.dart';
import '../../../Vehicle_control/data/repositories/vehicle_control_repository_impl.dart';

class MyGarageScreen extends StatefulWidget {
  const MyGarageScreen({super.key});

  @override
  State<MyGarageScreen> createState() => _MyGarageScreenState();
}

class _MyGarageScreenState extends State<MyGarageScreen> {
  final Map<String, bool> _vehicleLockStates = {};

  Future<void> _fetchLockStatus(String imei) async {
    if (imei.isEmpty || _vehicleLockStates.containsKey(imei)) return;
    try {
      final repo = VehicleControlRepositoryImpl();
      final controlDetails = await repo.getVehicleControlDetails(imei);
      if (mounted) {
        setState(() {
          _vehicleLockStates[imei] = controlDetails.vehicleLock;
        });
      }
    } catch (e) {
      debugPrint("Error fetching lock status in garage: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MyGarageCubit>().fetchVehicles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.myGarage,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<MyGarageCubit, MyGarageState>(
        builder: (context, state) {
          if (state is VehiclesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FetchVehicleError) {
            return _buildErrorState(l10n, state.message);
          }

          if (state is VehiclesLoaded) {
            final selectedImei = AppPreference.instance.getSync(
              key: AppPreference.IMEI,
            );
            final vehicles = List<Vehicle>.from(state.vehicles);

            if (selectedImei.isNotEmpty) {
              final selectedIndex = vehicles.indexWhere(
                (v) => v.imei == selectedImei,
              );
              if (selectedIndex > 0) {
                final selectedVehicle = vehicles.removeAt(selectedIndex);
                vehicles.insert(0, selectedVehicle);
              }
            }

            if (vehicles.isEmpty) {
              return Center(
                child: Text(
                  l10n.noVehiclesInGarage,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).cardColor,
              onRefresh: () => context.read<MyGarageCubit>().fetchVehicles(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  final bool hasDevice =
                      selectedImei.isNotEmpty && vehicle.imei == selectedImei;

                  if (hasDevice && vehicle.imei != null) {
                    _fetchLockStatus(vehicle.imei!);
                  }

                  final isLocked = _vehicleLockStates[vehicle.imei] ?? false;

                  return VehicleCard(
                    context: context,
                    vehicle: vehicle,
                    hasDevice: hasDevice,
                    isLocked: isLocked,
                    onVehicleControl: () async {
                      await AppPreference.instance.set(
                        key: AppPreference.IMEI,
                        value: vehicle.imei ?? '',
                      );
                      if (vehicle.id != null && vehicle.id!.isNotEmpty) {
                        await AppPreference.instance.set(
                          key: AppPreference.KEY_SELECTED_UID,
                          value: vehicle.id!,
                        );
                      }
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleControlScreen(
                              isFromGarage: hasDevice ? false : true,
                              passedVehicle: vehicle,
                            ),
                          ),
                        );
                      }
                    },
                    onLock: () => _handleVehicleLock(context, vehicle),
                    onRecharge: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeviceDataScreen(),
                        ),
                      );
                    },
                    onRenew: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WarrantyScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              l10n.errorMsg(message),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => context.read<MyGarageCubit>().fetchVehicles(),
              child: Text(
                l10n.retry,
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVehicleLock(BuildContext context, Vehicle vehicle) async {
    if (vehicle.imei == null || vehicle.imei!.isEmpty) return;

    final imei = vehicle.imei!;
    final currentLockState = _vehicleLockStates[imei] ?? false;
    final targetLockState = !currentLockState;

    try {
      final repo = VehicleControlRepositoryImpl();
      await repo.updateVehicleLock(imei, targetLockState);

      if (context.mounted) {
        setState(() {
          _vehicleLockStates[imei] = targetLockState;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Vehicle ${targetLockState ? 'Locked' : 'Unlocked'} successfully!",
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update lock status: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
