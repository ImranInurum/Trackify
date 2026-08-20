import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trackify/feature/settings/presentation/pages/notification_settings.dart';
import 'package:trackify/feature/settings/presentation/pages/privacy_screen.dart';
import 'package:trackify/feature/settings/presentation/widgets/setting_list_tile.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/cubit/app_cubit.dart';
import '../../../../app/cubit/app_state.dart';
import '../../../../core/constants/app_languages.dart';
import 'package:trackify/core/widgets/logout_confirmation_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = 'v${info.version}';
      });
    } catch (e) {
      debugPrint('Failed to load app version: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isVisible(String title) {
    if (_searchQuery.isEmpty) return true;
    return title.toLowerCase().contains(_searchQuery.toLowerCase());
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
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.settings,
          style: TextStyle(
            fontSize: 20.0,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
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
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    hintText: l10n.searchForSettings,
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // if (_isVisible(l10n.backupAndRestore))
            //   SettingListTile(
            //     icon: Icons.cloud_upload_outlined,
            //     title: l10n.backupAndRestore,
            //     subtitle: l10n.backupAndRestoreDesc,
            //     showArrow: true,
            //     showIcon: true,
            //     onTap: () => debugPrint("Backup & Restore tapped"),
            //   ),
            // if (_isVisible(l10n.appSettings))
            //   SettingListTile(
            //     icon: Icons.settings_outlined,
            //     title: l10n.appSettings,
            //     subtitle: l10n.appSettingsDesc,
            //     showArrow: true,
            //     showIcon: true,
            //     onTap: () => debugPrint("App Settings tapped"),
            //   ),
            if (_isVisible(l10n.notificationSettings))
              SettingListTile(
                icon: Icons.notifications_none_outlined,
                title: l10n.notificationSettings,
                subtitle: l10n.notificationSettingsDesc,
                showArrow: true,
                showIcon: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationSettings(),
                  ),
                ),
              ),

            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                final themeMode = state.themeMode;
                final isDarkMode = themeMode == ThemeMode.dark;
                final themeTitle = isDarkMode ? l10n.darkMode : l10n.lightTheme;
                final langTitle = l10n.selectLanguage;

                return Column(
                  children: [
                    if (_isVisible(themeTitle))
                      SettingListTile(
                        icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        title: themeTitle,
                        subtitle: l10n.switchBetweenLightAndDarkThemes,
                        showArrow: false,
                        showIcon: true,
                        trailing: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: isDarkMode,
                            activeColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            activeTrackColor: Theme.of(
                              context,
                            ).colorScheme.tertiary,
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
                    if (_isVisible(langTitle))
                      SettingListTile(
                        icon: Icons.language,
                        title: langTitle,
                        subtitle:
                            AppLanguages.languages.firstWhere(
                                  (lang) => lang['locale'] == state.locale,
                                  orElse: () => AppLanguages.languages.first,
                                )['name']
                                as String,
                        showArrow: true,
                        showIcon: true,
                        onTap: () => _showLanguagePicker(context),
                      ),
                  ],
                );
              },
            ),

            if (_isVisible(l10n.privacy))
              SettingListTile(
                icon: Icons.person_outline,
                title: l10n.privacy,
                subtitle: l10n.privacyDesc,
                showArrow: true,
                showIcon: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyScreen(),
                    ),
                  );
                },
              ),

            /*
            if (_isVisible('Manage Access'))
              SettingListTile(
                icon: Icons.manage_accounts_outlined,
                title: 'Manage Access',
                subtitle: 'Share your vehicle access with others',
                showArrow: true,
                showIcon: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageAccessScreen(),
                    ),
                  );
                },
              ),
*/
            if (_isVisible(l10n.rateUsOnPlayStore))
              SettingListTile(
                icon: Icons.play_arrow_outlined,
                title: l10n.rateUsOnPlayStore,
                subtitle: l10n.rateUsOnPlayStoreDesc,
                showArrow: false,
                showIcon: true,
                onTap: () async {
                  final url = Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.trackify.mytrackmate.trackify',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not open the Play Store'),
                        ),
                      );
                    }
                  }
                },
              ),

            if (_isVisible(l10n.logout))
              SettingListTile(
                icon: Icons.logout_outlined,
                title: l10n.logout,
                subtitle: l10n.logoutDesc,
                showArrow: false,
                showIcon: true,
                onTap: () => LogoutConfirmationDialog.show(context),
              ),

            if (_appVersion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Text(
                  'App Version $_appVersion',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
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
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      title: Text(
                        lang['name'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        context.read<AppCubit>().changeLocale(
                          lang['locale'] as Locale,
                          lang['key'] as String,
                        );
                        Navigator.pop(context);
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
