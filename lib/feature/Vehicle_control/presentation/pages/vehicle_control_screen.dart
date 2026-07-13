import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackify/app/app_navigation.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/feature/Vehicle_control/domain/entities/vehicle_control_entity.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../../document_folder/presentation/pages/document_screen.dart';
import '../../../upgrade_to_plus/presentation/pages/upgrade_to_plus.dart';
import '../../data/repositories/vehicle_control_repository_impl.dart';
import '../cubit/vehicle_control_cubit.dart';
import '../state/vehicle_control_state.dart';
import '../widgets/metric_card.dart';
import '../widgets/lock_card.dart';
import '../widgets/vehicle_on_map_card.dart';
import '../widgets/journey_card.dart';
import '../widgets/documents_card.dart';
import 'notification_controls_screen.dart';
import 'edit_vehicle_screen.dart';
import 'package:trackify/core/utils/distance_utils.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class VehicleControlScreen extends StatelessWidget {
  final bool isFromGarage;
  final Vehicle? passedVehicle;

  const VehicleControlScreen({
    super.key,
    this.isFromGarage = false,
    this.passedVehicle,
  });

  @override
  Widget build(BuildContext context) {
    final imei = passedVehicle?.imei ?? '';
    return BlocProvider(
      create: (context) {
        final cubit = VehicleControlCubit(VehicleControlRepositoryImpl());
        if (imei.isEmpty && passedVehicle != null) {
          // No device installed — load directly from the passed vehicle object
          // without making any API call.
          cubit.loadFromVehicle(passedVehicle!);
        } else {
          cubit.loadVehicleDetails(imei);
        }
        return cubit;
      },
      child: VehicleControlView(
        isFromGarage: isFromGarage,
        passedVehicle: passedVehicle,
      ),
    );
  }
}

class VehicleControlView extends StatefulWidget {
  final bool isFromGarage;
  final Vehicle? passedVehicle;

  const VehicleControlView({
    super.key,
    this.isFromGarage = false,
    this.passedVehicle,
  });

  @override
  State<VehicleControlView> createState() => _VehicleControlViewState();
}

class _VehicleControlViewState extends State<VehicleControlView> {
  String? _lastLoadedVehicleId;
  List<Map<String, String>> _contacts = [];
  List<csc.Country> _countries = [];
  bool _isLoadingCountries = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await csc.getAllCountries();
      if (mounted) {
        setState(() {
          _countries = countries;
          _isLoadingCountries = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading countries: $e");
      if (mounted) {
        setState(() {
          _isLoadingCountries = false;
        });
      }
    }
  }

  void _ensureContactsLoaded(VehicleControlEntity vehicle) async {
    final keyId = vehicle.id.isNotEmpty
        ? vehicle.id
        : (vehicle.vehicleNumber.isNotEmpty
              ? vehicle.vehicleNumber
              : 'default');
    if (_lastLoadedVehicleId != keyId) {
      _lastLoadedVehicleId = keyId;
      final raw = await AppPreference.instance.get(
        key: "emergency_contacts_$keyId",
      );
      if (raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw) as List;
          setState(() {
            _contacts = decoded
                .map((item) => Map<String, String>.from(item))
                .toList();
          });
        } catch (e) {
          debugPrint("Error parsing emergency contacts: $e");
        }
      } else {
        setState(() {
          _contacts = [];
        });
      }
    }
  }

  Future<void> _saveEmergencyContacts(String keyId) async {
    final raw = jsonEncode(_contacts);
    await AppPreference.instance.set(
      key: "emergency_contacts_$keyId",
      value: raw,
    );
  }

  void _showAddContactDialog(BuildContext context, String keyId) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String selectedPhoneCode = '+91';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => Dialog(
          backgroundColor: isDark ? const Color(0xFF2C2C2C) : theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Emergency Contact",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: l10n.name,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSurface.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.nameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: l10n.mobileNumber,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSurface.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.only(left: 12, right: 4),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: theme.dividerColor),
                          ),
                        ),
                        child: SizedBox(
                          width: 85,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedPhoneCode,
                              isDense: true,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down, size: 20),
                              menuMaxHeight: 300,
                              dropdownColor: isDark
                                  ? const Color(0xFF2C2C2C)
                                  : theme.cardColor,
                              items: _countries.isEmpty
                                  ? [
                                      const DropdownMenuItem(
                                        value: '+91',
                                        child: Text(
                                          "🇮🇳 +91",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ]
                                  : (() {
                                      final seenCodes = <String>{};
                                      final uniqueItems =
                                          <DropdownMenuItem<String>>[];
                                      for (final c in _countries) {
                                        if (c.phoneCode.isEmpty) continue;
                                        final code = c.phoneCode.startsWith('+')
                                            ? c.phoneCode
                                            : '+${c.phoneCode}';
                                        if (!seenCodes.contains(code)) {
                                          seenCodes.add(code);
                                          uniqueItems.add(
                                            DropdownMenuItem(
                                              value: code,
                                              child: Text(
                                                "${c.flag} $code",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                      return uniqueItems;
                                    })(),
                              onChanged: (value) {
                                if (value != null) {
                                  setStateDialog(() {
                                    selectedPhoneCode = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.mobileNumberRequired;
                      }
                      final cleanValue = value.trim();
                      if (!RegExp(r'^[0-9]+$').hasMatch(cleanValue)) {
                        return l10n.invalidMobileNumber;
                      }

                      if (selectedPhoneCode == '+91') {
                        if (cleanValue.length != 10) {
                          return l10n.invalidMobileNumber;
                        }
                        if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(cleanValue)) {
                          return l10n.invalidMobileNumber;
                        }
                      } else {
                        if (cleanValue.length < 7 || cleanValue.length > 15) {
                          return l10n.invalidMobileNumber;
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          l10n.cancel,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            setState(() {
                              _contacts.add({
                                'name': nameController.text.trim(),
                                'phone':
                                    '$selectedPhoneCode ${phoneController.text.trim()}',
                              });
                            });
                            _saveEmergencyContacts(keyId);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.save,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final colorScheme = theme.colorScheme;
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : theme.cardColor;
    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor = colorScheme.onSurface.withOpacity(0.6);

    return Scaffold(
      backgroundColor: bgColor,
      body: BlocListener<VehicleControlCubit, VehicleControlState>(
        listener: (context, state) {
          if (state is VehicleControlDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.vehicleRemovedSuccessfully,
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
          if (state is VehicleControlLoaded && state.actionError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.actionError!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        child: BlocBuilder<VehicleControlCubit, VehicleControlState>(
          builder: (context, state) {
            if (state is VehicleControlLoading) {
              return const Center(child: TrackifyLoader());
            }
            if (state is VehicleControlError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            }
            if (state is VehicleControlLoaded) {
              final vehicle = state.vehicle;
              _ensureContactsLoaded(vehicle);
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: size.height * 0.26,
                    pinned: true,
                    backgroundColor: bgColor,
                    elevation: 0,
                    leading: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final top = constraints.biggest.height;
                        final isCollapsed =
                            top <=
                            kToolbarHeight +
                                MediaQuery.of(context).padding.top +
                                30;

                        return FlexibleSpaceBar(
                          centerTitle: false,
                          title: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isCollapsed ? 1.0 : 0.0,
                            child: Text(
                              vehicle.vehicleName.isNotEmpty
                                  ? vehicle.vehicleName
                                  : (widget.passedVehicle != null
                                        ? "${widget.passedVehicle!.vehicleMaker ?? ''} ${widget.passedVehicle!.vehicleModel ?? ''}"
                                              .trim()
                                        : ""),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image(
                                image: vehicle.bikeImage != null
                                    ? (vehicle.bikeImage!.startsWith('http')
                                          ? CachedNetworkImageProvider(
                                              vehicle.bikeImage!,
                                            )
                                          : FileImage(File(vehicle.bikeImage!))
                                                as ImageProvider)
                                    : AssetImage(AppImages.bikeInfoImage),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppImages.bikeInfoImage,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [0.6, 0.9, 1.0],
                                    colors: [
                                      Colors.transparent,
                                      bgColor.withOpacity(0.8),
                                      bgColor,
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: size.height * 0.01,
                                right: 20,
                                child: GestureDetector(
                                  onTap: () => _showImageSourceDialog(
                                    context,
                                    vehicle.id,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              vehicle.vehicleName.isNotEmpty
                                  ? vehicle.vehicleName
                                  : (widget.passedVehicle != null &&
                                            ("${widget.passedVehicle!.vehicleMaker ?? ''} ${widget.passedVehicle!.vehicleModel ?? ''}"
                                                    .trim())
                                                .isNotEmpty
                                        ? "${widget.passedVehicle!.vehicleMaker ?? ''} ${widget.passedVehicle!.vehicleModel ?? ''}"
                                              .trim()
                                        : l10n.vehicleDetailsLabel),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: primaryTextColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  vehicle.vehicleNumber.isNotEmpty
                                      ? "${vehicle.vehicleNumber} | ${vehicle.fuelType}"
                                      : (widget.passedVehicle != null &&
                                                (widget
                                                        .passedVehicle!
                                                        .vehicleNumber
                                                        ?.isNotEmpty ??
                                                    false)
                                            ? "${widget.passedVehicle!.vehicleNumber ?? ''} | ${widget.passedVehicle!.fuelType ?? vehicle.fuelType}"
                                            : "${vehicle.vehicleNumber} | ${vehicle.fuelType}"),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: secondaryTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => BlocProvider.value(
                                          value: context
                                              .read<VehicleControlCubit>(),
                                          child: EditVehicleScreen(
                                            vehicle: vehicle,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      l10n.edit,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: MetricCard(
                                  value: vehicle.tankCapacity,
                                  unit: l10n.litresShort,
                                  label: l10n.tankCapacity,
                                  cardColor: cardColor,
                                  onEdit: () => _showTankCapacityDialog(
                                    context,
                                    vehicle.id,
                                    vehicle.tankCapacity,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: MetricCard(
                                  value: vehicle.vehicleMileage,
                                  unit: context.displayKmL,
                                  label: l10n.vehicleMileage,
                                  cardColor: cardColor,
                                  onEdit: () => _showMileageDialog(
                                    context,
                                    vehicle.id,
                                    vehicle.vehicleMileage,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        LockCard(
                          cardColor: cardColor,
                          primaryTextColor: primaryTextColor,
                          secondaryTextColor: secondaryTextColor,
                          isLocked: vehicle.vehicleLock,
                          onLock: () {
                            context
                                .read<VehicleControlCubit>()
                                .updateVehicleLock(
                                  vehicle.id,
                                  !vehicle.vehicleLock,
                                );
                          },
                          onInfoTap: () => _showSleepModeDialog(context),
                        ),

                        const SizedBox(height: 12),

                        VehicleOnMapCard(
                          cardColor: cardColor,
                          primaryTextColor: primaryTextColor,
                          secondaryTextColor: secondaryTextColor,
                          accentColor: theme.colorScheme.primary,
                          selectedIcon: state.tempIcon,
                          selectedColor: state.tempColor,
                          onUpgrade: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UpgradeToPlusScreen(),
                              ),
                            );
                          },
                          onIconChanged: (icon) {
                            context.read<VehicleControlCubit>().updateLocalIcon(
                              icon,
                            );
                          },
                          onColorChanged: (color) {
                            context
                                .read<VehicleControlCubit>()
                                .updateLocalColor(color);
                          },
                          onSave: () {
                            context.read<VehicleControlCubit>().saveChanges(
                              vehicle.id,
                            );
                          },
                          showSaveButton:
                              state.tempIcon != vehicle.selectedIcon ||
                              state.tempColor != vehicle.selectedColor,
                        ),

                        const SizedBox(height: 12),

                        BlocBuilder<AppCubit, AppState>(
                          builder: (context, appState) {
                            final matchingDevice = appState.devices.firstWhere(
                              (d) =>
                                  d['imei']?.toString() == vehicle.imei ||
                                  d['_id']?.toString() == vehicle.id ||
                                  d['id']?.toString() == vehicle.id,
                              orElse: () => <String, dynamic>{},
                            );
                            String distanceTravelled = "0.0";
                            if (matchingDevice.isNotEmpty) {
                              final odometerRaw = matchingDevice['odometer'];
                              if (odometerRaw != null) {
                                final double? val = double.tryParse(
                                  odometerRaw.toString(),
                                );
                                if (val != null) {
                                  distanceTravelled = val.toStringAsFixed(1);
                                } else {
                                  distanceTravelled = odometerRaw.toString();
                                }
                              }
                            }
                            return JourneyCard(
                              cardColor: cardColor,
                              primaryTextColor: primaryTextColor,
                              secondaryTextColor: secondaryTextColor,
                              distance: distanceTravelled,
                              hours: "0",
                              minutes: "0",
                              onTap: () {
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                                AppNavigation.setIndex(2);
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        DocumentsCard(
                          cardColor: cardColor,
                          primaryTextColor: primaryTextColor,
                          secondaryTextColor: secondaryTextColor,
                          imei: vehicle.id,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DocumentFolderScreen(),
                              ),
                            );
                          },
                        ),

                        if (widget.isFromGarage == false)
                          const SizedBox(height: 12),

                        Divider(
                          height: 1,
                          color: theme.colorScheme.onSurface.withOpacity(0.15),
                        ),

                        if (widget.isFromGarage == false)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationControlsScreen(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.settings_outlined,
                                    color: secondaryTextColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.notificationControls,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: primaryTextColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          l10n.changeNotificationPreferences,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: secondaryTextColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        Divider(
                          height: 1,
                          color: theme.colorScheme.onSurface.withOpacity(0.15),
                        ),
                        const SizedBox(height: 20),

                        if (widget.isFromGarage == false)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.unmapTrackify,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: primaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.unmapStep1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: secondaryTextColor,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.unmapStep2,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: secondaryTextColor,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (widget.isFromGarage) ...[
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_ic_call,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      l10n.emergencyContacts,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_contacts.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  ..._contacts.map((contact) {
                                    final name = contact['name'] ?? '';
                                    final phone = contact['phone'] ?? '';
                                    return Container(
                                      margin: const EdgeInsets.only(
                                        left: 32,
                                        bottom: 8,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.08),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: theme
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.1),
                                            child: Text(
                                              name.isNotEmpty
                                                  ? name[0].toUpperCase()
                                                  : '?',
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: primaryTextColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  phone,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: secondaryTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: theme.colorScheme.error
                                                  .withOpacity(0.8),
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _contacts.remove(contact);
                                              });
                                              final keyId =
                                                  vehicle.id.isNotEmpty
                                                  ? vehicle.id
                                                  : (vehicle
                                                            .vehicleNumber
                                                            .isNotEmpty
                                                        ? vehicle.vehicleNumber
                                                        : 'default');
                                              _saveEmergencyContacts(keyId);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(left: 32),
                                  child: InkWell(
                                    onTap: () {
                                      final keyId = vehicle.id.isNotEmpty
                                          ? vehicle.id
                                          : (vehicle.vehicleNumber.isNotEmpty
                                                ? vehicle.vehicleNumber
                                                : 'default');
                                      _showAddContactDialog(context, keyId);
                                    },
                                    borderRadius: BorderRadius.circular(4),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        l10n.addOneMore,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            height: 1,
                            color: theme.colorScheme.onSurface.withOpacity(
                              0.15,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: InkWell(
                              onTap: () => _showDeleteConfirmationDialog(
                                context,
                                vehicle.imei,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    color: theme.colorScheme.error,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    l10n.removeVehicle,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, String id) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: theme.colorScheme.primary),
              title: Text(
                l10n.camera,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(context, ImageSource.camera, id);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                l10n.gallery,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(context, ImageSource.gallery, id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    ImageSource source,
    String id,
  ) async {
    final cubit = context.read<VehicleControlCubit>();
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(title: 'Crop Image'),
          ],
        );
        if (croppedFile != null) {
          cubit.updateVehicleImage(id, croppedFile.path);
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showTankCapacityDialog(
    BuildContext context,
    String vehicleIMEI,
    String currentVal,
  ) {
    // ── Device install check ─────────────────────────────────────────────
    if (vehicleIMEI.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Please install a Trackify device to update tank capacity.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }
    final cubit = context.read<VehicleControlCubit>();
    final controller = TextEditingController(text: currentVal);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_gas_station_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.tankCapacity,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: l10n.tankCapacityHint,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 12),
                      child: Text(
                        l10n.litresShort,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "${l10n.lastUpdatedLabel}$currentVal ${l10n.litresShort}",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      cubit.updateTankCapacity(vehicleIMEI, controller.text);
                      Navigator.pop(context);
                    },
                    child: Text(
                      l10n.save,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMileageDialog(
    BuildContext context,
    String vehicleIMEI,
    String currentVal,
  ) {
    // ── Device install check ─────────────────────────────────────────────
    if (vehicleIMEI.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Please install a Trackify device to update mileage.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }
    final cubit = context.read<VehicleControlCubit>();
    final controller = TextEditingController(text: currentVal);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.speed_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.vehicleMileage,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: l10n.mileageHint,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 12),
                      child: Text(
                        context.displayKmL,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "${l10n.lastUpdatedLabel}$currentVal ${context.displayKmL}",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      cubit.updateMileage(vehicleIMEI, controller.text);
                      Navigator.pop(context);
                    },
                    child: Text(
                      l10n.save,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSleepModeDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  l10n.whatIsSleepMode,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.sleepModeDesc1,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.sleepModeDesc2,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.gotIt,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String vehicleIMEI) {
    final cubit = context.read<VehicleControlCubit>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : theme.cardColor,
        title: Text(l10n.removeVehicle),
        content: Text(l10n.removeVehicleConfirmDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              final idToDelete = widget.passedVehicle?.id ?? vehicleIMEI;
              cubit.deleteVehicle(idToDelete, vehicleIMEI);
            },
            child: Text(
              l10n.removeBtn,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
