import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/cubit/app_cubit.dart';
import '../../../../app/cubit/app_state.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../../auth/presentation/pages/signin_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.settings,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchForSettings,
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            _buildItem(
              icon: Icons.cloud_upload_outlined,
              title: l10n.backupAndRestore,
              subtitle: l10n.backupAndRestoreDesc,
              showArrow: true,
              onTap: () => debugPrint("Backup & Restore tapped"),
            ),
            _buildItem(
              icon: Icons.settings_outlined,
              title: l10n.appSettings,
              subtitle: l10n.appSettingsDesc,
              showArrow: true,
              onTap: () => debugPrint("App Settings tapped"),
            ),
            _buildItem(
              icon: Icons.notifications_none_outlined,
              title: l10n.notificationSettings,
              subtitle: l10n.notificationSettingsDesc,
              showArrow: true,
              onTap: () => debugPrint("Notification Settings tapped"),
            ),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                final themeMode = state.themeMode;
                final isDarkMode = themeMode == ThemeMode.dark;

                return _buildItem(
                  icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  title: isDarkMode ? "Dark Mode" : "Light Theme",
                  subtitle: "Switch between light and dark themes",
                  showArrow: false,

                  trailing: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: isDarkMode,
                      activeThumbColor: Theme.of(context).colorScheme.surface,
                      activeTrackColor: Theme.of(context).colorScheme.tertiary,
                      onChanged: (value) {
                        context.read<AppCubit>().changeTheme(
                          value ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    ),
                  ),

                  onTap: () {
                    context.read<AppCubit>().changeTheme(
                      isDarkMode ? ThemeMode.light : ThemeMode.dark,
                    );
                  },
                );
              },
            ),
            _buildItem(
              icon: Icons.person_outline,
              title: l10n.privacy,
              subtitle: l10n.privacyDesc,
              showArrow: true,
              onTap: () => debugPrint("Privacy tapped"),
            ),
            _buildItem(
              icon: Icons.play_arrow_outlined,
              title: l10n.rateUsOnPlayStore,
              subtitle: l10n.rateUsOnPlayStoreDesc,
              showArrow: false,
              onTap: () => debugPrint("Rate us tapped"),
            ),
            _buildItem(
              icon: Icons.logout_outlined,
              title: l10n.logout,
              subtitle: l10n.logoutDesc,
              showArrow: false,
              onTap: () {
                final prefs = AppPreference.instance;
                prefs.clearAll();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool showArrow,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Icon(icon, color: Colors.grey.shade700, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.black87
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.3),
        ),
      ),
      trailing: showArrow
          ? Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400)
          : trailing,
      onTap: onTap,
    );
  }
}
