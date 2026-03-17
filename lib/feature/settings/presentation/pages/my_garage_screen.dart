import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../map/presentation/cubit/map_cubit.dart';
import '../../../map/presentation/cubit/map_state.dart';

class MyGarageScreen extends StatefulWidget {
  const MyGarageScreen({super.key});

  @override
  State<MyGarageScreen> createState() => _MyGarageScreenState();
}

class _MyGarageScreenState extends State<MyGarageScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user devices
    context.read<MapCubit>().fetchDevices({});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Garage'),
        centerTitle: true,
      ),
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MapError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<MapCubit>().fetchDevices({}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is MapLoaded) {
            final devices = state.deviceList.devices ?? [];

            if (devices.isEmpty) {
              return const Center(
                child: Text('No vehicles found in your garage.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
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
                                Icons.directions_car,
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
                                    device.deviceName ?? 'Unknown Vehicle',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'IMEI: ${device.imei ?? 'N/A'}',
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
                              title: 'Status',
                              value: 'Active',
                              icon: Icons.check_circle,
                              color: Colors.green,
                            ),
                            _buildStatusInfo(
                              context,
                              title: 'Subscription',
                              value: 'Pro Plan',
                              icon: Icons.star,
                              color: Colors.amber,
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

          return const Center(child: Text('Initialize to fetch your garage.'));
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
