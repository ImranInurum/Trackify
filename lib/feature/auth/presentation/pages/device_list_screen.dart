import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';

import '../../../../app/app_navigation.dart';
import '../../../map/presentation/cubit/map_cubit.dart';
import '../../../map/presentation/cubit/map_state.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch devices on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MapCubit>().fetchDevices({});
      }
    });
  }

  void _onDeviceSelected(String deviceName, String deviceMac) async {
    final prefs = AppPreference.instance;
    await prefs.set(key: AppPreference.KEY_DEVICE_NAME, value: deviceName);
    await prefs.set(key: AppPreference.KEY_DEVICE_MAC, value: deviceMac);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AppNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Device'),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No devices found.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const AppNavigation()),
                        );
                      },
                      child: const Text('Proceed'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    leading: const Icon(
                      Icons.devices,
                      size: 32,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      device.deviceName ?? 'Unknown Device',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text('IMEI: ${device.imei ?? 'N/A'}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _onDeviceSelected(
                        device.deviceName ?? 'Unknown Device',
                        device.imei ?? '',
                      );
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Initialize to fetch devices.'));
        },
      ),
    );
  }
}
