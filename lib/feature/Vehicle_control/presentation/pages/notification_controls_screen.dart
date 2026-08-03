import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/feature/service_logs/presentation/widgets/vehicle_selection_app_bar.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_cubit.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_state.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';

class NotificationControlsScreen extends StatefulWidget {
  final String? passedImei;
  const NotificationControlsScreen({super.key, this.passedImei});

  @override
  State<NotificationControlsScreen> createState() => _NotificationControlsScreenState();
}

class _NotificationControlsScreenState extends State<NotificationControlsScreen> {
  bool _ignitionNotification = true;
  bool _motionNotification = true;
  bool _powerSupplyNotification = true;
  bool _isLoadingControls = false;
  String? _lastFetchedImei;

  @override
  void initState() {
    super.initState();
    context.read<ServiceLogsCubit>().loadVehicles();
  }

  Future<void> _fetchNotificationControls(String imei) async {
    if (imei.isEmpty || _lastFetchedImei == imei) return;
    _lastFetchedImei = imei;

    if (mounted) {
      setState(() {
        _isLoadingControls = true;
      });
    }

    final url = ApiURL.notificationControl(imei);
    final apiService = NetworkApiService();
    final result = await apiService.getGetApiResponse(url);

    result.fold(
      (failure) {
        debugPrint("Error fetching notification controls: ${failure.message}");
        if (mounted) {
          setState(() {
            _isLoadingControls = false;
          });
        }
      },
      (response) {
        try {
          Map<String, dynamic>? dataMap;
          if (response is Map<String, dynamic>) {
            final data = response['data'];
            if (data is Map<String, dynamic>) {
              dataMap = data;
            } else if (response['success'] == true && response['data'] != null) {
              dataMap = Map<String, dynamic>.from(response['data']);
            } else {
              dataMap = response;
            }
          }

          if (dataMap != null && mounted) {
            setState(() {
              _ignitionNotification = dataMap!['ignition'] == true;
              _motionNotification = dataMap!['motionWithIgnitionOff'] == true;
              _powerSupplyNotification = dataMap!['powerSupply'] == true;
              _isLoadingControls = false;
            });
          } else if (mounted) {
            setState(() {
              _isLoadingControls = false;
            });
          }
        } catch (e) {
          debugPrint("Error parsing notification controls: $e");
          if (mounted) {
            setState(() {
              _isLoadingControls = false;
            });
          }
        }
      },
    );
  }

  Future<void> _updateNotificationControls(String imei) async {
    final url = ApiURL.updateNotificationControl;
    final apiService = NetworkApiService();
    final body = {
      "imei": imei,
      "ignition": _ignitionNotification,
      "motionWithIgnitionOff": _motionNotification,
      "powerSupply": _powerSupplyNotification,
    };
    final result = await apiService.getPostApiResponse(url, body);
    result.fold(
      (failure) {
        debugPrint("Error updating notification controls: ${failure.message}");
      },
      (data) {
        debugPrint("Notification controls updated successfully");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<ServiceLogsCubit, ServiceLogsState>(
        builder: (context, state) {
          if (state is! ServiceLogsLoaded && state is! ServiceLogsSubmitting) {
            return Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Expanded(
                  child: const Center(child: TrackifyLoader()),
                ),
              ],
            );
          }

          final currentState = state is ServiceLogsLoaded
              ? state
              : (context.read<ServiceLogsCubit>().state as ServiceLogsLoaded);

          final selectedVehicle = currentState.selectedVehicle;
          final selectedImei = selectedVehicle?.imei;
          final currentImei = (selectedImei != null && selectedImei.trim().isNotEmpty)
              ? selectedImei.trim()
              : (widget.passedImei ?? '');

          if (currentImei.isNotEmpty && _lastFetchedImei != currentImei) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _fetchNotificationControls(currentImei);
            });
          }

          final hasDevice = currentImei.isNotEmpty;

          return Column(
            children: [
              /// 🔹 SHARED VEHICLE SELECTION APP BAR
              VehicleSelectionAppBar(
                title: l10n.notificationControlsTitle,
                selectedVehicle: currentState.selectedVehicle,
                vehicles: currentState.vehicles,
                requireDevice: true,
                onBack: () => Navigator.pop(context),
                onVehicleSelected: (vehicle) {
                  final vHasDevice = vehicle.imei != null &&
                      vehicle.imei!.trim().isNotEmpty;
                  if (!vHasDevice) {
                    showDeviceNotInstalledDialog(context, vehicle);
                    return;
                  }
                  context.read<ServiceLogsCubit>().selectVehicle(vehicle.id ?? "");
                },
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      if (!hasDevice)
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.sensors_off_rounded,
                                  color: Colors.orange,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Device Not Installed",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "No tracking device linked with this vehicle. Notification controls are disabled.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      /// 🔹 NOTIFICATION SECTIONS
                      _buildNotificationSection(
                        context,
                        title: l10n.ignitionOnOffTitle,
                        subtitle: l10n.ignitionOnOffDesc,
                        value: hasDevice ? _ignitionNotification : false,
                        onChanged: (val) {
                          if (!hasDevice && selectedVehicle != null) {
                            showDeviceNotInstalledDialog(context, selectedVehicle);
                            return;
                          }
                          setState(() => _ignitionNotification = val!);
                          if (currentImei.isNotEmpty) {
                            _updateNotificationControls(currentImei);
                          }
                        },
                      ),
                      
                      _buildDivider(theme),

                      _buildNotificationSection(
                        context,
                        title: l10n.motionWithIgnitionOffTitle,
                        subtitle: l10n.motionWithIgnitionOffDesc,
                        value: hasDevice ? _motionNotification : false,
                        onChanged: (val) {
                          if (!hasDevice && selectedVehicle != null) {
                            showDeviceNotInstalledDialog(context, selectedVehicle);
                            return;
                          }
                          setState(() => _motionNotification = val!);
                          if (currentImei.isNotEmpty) {
                            _updateNotificationControls(currentImei);
                          }
                        },
                      ),

                      _buildDivider(theme),

                      _buildNotificationSection(
                        context,
                        title: l10n.powerSupplyOffTitle,
                        subtitle: l10n.powerSupplyOffDesc,
                        value: hasDevice ? _powerSupplyNotification : false,
                        onChanged: (val) {
                          if (!hasDevice && selectedVehicle != null) {
                            showDeviceNotInstalledDialog(context, selectedVehicle);
                            return;
                          }
                          setState(() => _powerSupplyNotification = val!);
                          if (currentImei.isNotEmpty) {
                            _updateNotificationControls(currentImei);
                          }
                        },
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: onSurface.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.app_registration_rounded, color: onSurfaceVariant, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.appNotification,
                  style: TextStyle(
                    fontSize: 14,
                    color: onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Theme(
                data: theme.copyWith(
                  unselectedWidgetColor: onSurfaceVariant.withValues(alpha: 0.5),
                ),
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                  activeColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(
        height: 1,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
      ),
    );
  }
}
