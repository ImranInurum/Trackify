import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/help_support_screen.dart';
import 'package:trackify/feature/my_garage/presentation/view/my_garage_screen.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_state.dart';
import 'package:trackify/feature/settings/presentation/pages/settings_screen.dart';

import '../../../../core/common/widgets/vehicle_card.dart';
import '../../../../l10n/app_localizations.dart';

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
      backgroundColor: const Color(0xFFF3F4F6),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, appState) {
          final user = appState.userData;
          final userName = user?.name ?? "Guest";
          final userInitials = userName.isNotEmpty ? userName[0].toUpperCase() : "G";
          final userMobile =
              "+918602945222"; // Static for now as per design, but could be user.mobile if exists

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),

                /// 🔹 PROFILE SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1DA1C9),
                        ),
                        child: Center(
                          child: Text(
                            userInitials,
                            style: const TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(userName, style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 2),
                            Text(userMobile, style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 UPGRADE BUTTON
                GestureDetector(
                  onTap: () => debugPrint("Upgrade tapped"),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD6B57B), Color(0xFFB38B59)],
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImages.kingIcon, height: 20, width: 20),
                          Text(
                            " ${l10n.upgradeToPlus}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 PROGRESS CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 48,
                            width: 48,
                            child: CircularProgressIndicator(
                              value: 0.63,
                              strokeWidth: 4,
                              backgroundColor: Colors.grey.shade300,
                              color: const Color(0xFF1DA1C9),
                            ),
                          ),
                          const Text("63%"),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.getMoreOutOfAjjas,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1DA1C9),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.featuresExploredCount(10, 16),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 0.5,
                        offset: const Offset(0, 0.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// 🔹 VEHICLE SECTION (Dynamic)
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          if (state is VehiclesLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state is VehiclesLoaded && state.vehicles.isNotEmpty) {
                            final vehicle = state.vehicles.first;
                            return VehicleCard(
                              vehicle: vehicle,
                              hasDevice:
                                  true, // Assuming first vehicle has device for now
                              onLock: () => debugPrint("Locked!"),
                              onRecharge: () => debugPrint("Recharge"),
                              onRenew: () => debugPrint("Renew"),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      /// 🔹 NOTIFICATIONS
                      GestureDetector(
                        onTap: () => debugPrint("Notifications tapped"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.notifications_none_rounded,
                                color: Color(0xFF1DA1C9),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.notifications,
                                style: const TextStyle(color: Color(0xFF1DA1C9)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 MENU LIST
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Column(
                    children: [
                      _menu(
                        l10n.myGarage,
                        l10n.manageVehiclesDesc,
                        Icons.home_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MyGarageScreen()),
                          );
                        },
                      ),
                      _menu(
                        l10n.settings,
                        l10n.settingsDesc,
                        Icons.settings,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                          );
                        },
                      ),
                      _menu(
                        l10n.helpAndSupport,
                        l10n.helpAndSupportDesc,
                        Icons.support_agent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HelpSuggestionScreen(),
                            ),
                          );
                        },
                      ),
                      _menu(
                        l10n.addVehicle,
                        "Register a new Vehicle or Trackify Device", // Add translation if available
                        Icons.add_box_sharp,
                        isLast: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChoiceSelector()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _menu(
    String title,
    String sub,
    IconData icon, {
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: isLast
                ? const EdgeInsets.symmetric(vertical: 16.0)
                : const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1DA1C9)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Divider(height: 1, color: Colors.grey.shade300),
          ),
      ],
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
