import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_settings/app_settings.dart';
import 'package:trackify/feature/settings/presentation/widgets/setting_list_tile.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';

const _channel = MethodChannel('com.trackify.mytrackmate.trackify/notifications');

void _openChannel(String channelId) async {
  try {
    await _channel.invokeMethod('openNotificationChannelSettings', {'channelId': channelId});
  } catch (e) {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }
}

class NotificationSoundsScreen extends StatefulWidget {
  const NotificationSoundsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSoundsScreen> createState() => _NotificationSoundsScreenState();
}

class _NotificationSoundsScreenState extends State<NotificationSoundsScreen> {
  List<dynamic> _alertTypes = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchAlertTypes();
  }

  Future<void> _fetchAlertTypes() async {
    try {
      final networkService = NetworkApiService();
      final response = await networkService.getGetApiResponse(ApiURL.alertTypes);
      response.fold(
        (l) {
          setState(() {
            _error = l.toString();
            _isLoading = false;
          });
        },
        (r) {
          if (r != null && r['status'] == true && r['data'] != null) {
            setState(() {
              _alertTypes = r['data'];
              _alertTypes = _alertTypes.where((alert) => alert['isActive'] == true).toList();
              _isLoading = false;
            });
          } else {
            setState(() {
              _error = "Failed to load alert types";
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _error = "An error occurred";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.notificationSettings,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _error.isNotEmpty
          ? Center(child: Text(_error, style: TextStyle(color: Colors.red)))
          : ListView.separated(
              padding: const EdgeInsets.only(top: 10),
              itemCount: _alertTypes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final alert = _alertTypes[index];
                
                String title = alert['label'] ?? 'Unknown Alert';
                final String type = alert['type']?.toString().toLowerCase() ?? '';
                if (type == 'vibration') title = l10n.vibrationAlert;
                else if (type == 'motion') title = l10n.motionAlert;
                else if (type == 'ignition') title = l10n.ignitionAlert;
                else if (type == 'fall') title = l10n.fallAlert;
                else if (type == 'battery') title = l10n.batteryAlert;
                else if (type == 'geofence') title = l10n.geofenceAlert;
                else if (type == 'speed') title = l10n.speedAlert;
                else if (type == 'other') title = l10n.otherAlert;
                else if (type == 'custom') title = l10n.customNotification;
                
                return SettingListTile(
                  icon: Icons.settings_rounded,
                  title: title,
                  showArrow: false,
                  showIcon: false,
                  isSubtitle: false,
                  onTap: () {
                    final channelId = alert['androidChannelId'];
                    if (channelId != null && channelId.isNotEmpty) {
                      _openChannel(channelId);
                    }
                  },
                );
              },
            ),
    );
  }
}