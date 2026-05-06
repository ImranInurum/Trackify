import 'package:flutter/material.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/feature/service_logs/presentation/widgets/vehicle_selection_app_bar.dart';
import 'package:trackify/l10n/app_localizations.dart';

class NotificationControlsScreen extends StatefulWidget {
  const NotificationControlsScreen({super.key});

  @override
  State<NotificationControlsScreen> createState() => _NotificationControlsScreenState();
}

class _NotificationControlsScreenState extends State<NotificationControlsScreen> {
  // Mock data for demonstration
  final List<Vehicle> _vehicles = [
    Vehicle(id: "1", vehicleMaker: "Honda", vehicleModel: "SP 125", vehicleNumber: "MP09QV8269"),
    Vehicle(id: "2", vehicleMaker: "Bajaj", vehicleModel: "Pulsar 150", vehicleNumber: "MP09QV1234"),
  ];
  
  late Vehicle _selectedVehicle;
  
  bool _ignitionNotification = true;
  bool _motionNotification = true;
  bool _powerSupplyNotification = true;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = _vehicles.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          /// 🔹 SHARED VEHICLE SELECTION APP BAR
          VehicleSelectionAppBar(
            title: l10n.notificationControlsTitle,
            selectedVehicle: _selectedVehicle,
            vehicles: _vehicles,
            onBack: () => Navigator.pop(context),
            onVehicleSelected: (vehicle) {
              setState(() {
                _selectedVehicle = vehicle;
              });
            },
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  /// 🔹 NOTIFICATION SECTIONS
                  _buildNotificationSection(
                    context,
                    title: l10n.ignitionOnOffTitle,
                    subtitle: l10n.ignitionOnOffDesc,
                    value: _ignitionNotification,
                    onChanged: (val) => setState(() => _ignitionNotification = val!),
                  ),
                  
                  _buildDivider(theme),

                  _buildNotificationSection(
                    context,
                    title: l10n.motionWithIgnitionOffTitle,
                    subtitle: l10n.motionWithIgnitionOffDesc,
                    value: _motionNotification,
                    onChanged: (val) => setState(() => _motionNotification = val!),
                  ),

                  _buildDivider(theme),

                  _buildNotificationSection(
                    context,
                    title: l10n.powerSupplyOffTitle,
                    subtitle: l10n.powerSupplyOffDesc,
                    value: _powerSupplyNotification,
                    onChanged: (val) => setState(() => _powerSupplyNotification = val!),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.app_registration_rounded, color: onSurfaceVariant, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.appNotification,
                  style: TextStyle(
                    fontSize: 16,
                    color: onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Theme(
                data: theme.copyWith(
                  unselectedWidgetColor: onSurfaceVariant.withOpacity(0.5),
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
        color: theme.colorScheme.onSurface.withOpacity(0.15),
      ),
    );
  }
}
