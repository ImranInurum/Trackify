import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:trackify/feature/settings/presentation/pages/notification_sounds_screen.dart';
import 'package:trackify/feature/settings/presentation/widgets/setting_list_tile.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../../Vehicle_control/presentation/pages/notification_controls_screen.dart';

class NotificationSettings extends StatelessWidget{

  const NotificationSettings({super.key});

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
      body: Column(
        children: [

          SizedBox(height: 10),

          SettingListTile(
            icon: Icons.settings_rounded,
            title: l10n.notificationControlsTitle,
            subtitle: l10n.changeNotificationPreferences,
            showArrow: true,
            showIcon: true,
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationControlsScreen()),
              );
            }
          ),

          SettingListTile(
            icon: Icons.volume_down_rounded,
            title: l10n.notificationSounds,
            subtitle: l10n.changeSoundForNotification,
            showArrow: true,
            showIcon: true,
            onTap: () {
              debugPrint('Tapped on Notification Sounds');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationSoundsScreen()),
              );
            }
          ),

        ],
      ),
    );
  }
}