import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/widgets/custom_card.dart';
import 'package:trackify/core/widgets/swipe_to_lock.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/help_support_screen.dart';
import 'package:trackify/feature/my_garage/presentation/view/my_garage_screen.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_state.dart';
import 'package:trackify/feature/settings/presentation/pages/settings_screen.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../../../core/utils/shared_preferences.dart';
import '../../../../core/widgets/option_tile.dart';
import '../../../auth/presentation/pages/signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AppCubit>().loadUserSession();
    context.read<ProfileCubit>().fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.blue),
            onPressed: () => debugPrint("Notifications tapped"),
          ),
        ],
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, appState) {
          final user = appState.userData;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileHeader(user),
                  const SizedBox(height: 24),
                  _upgradeButton(l10n),
                  const SizedBox(height: 24),
                  _progressSection(l10n),
                  const SizedBox(height: 24),
                  _vehicleSection(l10n),
                  const SizedBox(height: 24),
                  _menuOptions(l10n),
                  const SizedBox(height: 32),
                  _logoutButton(l10n),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _profileHeader(user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue.shade400,
          child: Text(
            user?.name?.substring(0, 1).toUpperCase() ?? "K",
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? "kk221",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                user?.name ?? "Kk",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              Text(
                "+918602945222", // Should be dynamic if available in user model
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
      ],
    );
  }

  Widget _upgradeButton(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFC5A028), Color(0xFF8B4513)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => debugPrint("Upgrade tapped"),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                l10n.upgradeToPlus,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressSection(AppLocalizations l10n) {
    return CustomCard(
      innerPadding: 16,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: 0.63,
                  strokeWidth: 4,
                  backgroundColor: Colors.blue.shade50,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const Text(
                "63%",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.getMoreOutOfAjjas,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18, color: Colors.blue),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.featuresExploredCount(10, 16),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleSection(AppLocalizations l10n) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is VehiclesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is VehiclesLoaded && state.vehicles.isNotEmpty) {
          return Column(
            children: [
              ...state.vehicles.take(1).map((vehicle) => _vehicleCard(l10n, vehicle)),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.notifications_none, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.notifications,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _vehicleCard(AppLocalizations l10n, vehicle) {
    return CustomCard(
      innerPadding: 16,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.two_wheeler,
                size: 40,
                color: Colors.blue,
              ), // Replace with asset if available
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${vehicle.vehicleMaker} ${vehicle.vehicleModel}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${vehicle.vehicleNumber} ${l10n.lite4G}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          SwipeToLock(text: l10n.swipeToLock, onSwipe: () => debugPrint("Locked!")),
          const SizedBox(height: 20),
          const Divider(),
          _infoRow(l10n.dataPlan, "Expires in 327 days", l10n.rechargeNow, () {}),
          const Divider(),
          _infoRow(l10n.warranty, "Expires in 327 days", l10n.renewNow, () {}),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String subtitle, String actionLabel, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black87),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuOptions(AppLocalizations l10n) {
    return CustomCard(
      innerPadding: 8,
      child: Column(
        children: [
          OptionTile(
            leading: const Icon(Icons.garage_outlined, color: Colors.blue),
            title: l10n.myGarage,
            subtitle: l10n.manageVehiclesDesc,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const MyGarageScreen())),
          ),
          OptionTile(
            leading: const Icon(Icons.settings_outlined, color: Colors.blue),
            title: l10n.settings,
            subtitle: l10n.settingsDesc,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
          OptionTile(
            leading: const Icon(Icons.help_outline, color: Colors.blue),
            title: l10n.helpAndSupport,
            subtitle: l10n.helpAndSupportDesc,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const HelpSuggestionScreen())),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _logoutButton(AppLocalizations l10n) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          final prefs = AppPreference.instance;
          prefs.clearAll();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (Route<dynamic> route) => false,
          );
        },
        icon: const Icon(Icons.logout, color: Colors.redAccent),
        label: Text(
          l10n.logout,
          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
