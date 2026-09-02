import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/config/font_manager.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../map/data/entity/user_vehicles.dart';

class EmergencyAlertScreen extends StatefulWidget {
  final Vehicles? selectedDevice;
  const EmergencyAlertScreen({super.key, this.selectedDevice});

  @override
  State<EmergencyAlertScreen> createState() => _EmergencyAlertScreenState();
}

class _EmergencyAlertScreenState extends State<EmergencyAlertScreen> {
  List<Map<String, String>> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmergencyContacts();
  }

  Future<void> _loadEmergencyContacts() async {
    final vehicle = widget.selectedDevice;
    if (vehicle != null) {
      final keyId = vehicle.id.isNotEmpty
          ? vehicle.id
          : (vehicle.vehicleNumber.isNotEmpty
              ? vehicle.vehicleNumber
              : 'default');

      final raw = await AppPreference.instance.get(
        key: "emergency_contacts_$keyId",
      );

      if (raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw) as List;
          _contacts = decoded
              .map((item) => Map<String, String>.from(item))
              .toList();
        } catch (e) {
          debugPrint("Error parsing emergency contacts: $e");
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'\s+'), ''),
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch phone dialer for $phoneNumber')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch phone dialer for $phoneNumber')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.emergency),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildContactCard(
                  name: 'National Emergency',
                  number: '112',
                  colorScheme: colorScheme,
                  isPrimary: true,
                ),
                const SizedBox(height: 24),
                if (_contacts.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      l10n.emergencyContacts,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeightManager.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  ..._contacts.map((contact) {
                    final name = contact['name'] ?? 'Unknown';
                    final phone = contact['phone'] ?? contact['mobileNumber'] ?? '';
                    if (phone.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildContactCard(
                        name: name,
                        number: phone,
                        colorScheme: colorScheme,
                        isPrimary: false,
                      ),
                    );
                  }),
                ],
              ],
            ),
    );
  }

  Widget _buildContactCard({
    required String name,
    required String number,
    required ColorScheme colorScheme,
    required bool isPrimary,
  }) {
    return Material(
      color: isPrimary
          ? colorScheme.error.withOpacity( 0.05)
          : colorScheme.surfaceVariant.withOpacity( 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isPrimary ? colorScheme.error.withOpacity( 0.5) : colorScheme.outlineVariant.withOpacity( 0.5),
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isPrimary
                ? colorScheme.error.withOpacity( 0.15)
                : colorScheme.primary.withOpacity( 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.local_phone_rounded,
            color: isPrimary ? colorScheme.error : colorScheme.primary,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeightManager.bold,
            color: colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            number,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeightManager.semibold,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isPrimary ? colorScheme.error : colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.call,
            color: Colors.white,
            size: 20,
          ),
        ),
        onTap: () => _makePhoneCall(number),
      ),
    );
  }
}