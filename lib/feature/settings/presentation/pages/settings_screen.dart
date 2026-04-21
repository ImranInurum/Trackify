import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/cubit/app_cubit.dart';
import '../../../../app/cubit/app_state.dart';
import '../../../../core/constants/app_languages.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../../auth/presentation/pages/signin_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.settings,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        surfaceTintColor: Colors.transparent,
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
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(filled: false,
                    hintText: l10n.searchForSettings,
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4), fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            _buildItem(
              context: context,
              icon: Icons.cloud_upload_outlined,
              title: l10n.backupAndRestore,
              subtitle: l10n.backupAndRestoreDesc,
              showArrow: true,
              onTap: () => debugPrint("Backup & Restore tapped"),
            ),
            _buildItem(
              context: context,
              icon: Icons.settings_outlined,
              title: l10n.appSettings,
              subtitle: l10n.appSettingsDesc,
              showArrow: true,
              onTap: () => debugPrint("App Settings tapped"),
            ),
            _buildItem(
              context: context,
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

                return Column(
                  children: [
                    _buildItem(
                      context: context,
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
                    ),
                    _buildItem(
                      context: context,
                      icon: Icons.language,
                      title: l10n.selectLanguage,
                      subtitle: AppLanguages.languages.firstWhere(
                            (lang) => lang['locale'] == state.locale,
                            orElse: () => AppLanguages.languages.first,
                          )['name'] as String,
                      showArrow: true,
                      onTap: () => _showLanguagePicker(context),
                    ),
                  ],
                );
              },
            ),
            _buildItem(
              context: context,
              icon: Icons.person_outline,
              title: l10n.privacy,
              subtitle: l10n.privacyDesc,
              showArrow: true,
              onTap: () => debugPrint("Privacy tapped"),
            ),
            _buildItem(
              context: context,
              icon: Icons.play_arrow_outlined,
              title: l10n.rateUsOnPlayStore,
              subtitle: l10n.rateUsOnPlayStoreDesc,
              showArrow: false,
              onTap: () => debugPrint("Rate us tapped"),
            ),
            _buildItem(
              context: context,
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

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      AppLocalizations.of(context)!.selectLanguage,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...AppLanguages.languages.map((lang) {
                    final isSelected = state.locale == lang['locale'];
                    return ListTile(
                      leading: Icon(
                        Icons.language,
                        color: isSelected ? Theme.of(context).colorScheme.primary : null,
                      ),
                      title: Text(
                        lang['name'] as String,
                        style: TextStyle(
                          color: isSelected ? Theme.of(context).colorScheme.primary : null,
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                          : null,
                      onTap: () {
                        context.read<AppCubit>().changeLocale(
                              lang['locale'] as Locale,
                              lang['key'] as String,
                            );
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool showArrow,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), size: 28),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 13, height: 1.3),
        ),
      ),
      trailing: showArrow
          ? Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3))
          : trailing,
      onTap: onTap,
    );
  }
}
