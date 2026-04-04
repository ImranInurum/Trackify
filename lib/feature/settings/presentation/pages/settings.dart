import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/widgets/custom_card.dart';

import '../../../../core/utils/shared_preferences.dart';
import '../../../../core/widgets/option_tile.dart';
import '../../../auth/presentation/pages/signin_screen.dart';
import 'my_garage_screen.dart';
import 'product_screen.dart';

class SettingsPlaceholder extends StatefulWidget {
  const SettingsPlaceholder({super.key});

  @override
  State<SettingsPlaceholder> createState() => _SettingsPlaceholderState();
}

class _SettingsPlaceholderState extends State<SettingsPlaceholder> {
  @override
  void initState() {
    super.initState();
    context.read<AppCubit>().loadUserSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              final user = state.userData;
              return OptionTile(
                leading: const CircleAvatar(
                  minRadius: 45,
                  child: Text("I", style: TextStyle(fontSize: 12)),
                ),
                title: user?.name ?? "N/A",
                subtitle: user?.email ?? "N/A",
                extra: Text(
                  user?.role ?? "+91**********",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () => print("Account tapped"),
                showDivider: false,
              );
            },
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [_deviceDetails(), _settingOptions(), _logout()],
      ),
    );
  }

  Widget _deviceDetails() {
    return CustomCard(
      innerPadding: 10,
      elevation: 0.7,
      child: Column(
        children: [
          OptionTile(
            leading: Icon(
              Icons.local_taxi_sharp,
              size: 18,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            title: "Yamaha MT-15",
            subtitle: "KA-05-AB-1234",
            showDivider: false,
            onTap: () => print("Bike details tapped"),
          ),
          const SizedBox(height: 12),
          // Buy Device Card
          InkWell(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const ProductScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Secure your vehicle",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Buy device now for real-time tracking, anti-theft alerts, and more.",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          // Install Now Text
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const ProductScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RichText(
                text: TextSpan(
                  text: 'Bought a device ? ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: 'Install now',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingOptions() {
    return CustomCard(
      innerPadding: 10,
      elevation: 0.7,
      child: Column(
        children: [
          OptionTile(
            leading: Icon(
              Icons.garage_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            title: "My Garage",
            subtitle: "View and manage your vehicles",
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const MyGarageScreen()));
            },
          ),
          OptionTile(
            leading: Icon(
              Icons.settings,
              size: 18,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            title: "Settings",
            subtitle: "Customize app preferences",
            onTap: () => print("Settings tapped"),
          ),
          /*
          BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              final themeMode = state.themeMode;
              final isDarkMode = themeMode == ThemeMode.dark;

              return OptionTile(
                leading: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 18,
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
                title: isDarkMode ? "Dark Mode" : "Light Theme",
                subtitle: "Switch between light and dark themes",
                trailing: Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: isDarkMode,
                    activeThumbColor: isDarkMode
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.primaryContainer,
                    activeTrackColor:
                        Theme.of(context).colorScheme.primaryContainer,
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
*/
          OptionTile(
            leading: Icon(
              Icons.help_outline,
              size: 18,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            title: "Help & Support",
            subtitle: "Get assistance and FAQs",
            onTap: () => print("Help & Support tapped"),
          ),
          OptionTile(
            leading: Icon(
              Icons.add_circle_outline,
              size: 18,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            title: "Add More Vehicles",
            subtitle: "Connect another bike or car",
            onTap: () => print("Add More Vehicles tapped"),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _logout() {
    return CustomCard(
      innerPadding: 10,
      elevation: 0.7,
      child: Column(
        children: [
          OptionTile(
            leading: Icon(
              Icons.logout_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            title: "Log out",
            subtitle: "Logout from this device",
            showDivider: false,
            onTap: () {
              final prefs = AppPreference.instance;
              prefs.clearAll();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(isFromSignUp: false),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
