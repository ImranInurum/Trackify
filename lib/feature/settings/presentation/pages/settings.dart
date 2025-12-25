import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/widgets/custom_card.dart';

import '../../../../core/widgets/option_tile.dart';

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
        children: [_deviceDetails(), _settingOptions()],
      ),
    );
  }

  Widget _deviceDetails() {
    return CustomCard(
      innerPadding: 10,
      elevation: 1,
      child: Column(
        children: [
          OptionTile(
            leading: const Icon(Icons.pedal_bike, size: 32, color: Colors.green),
            title: "Yamaha MT-15",
            subtitle: "KA-05-AB-1234",
            showDivider: false,
            onTap: () => print("Bike details tapped"),
          ),
        ],
      ),
    );
  }

  Widget _settingOptions() {
    return CustomCard(
      innerPadding: 10,
      elevation: 1,
      child: Column(
        children: [
          OptionTile(
            leading: const Icon(Icons.garage_outlined, size: 28, color: Colors.blue),
            title: "My Garage",
            subtitle: "View and manage your vehicles",
            onTap: () => print("My Garage tapped"),
          ),
          OptionTile(
            leading: const Icon(Icons.settings, size: 28, color: Colors.orange),
            title: "Settings",
            subtitle: "Customize app preferences",
            onTap: () => print("Settings tapped"),
          ),
          BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              final themeMode = state.themeMode;
              final isDarkMode = themeMode == ThemeMode.dark;

              return OptionTile(
                leading: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 28,
                  color: isDarkMode ? Colors.amber : Colors.blueGrey,
                ),
                title: isDarkMode ? "Dark Mode" : "Light Theme",
                subtitle: "Switch between light and dark themes",
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    context.read<AppCubit>().changeTheme(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
                onTap: () {
                  context.read<AppCubit>().changeTheme(
                    isDarkMode ? ThemeMode.light : ThemeMode.dark,
                  );
                },
              );
            },
          ),

          OptionTile(
            leading: const Icon(Icons.help_outline, size: 28, color: Colors.purple),
            title: "Help & Support",
            subtitle: "Get assistance and FAQs",
            onTap: () => print("Help & Support tapped"),
          ),
          OptionTile(
            leading: const Icon(Icons.add_circle_outline, size: 28, color: Colors.teal),
            title: "Add More Vehicles",
            subtitle: "Connect another bike or car",
            onTap: () => print("Add More Vehicles tapped"),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
