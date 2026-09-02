import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/app_navigation.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/get_more_out/presentation/cubit/disocver_state.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/help_support_screen.dart';
import 'package:trackify/feature/my_garage/presentation/view/my_garage_screen.dart';
import 'package:trackify/feature/my_profile/presentation/pages/my_profile_screen.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_state.dart';
import 'package:trackify/feature/settings/presentation/pages/settings_screen.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/common/widgets/vehicle_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../Vehicle_control/presentation/pages/vehicle_control_screen.dart';
import '../../../Vehicle_control/presentation/widgets/vehicle_pin_dialog.dart';
import '../../../device_data/presentation/pages/device_data_screen.dart';
import '../../../device_warranty/pages/device_warranty_page.dart';
import '../../../get_more_out/presentation/cubit/discover_cubit.dart';
import '../../../get_more_out/presentation/pages/disover_screen.dart';
import '../../../upgrade_to_plus/presentation/pages/upgrade_to_plus.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import '../../../Vehicle_control/data/repositories/vehicle_control_repository_impl.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/core/widgets/logout_confirmation_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, bool> _vehicleLockStates = {};
  int _vehicleCardRefreshCount = 0;

  Future<void> _fetchLockStatus(String vehicleId, String imei) async {
    if (imei.isEmpty || _vehicleLockStates.containsKey(imei)) return;
    try {
      final repo = VehicleControlRepositoryImpl();
      final controlDetails = await repo.getVehicleControlDetails(vehicleId, imei);
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
    if (vehicle.imei == null || vehicle.imei!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.buyTrackifyDevice),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final imei = vehicle.imei!;
    final currentLockState = _vehicleLockStates[imei] ?? false;
    final targetLockState = !currentLockState;

    final l10n = AppLocalizations.of(context)!;
    final brandAndModel = [vehicle.vehicleMaker ?? '', vehicle.vehicleModel ?? ''].where((s) => s.isNotEmpty).join(' ');

    // Require PIN only when UNLOCKING (currentLockState == true). Skip PIN when LOCKING.
    if (currentLockState) {
      final success = await VehiclePinDialog.show(
        context,
        currentLockState,
        brandAndModel.isNotEmpty ? brandAndModel : 'Vehicle',
        vehicle.imei!,
      );
      if (!success) {
        if (context.mounted) {
          setState(() {
            _vehicleCardRefreshCount++;
          });
        }
        return;
      }
    }

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
              targetLockState
                  ? l10n.vehicleLockedSuccessfully
                  : l10n.vehicleUnlockedSuccessfully,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${l10n.failedToUpdateLockStatus}: $e"),
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
          final userName = user?.name ?? l10n.guest;
          final userInitials = userName.isNotEmpty
              ? userName[0].toUpperCase()
              : "G";
          final userMobile = user?.mobileNumber ?? "";

          String profileImageUrl = '';
          if (user?.userProfile != null && user!.userProfile!.isNotEmpty) {
            String path = user.userProfile!.replaceAll('\\', '/');
            if (path.startsWith('http://') || path.startsWith('https://')) {
              profileImageUrl = path;
            } else {
              final base = ApiURL.baseURL;
              profileImageUrl = path.startsWith('/')
                  ? '$base$path'
                  : '$base/$path';
            }
          }

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
                          child: ClipOval(
                            child: profileImageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: profileImageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const Center(child: TrackifyLoader()),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                          child: Text(
                                            userInitials,
                                            style: TextStyle(
                                              fontSize: 28,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                  )
                                : Center(
                                    child: Text(
                                      userInitials,
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
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
                                  ).colorScheme.onSurface.withOpacity( 0.6),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                userMobile,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity( 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 40,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity( 0.3),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profileState) {
                    bool hasDeviceInstalled = false;
                    if (profileState is VehiclesLoaded && profileState.vehicles.isNotEmpty) {
                      final selectedImei = AppPreference.instance.getSync(
                        key: AppPreference.IMEI,
                      );
                      final selectedUid = AppPreference.instance.getSync(
                        key: AppPreference.KEY_SELECTED_UID,
                      );
                      final vehicle = profileState.vehicles.firstWhere(
                        (v) =>
                            (selectedUid.isNotEmpty && v.id == selectedUid) ||
                            (selectedImei.isNotEmpty && v.imei == selectedImei),
                        orElse: () => profileState.vehicles.first,
                      );
                      hasDeviceInstalled = vehicle.imei != null && vehicle.imei!.isNotEmpty;
                    }
                    
                    if (profileState is VehiclesLoaded && !hasDeviceInstalled) {
                      return const SizedBox.shrink();
                    }
                    
                    return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiscoverFeaturesScreen(),
                      ),
                    );
                  },
                  child: BlocBuilder<DiscoverCubit, DiscoverState>(
                    builder: (context, state) {
                      double progressValue = double.tryParse(
                            AppPreference.instance.getSync(key: 'discover_progress_value'),
                          ) ?? 0.0;
                      String progressString = AppPreference.instance.getSync(
                            key: 'discover_progress_string',
                          );
                      if (progressString.isEmpty) {
                        progressString = "0";
                      }

                      int currentExplored = 10;
                      int currentTotal = 16;
                      String exploredStr = AppPreference.instance.getSync(key: 'discover_explored');
                      String totalStr = AppPreference.instance.getSync(key: 'discover_total');
                      if (exploredStr.isNotEmpty) currentExplored = int.tryParse(exploredStr) ?? 10;
                      if (totalStr.isNotEmpty) currentTotal = int.tryParse(totalStr) ?? 16;

                      if (state is DiscoverLoaded) {
                        int explored = 0;
                        int total = 0;
                        final regex = RegExp(r'\d+/(\d+)');
                        final prefs = AppPreference.instance;
                        final list = prefs.getStringList(key: AppPreference.KEY_EXPLORED_FEATURES);

                        for (var item in state.discoverList) {
                          final match = regex.firstMatch(item.exploredText);
                          int catTotal = 0;
                          if (match != null) {
                            catTotal = int.tryParse(match.group(1) ?? '0') ?? 0;
                          } else {
                            catTotal = int.tryParse(item.exploredText) ?? 0;
                          }
                          
                          if (catTotal > 0) {
                            total += catTotal;
                            
                            final catExplored = list.where((id) => id.startsWith('${item.id}_')).length;
                            explored += (catExplored > catTotal ? catTotal : catExplored);
                          }
                        }
                        if (total > 0) {
                          final calculatedValue = explored / total;
                          final calculatedString = (calculatedValue * 100).toInt().toString();

                          if (calculatedValue != progressValue || calculatedString != progressString) {
                            progressValue = calculatedValue;
                            progressString = calculatedString;
                            prefs.set(key: 'discover_progress_value', value: progressValue.toString());
                            prefs.set(key: 'discover_progress_string', value: progressString);
                          }
                          if (explored != currentExplored || total != currentTotal) {
                            currentExplored = explored;
                            currentTotal = total;
                            prefs.set(key: 'discover_explored', value: currentExplored.toString());
                            prefs.set(key: 'discover_total', value: currentTotal.toString());
                          }
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withOpacity( 0.1),
                              Theme.of(context).colorScheme.secondary.withOpacity( 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity( 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 44,
                                  width: 44,
                                  child: CircularProgressIndicator(
                                    value: progressValue,
                                    strokeWidth: 4,
                                    backgroundColor: Theme.of(context).dividerColor,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  l10n.progressPercentage(progressString),
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
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.secondary,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(bounds),
                                    child: Text(
                                      l10n.getMoreOutOfTrackify,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.featuresExploredCount(currentExplored, currentTotal),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity( 0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity( 0.3),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state is VehiclesLoading) {
                        return const Center(child: TrackifyLoader());
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
                              (selectedUid.isNotEmpty && v.id == selectedUid) ||
                              (selectedImei.isNotEmpty &&
                                  v.imei == selectedImei),
                          orElse: () => state.vehicles.first,
                        );

                        if (vehicle.imei != null) {
                          _fetchLockStatus(vehicle.id ?? '', vehicle.imei!);
                        }

                        final isLocked =
                            _vehicleLockStates[vehicle.imei] ?? false;

                        final hasDevice =
                            selectedImei.isNotEmpty &&
                            vehicle.imei == selectedImei;
                        final isDeviceInstalled =
                            vehicle.imei != null && vehicle.imei!.isNotEmpty;

                        return VehicleCard(
                          key: ValueKey(
                            '${vehicle.id}-$_vehicleCardRefreshCount',
                          ),
                          context: context,
                          vehicle: vehicle,
                          hasDevice: hasDevice,
                          isDeviceInstalled: isDeviceInstalled,
                          isLocked: isLocked,
                          onVehicleControl: () async {
                            if (vehicle.id != null && vehicle.id!.isNotEmpty) {
                              await AppPreference.instance.set(
                                key: AppPreference.KEY_SELECTED_UID,
                                value: vehicle.id!,
                              );
                            }
                            await AppPreference.instance.set(
                              key: AppPreference.IMEI,
                              value: vehicle.imei ?? '',
                            );

                            AppNavigation.refreshNavigationState();

                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VehicleControlScreen(
                                    isFromGarage: isDeviceInstalled
                                        ? false
                                        : true,
                                    passedVehicle: vehicle,
                                  ),
                                ),
                              );
                            }
                          },
                          onLock: () => _handleVehicleLock(context, vehicle),
                          onRecharge: () {
                            if (vehicle.imei == null || vehicle.imei!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.buyTrackifyDevice,
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeviceDataScreen(),
                              ),
                            );
                          },
                          onRenew: () async {
                            if (vehicle.imei == null || vehicle.imei!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.buyTrackifyDevice,
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WarrantyScreen(),
                              ),
                            );
                            if (result == true && mounted) {
                              setState(() {
                                _vehicleCardRefreshCount++;
                              });
                            }
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
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity( 0.5), width: 0.5),
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
                        l10n.registerNewVehicleDesc,
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
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity( 0.5), width: 0.5),
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
                      Material(
                        type: MaterialType.transparency,
                        child: Row(
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
                                title: Text(
                                  AppLocalizations.of(context)!.miles,
                                ),
                                value: 'miles',
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
                          ).colorScheme.onSurface.withOpacity( 0.6),
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
                  ).colorScheme.onSurface.withOpacity( 0.3),
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
        onPressed: () => LogoutConfirmationDialog.show(context),
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
