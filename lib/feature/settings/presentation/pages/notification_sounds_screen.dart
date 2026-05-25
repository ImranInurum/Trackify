import 'package:flutter/material.dart';
import 'package:trackify/feature/settings/presentation/widgets/setting_list_tile.dart';
import 'package:trackify/l10n/app_localizations.dart';

class NotificationSoundsScreen extends StatelessWidget {
  const NotificationSoundsScreen({Key? key}) : super(key: key);

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
            title: l10n.vibrationAlert,
            showArrow: false,
            showIcon: false, 
            isSubtitle: false,
            onTap: (){
              
            }
          ),

          Divider(),

          SettingListTile(
            icon: Icons.settings_rounded,
            title: l10n.motionAlert,
            showArrow: false,
            showIcon: false, 
            isSubtitle: false,
            onTap: (){
            }
          ),

          Divider(),

          SettingListTile(
            icon: Icons.settings_rounded,
            title: l10n.ignitionAlert,
            showArrow: false,
            showIcon: false, 
            isSubtitle: false,
            onTap: (){
            }
          ),

          Divider(),

          SettingListTile(
            icon: Icons.settings_rounded,
            title: l10n.fallAlert,
            showArrow: false,
            showIcon: false, 
            isSubtitle: false,
            onTap: (){
            }
          ),

          Divider(),

          SettingListTile(
            icon: Icons.settings_rounded,
            title: l10n.batteryAlert,
            showArrow: false,
            showIcon: false, 
            isSubtitle: false,
            onTap: (){
            }
          ),

          Divider(),

          SettingListTile(
            icon: Icons.settings_rounded,
            title: l10n.geofenceAlert,
            showArrow: false,
            showIcon: false, 
            isSubtitle: false,
            onTap: (){
            }
          ),

          Divider(),

          SettingListTile(
            icon: Icons.settings_rounded,
            title: l10n.speedAlert,
            showArrow: false,
            showIcon: false,
            isSubtitle: false, 
            onTap: (){
            }
          ),

          Divider(),

          SettingListTile(
            icon: Icons.settings_rounded,
            title: l10n.otherAlert,
            showArrow: false,
            showIcon: false, 
            isSubtitle: false,
            onTap: (){
            }
          ),

          Divider(),

          SettingListTile(
            icon: Icons.settings_rounded,
            title: l10n.customNotification,
            showArrow: false,
            showIcon: false, 
            isSubtitle: false,
            onTap: (){
            }
          ),

        ],
      ),
    );
  }
}