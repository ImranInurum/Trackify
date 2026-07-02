import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/app_navigation.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/help_support_screen.dart';
import 'package:trackify/feature/my_garage/presentation/view/my_garage_screen.dart';
import 'package:trackify/feature/my_profile/presentation/pages/my_profile_screen.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_state.dart';
import 'package:trackify/feature/settings/presentation/pages/settings_screen.dart';

import '../../../../core/common/widgets/vehicle_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../Vehicle_control/presentation/pages/vehicle_control_screen.dart';
import '../../../device_data/presentation/pages/device_data_screen.dart';
import '../../../device_warranty/pages/device_warranty_page.dart';
import '../../../get_more_out/presentation/pages/disover_screen.dart';
import '../../../upgrade_to_plus/presentation/pages/upgrade_to_plus.dart';
import '../../../notifications/presentation/screen/notification_timeline.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import '../../../Vehicle_control/data/repositories/vehicle_control_repository_impl.dart';
import 'package:trackify/core/utils/distance_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, bool> _vehicleLockStates = {};

  Future<void> _fetchLockStatus(String imei) async {
    if (imei.isEmpty || _vehicleLockStates.containsKey(imei)) return;
    try {
      final repo = VehicleControlRepositoryImpl();
      final controlDetails = await repo.getVehicleControlDetails(imei);
      if (mounted) {
        setState(() {
          _vehicleLockStates[imei] = controlDetails.vehicleLock;
        });
      }
    } catch (e) {
      debugPrint("Error fetching lock status in profile: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<AppCubit>().loadUserSession();
    context.read<ProfileCubit>().fetchVehicles();
    AppNavigation.currentTabNotifier.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    AppNavigation.currentTabNotifier.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (AppNavigation.currentTabNotifier.value == 3) {
      if (mounted) {
        context.read<ProfileCubit>().fetchVehicles();
        setState(() {});
      }
    }
  }

  void _handleVehicleLock(BuildContext context, Vehicle vehicle) async {
    if (vehicle.imei == null || vehicle.imei!.isEmpty) return;

    final imei = vehicle.imei!;
    final currentLockState = _vehicleLockStates[imei] ?? false;
    final targetLockState = !currentLockState;

    try {
      final repo = VehicleControlRepositoryImpl();
      await repo.updateVehicleLock(imei, targetLockState);

      if (context.mounted) {
        setState(() {
          _vehicleLockStates[imei] = targetLockState;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Vehicle ${targetLockState ? 'Locked' : 'Unlocked'} successfully!",
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update lock status: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, appState) {
          final user = appState.userData;
          final userName = user?.name ?? "Guest";
          final userInitials = userName.isNotEmpty
              ? userName[0].toUpperCase()
              : "G";
          final userMobile = user?.mobileNumber ?? "";

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),

                /// 🔹 PROFILE SECTION
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyProfileScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Center(
                            child: Text(
                              userInitials,
                              style: TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
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
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userName,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                userMobile,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 UPGRADE BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpgradeToPlusScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 68),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFD6B57B),
                          Color(0xFFE7D0B7),
                          Color(0xFFD6B57B),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.kingIcon,
                            height: 20,
                            width: 20,
                          ),
                          Text(
                            " ${l10n.upgradeToPlus}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiscoverFeaturesScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).dividerColor),
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
                                backgroundColor: Theme.of(context).dividerColor,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              "63%",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.getMoreOutOfTrackify,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.featuresExploredCount(10, 16),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state is VehiclesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is VehiclesLoaded &&
                          state.vehicles.isNotEmpty) {
                        final selectedImei = AppPreference.instance.getSync(
                          key: AppPreference.IMEI,
                        );
                        final selectedUid = AppPreference.instance.getSync(
                          key: AppPreference.KEY_SELECTED_UID,
                        );
                        final vehicle = state.vehicles.firstWhere(
                          (v) =>
                              (selectedUid.isNotEmpty &&
                                  v.id == selectedUid) ||
                              (selectedImei.isNotEmpty &&
                                  v.imei == selectedImei),
                          orElse: () => state.vehicles.first,
                        );

                        if (vehicle.imei != null) {
                          _fetchLockStatus(vehicle.imei!);
                        }

                        final isLocked =
                            _vehicleLockStates[vehicle.imei] ?? false;

                        return VehicleCard(
                          context: context,
                          vehicle: vehicle,
                          hasDevice: true,
                          isLocked: isLocked,
                          onVehicleControl: () async {
                            if (vehicle.id != null &&
                                vehicle.id!.isNotEmpty) {
                              await AppPreference.instance.set(
                                key: AppPreference.KEY_SELECTED_UID,
                                value: vehicle.id!,
                              );
                            }
                            if (vehicle.imei != null &&
                                vehicle.imei!.isNotEmpty) {
                              await AppPreference.instance.set(
                                key: AppPreference.IMEI,
                                value: vehicle.imei!,
                              );
                            }
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VehicleControlScreen(
                                        isFromGarage: false,
                                        passedVehicle: vehicle,
                                      ),
                                ),
                              );
                            }
                          },
                          onLock: () =>
                              _handleVehicleLock(context, vehicle),
                          onRecharge: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeviceDataScreen(),
                              ),
                            );
                          },
                          onRenew: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WarrantyScreen(),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 MENU LIST
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
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
                            MaterialPageRoute(
                              builder: (_) => const MyGarageScreen(),
                            ),
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
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
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
                        "Register a new Vehicle or Trackify Device",
                        // Add translation if available
                        Icons.add_box_sharp,
                        isLast: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChoiceSelector(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 DISTANCE UNIT SELECTION
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          AppLocalizations.of(context)!.distanceUnitSelection,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Theme.of(context).dividerColor),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(l10n.km),
                              value: 'km',
                              groupValue: appState.distanceUnit,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<AppCubit>().changeDistanceUnit(
                                    value,
                                  );
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(AppLocalizations.of(context)!.miles),
                              value: 'mi',
                              groupValue: appState.distanceUnit,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<AppCubit>().changeDistanceUnit(
                                    value,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
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
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sub,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Divider(height: 1, color: Theme.of(context).dividerColor),
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
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (Route<dynamic> route) => false,
          );
        },
        icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
        label: Text(
          l10n.logout,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
