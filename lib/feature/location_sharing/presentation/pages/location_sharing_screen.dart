import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/location_sharing_cubit.dart';
import '../cubit/location_sharing_state.dart';
import '../cubit/live/location_sharing_live_cubit.dart';
import '../cubit/history/location_sharing_history_cubit.dart';
import 'location_sharing_detail_screen.dart';
import 'widgets/location_sharing_card.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trackify/core/common/widgets/unlock_device_dialog.dart';

class LocationSharingScreen extends StatefulWidget {
  const LocationSharingScreen({super.key});

  @override
  State<LocationSharingScreen> createState() => _LocationSharingScreenState();
}

class _LocationSharingScreenState extends State<LocationSharingScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the Cubit is available if it was provided higher up
    // or just call it here if we're creating it here.
    // In this case, I'll assume it's provided via BlocProvider in the parent or I'll wrap it.
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_rounded,
                color: theme.colorScheme.error,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.locationPermissionWarning,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.goToSettingsAndSelectAllowAllTheTime,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: theme.hintColor),
              ),
              const SizedBox(height: 24),
              // Simulated Phone UI
              Container(
                height: 150,
                width: 110,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: theme.colorScheme.outlineVariant, width: 4),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Icon(
                      Icons.location_on,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.trackifyApp,
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 9),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity( 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity( 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      height: 18,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity( 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          l10n.locationText,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.tapIntoLocation,
                style: TextStyle(fontSize: 12, color: theme.hintColor),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openAppSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.goToSettingsBtn,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDurationDialog(
    BuildContext context,
    LocationSharingItem item,
    LocationSharingCubit cubit,
  ) {
    int selectedOption = 2; // Default 2 hours

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        final theme = Theme.of(context);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              title: Text(
                l10n.shareLiveLocationFor,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<int>(
                    title: const Text('30 Minutes'),
                    value: -30,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() => selectedOption = value!);
                    },
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                  RadioListTile<int>(
                    title: Text(l10n.twoHours),
                    value: 2,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() => selectedOption = value!);
                    },
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                  RadioListTile<int>(
                    title: Text(l10n.fourHours),
                    value: 4,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() => selectedOption = value!);
                    },
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                  RadioListTile<int>(
                    title: Text(l10n.eightHours),
                    value: 8,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() => selectedOption = value!);
                    },
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                  RadioListTile<int>(
                    title: Text(l10n.untilStopped),
                    value: 0,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() => selectedOption = value!);
                    },
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        cubit.shareLiveLocation(context, item.id, selectedOption);
                      },
                      icon: Icon(
                        Icons.share,
                        color: theme.colorScheme.onPrimary,
                        size: 20,
                      ),
                      label: Text(
                        l10n.shareLocationLink,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => LocationSharingCubit()..loadLocations(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.cardColor,
          elevation: 1,
          shadowColor: theme.shadowColor.withOpacity( 0.1),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: theme.colorScheme.onSurface,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            l10n.locationSharing,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: false,
        ),
        body: Stack(
          children: [
            BlocBuilder<LocationSharingCubit, LocationSharingState>(
              builder: (context, state) {
                if (state is LocationSharingLoading) {
                  return const Center(child: TrackifyLoader());
                } else if (state is LocationSharingLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return LocationSharingCard(
                        item: item,
                        onShareTap: () async {
                          final cubit = context.read<LocationSharingCubit>();
                          if (!item.isSharing) {
                            if (item.isPhone) {
                              var status =
                                  await Permission.locationAlways.status;
                              if (!status.isGranted) {
                                _showPermissionDialog(context);
                                return;
                              }
                            } else {
                              if (item.imei.isEmpty) {
                                showUnlockDeviceDialog(context, "Location Sharing");
                                return;
                              }
                            }
                            // Show the duration dialog
                            _showDurationDialog(context, item, cubit);
                          } else {
                            // If already sharing, just stop it
                            cubit.toggleSharing(item.id);
                          }
                        },
                        onCardTap: () {
                          if (!item.isPhone && item.imei.isEmpty) {
                            showUnlockDeviceDialog(context, "Location Sharing");
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<LocationSharingCubit>(),
                                  ),
                                  BlocProvider(
                                    create: (context) => LocationSharingLiveCubit(locationItem: item)..fetchLiveShares(),
                                  ),
                                  BlocProvider(
                                    create: (context) => LocationSharingHistoryCubit(locationItem: item)..fetchHistory(),
                                  ),
                                ],
                                child: LocationSharingDetailScreen(item: item),
                              ),
                            ),
                          ).then((_) {
                            // Refresh count when returning to this screen
                            if (context.mounted) {
                              context.read<LocationSharingCubit>().fetchActiveShareCount(item);
                            }
                          });
                        },
                      );
                    },
                  );
                } else if (state is LocationSharingError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
