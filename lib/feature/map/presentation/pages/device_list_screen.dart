import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';

import '../../../../app/app_navigation.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';

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
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => const AppNavigation()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectDevice), centerTitle: true),
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
                    l10n.errorMsg(state.message),
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<MapCubit>().fetchDevices({}),
                    child: Text(l10n.retry),
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
                    Text(l10n.noDevicesFound),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const AppNavigation()),
                        );
                      },
                      child: Text(l10n.proceed),
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
                      device.deviceName ?? l10n.unknownDevice,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(l10n.imeiLabel(device.imei ?? 'N/A')),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _onDeviceSelected(
                        device.deviceName ?? l10n.unknownDevice,
                        device.imei ?? '',
                      );
                    },
                  ),
                );
              },
            );
          }

          return Center(child: Text(l10n.initializeFetch));
        },
      ),
    );
  }
}
