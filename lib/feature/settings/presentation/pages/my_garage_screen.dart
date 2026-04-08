import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../../add_vehicle_and_device/add_vehicle/presentation/cubit/vehicle_list_cubit.dart';
import '../../../add_vehicle_and_device/add_vehicle/presentation/cubit/vehicle_list_state.dart';

class MyGarageScreen extends StatefulWidget {
  const MyGarageScreen({super.key});

  @override
  State<MyGarageScreen> createState() => _MyGarageScreenState();
}

class _MyGarageScreenState extends State<MyGarageScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user vehicles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<VehicleListCubit>().fetchVehicles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myGarage),
        centerTitle: true,
      ),
      body: BlocBuilder<VehicleListCubit, VehicleListState>(
        builder: (context, state) {
          if (state is VehicleListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VehicleListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.errorMsg(state.message),
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<VehicleListCubit>().fetchVehicles(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          } else if (state is VehicleListLoaded) {
            final vehicles = state.vehicles;

            if (vehicles.isEmpty) {
              return Center(
                child: Text(l10n.noVehiclesInGarage),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    .withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                vehicle.vehicleType?.toLowerCase() == 'bike'
                                    ? Icons.two_wheeler
                                    : Icons.directions_car,
                                color: Theme.of(context).colorScheme.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${vehicle.vehicleMaker} ${vehicle.vehicleModel}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    vehicle.vehicleNumber ?? 'N/A',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Add more options here later like edit/delete
                              },
                              icon: const Icon(Icons.more_vert),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatusInfo(
                              context,
                              title: l10n.status,
                              value: l10n.active,
                              icon: Icons.check_circle,
                              color: Colors.green,
                            ),
                            _buildStatusInfo(
                              context,
                              title: "Fuel Type",
                              value: vehicle.fuelType ?? "N/A",
                              icon: Icons.local_gas_station,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: Text(l10n.initializeGarage));
        },
      ),
    );
  }

  Widget _buildStatusInfo(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
