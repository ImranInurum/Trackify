import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_cubit.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_state.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../widgets/vehicle_card.dart';

class MyGarageScreen extends StatefulWidget {
  const MyGarageScreen({super.key});

  @override
  State<MyGarageScreen> createState() => _MyGarageScreenState();
}

class _MyGarageScreenState extends State<MyGarageScreen> {
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
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.myGarage,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
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
            final vehicles = state.vehicles;

            if (vehicles.isEmpty) {
              return Center(
                child: Text(
                  l10n.noVehiclesInGarage,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<MyGarageCubit>().fetchVehicles(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  // TODO: Use real device check once available in Vehicle model
                  // Example: final bool hasDevice = vehicle.deviceId != null;
                  final bool hasDevice = index == 0;

                  return VehicleCard(
                    vehicle: vehicle,
                    hasDevice: hasDevice,
                    onLock: () => _handleVehicleLock(context, vehicle),
                    onRecharge: () => _handleRecharge(context, vehicle),
                    onRenew: () => _handleRenew(context, vehicle),
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
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => context.read<MyGarageCubit>().fetchVehicles(),
              child: Text(l10n.retry, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVehicleLock(BuildContext context, dynamic vehicle) {
    // TODO: Implement vehicle lock API call via Cubit
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Locking vehicle ${vehicle.vehicleNumber}...")),
    );
  }

  void _handleRecharge(BuildContext context, dynamic vehicle) {
    // TODO: Navigate to Payment/Recharge flow
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Opening Recharge Flow...")));
  }

  void _handleRenew(BuildContext context, dynamic vehicle) {
    // TODO: Navigate to Warranty Renewal flow
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Opening Warranty Renewal...")));
  }
}
