import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackify/app/app_navigation.dart';
import 'package:trackify/core/constants/app_images.dart';
import '../../domain/entities/vehicle_control_entity.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../../document_folder/presentation/pages/document_screen.dart';
import '../../../upgrade_to_plus/presentation/pages/upgrade_to_plus.dart';
import '../../data/repositories/vehicle_control_repository_impl.dart';
import '../cubit/vehicle_control_cubit.dart';
import '../state/vehicle_control_state.dart';
import '../widgets/metric_card.dart';
import '../widgets/lock_card.dart';
import '../widgets/vehicle_pin_dialog.dart';
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
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/device_installation/presentation/pages/device_installation_screen.dart';
import 'package:trackify/feature/map/presentation/cubit/map_cubit.dart';
import 'package:trackify/feature/map/presentation/cubit/map_state.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_cubit.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_state.dart';

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
          cubit.loadVehicleDetails(passedVehicle?.id, imei);
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

  void _ensureContactsLoaded(VehicleControlEntity vehicle) {
    final keyId = vehicle.id.isNotEmpty
        ? vehicle.id
        : (vehicle.vehicleNumber.isNotEmpty
              ? vehicle.vehicleNumber
              : 'default');
    if (_lastLoadedVehicleId != keyId) {
      _fetchEmergencyContacts(vehicle);
    }
  }

  Future<void> _fetchEmergencyContacts(VehicleControlEntity vehicle) async {
    final keyId = vehicle.id.isNotEmpty
        ? vehicle.id
        : (vehicle.vehicleNumber.isNotEmpty
              ? vehicle.vehicleNumber
              : 'default');
    _lastLoadedVehicleId = keyId;

    final raw = await AppPreference.instance.get(
      key: "emergency_contacts_$keyId",
    );
    if (raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as List;
        if (mounted) {
          setState(() {
            _contacts = decoded
                .map((item) => Map<String, String>.from(item))
                .toList();
          });
        }
      } catch (e) {
        debugPrint("Error parsing emergency contacts: $e");
      }
    }

    final userId = await AppPreference.instance.get(
      key: AppPreference.KEY_USER_ID,
    );
    final targetVehicleId = vehicle.id.isNotEmpty ? vehicle.id : keyId;

    final url = "${ApiURL.addEmergencyNumber}?userId=$userId&vehicleId=$targetVehicleId";
    final apiService = NetworkApiService();
    final result = await apiService.getGetApiResponse(url);

    result.fold(
      (failure) {
        debugPrint("Error fetching emergency contacts: ${failure.message}");
      },
      (data) {
        try {
          List dynamicList = [];
          if (data is List) {
            dynamicList = data;
          } else if (data is Map) {
            if (data['data'] is List) {
              dynamicList = data['data'];
            } else if (data['emergencyNumbers'] is List) {
              dynamicList = data['emergencyNumbers'];
            } else if (data['contacts'] is List) {
              dynamicList = data['contacts'];
            } else if (data['result'] is List) {
              dynamicList = data['result'];
            }
          }

          final List<Map<String, String>> fetchedContacts = [];
          for (final item in dynamicList) {
            if (item is Map) {
              final itemVehicleId = item['vehicleId']?.toString() ?? '';
              if (itemVehicleId.isEmpty || itemVehicleId == vehicle.id || itemVehicleId == keyId) {
                final name = item['name']?.toString() ?? '';
                final countryCode = item['countryCode']?.toString() ?? '+91';
                final mobileNumber = item['mobileNumber']?.toString() ?? item['phone']?.toString() ?? '';

                String phoneStr = mobileNumber;
                if (countryCode.isNotEmpty && !mobileNumber.startsWith('+')) {
                  phoneStr = '$countryCode $mobileNumber';
                }

                if (name.isNotEmpty || mobileNumber.isNotEmpty) {
                  fetchedContacts.add({
                    'id': item['_id']?.toString() ?? item['id']?.toString() ?? '',
                    'name': name,
                    'phone': phoneStr,
                    'countryCode': countryCode,
                    'mobileNumber': mobileNumber,
                  });
                }
              }
            }
          }

          if (mounted) {
            setState(() {
              _contacts = fetchedContacts;
            });
            _saveEmergencyContacts(keyId);
          }
        } catch (e) {
          debugPrint("Error parsing emergency contacts API response: $e");
        }
      },
    );
  }

  Future<void> _saveEmergencyContacts(String keyId) async {
    final raw = jsonEncode(_contacts);
    await AppPreference.instance.set(
      key: "emergency_contacts_$keyId",
      value: raw,
    );
  }

  void _confirmAndDeleteContact(
    BuildContext context,
    Map<String, String> contact,
    VehicleControlEntity vehicle,
  ) {
    final theme = Theme.of(context);
    final contactId = contact['id'] ?? '';

    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isDeleting = false;
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.dialogBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Delete Emergency Contact',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Are you sure you want to delete ${contact['name'] ?? 'this contact'}?',
              ),
              actions: [
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                  onPressed: isDeleting
                      ? null
                      : () async {
                          setDialogState(() {
                            isDeleting = true;
                          });

                          final keyId = vehicle.id.isNotEmpty
                              ? vehicle.id
                              : (vehicle.vehicleNumber.isNotEmpty
                                    ? vehicle.vehicleNumber
                                    : 'default');

                          if (contactId.isNotEmpty) {
                            final url = "${ApiURL.addEmergencyNumber}/$contactId";
                            final apiService = NetworkApiService();
                            final result = await apiService.getDeleteApiResponse(url, {});

                            result.fold(
                              (failure) {
                                setDialogState(() {
                                  isDeleting = false;
                                });
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(failure.message),
                                      backgroundColor: theme.colorScheme.error,
                                    ),
                                  );
                                }
                              },
                              (data) {
                                if (mounted) {
                                  setState(() {
                                    _contacts.remove(contact);
                                  });
                                  _saveEmergencyContacts(keyId);
                                  _fetchEmergencyContacts(vehicle);
                                }
                                if (dialogContext.mounted) {
                                  Navigator.pop(dialogContext);
                                }
                              },
                            );
                          } else {
                            if (mounted) {
                              setState(() {
                                _contacts.remove(contact);
                              });
                              _saveEmergencyContacts(keyId);
                            }
                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }
                          }
                        },
                  child: isDeleting
                      ? const SizedBox(
                          width: 48,
                          height: 20,
                          child: Center(
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        )
                      : const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddContactDialog(
    BuildContext context,
    String keyId, {
    Map<String, String>? initialContact,
    int? editIndex,
    String? vehicleId,
    VehicleControlEntity? currentVehicle,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    String selectedPhoneCode = '+91';
    String rawPhone = initialContact?['phone'] ?? '';
    if (rawPhone.startsWith('+')) {
      for (final c in _countries) {
        if (c.phoneCode.isNotEmpty) {
          final code = c.phoneCode.startsWith('+') ? c.phoneCode : '+${c.phoneCode}';
          if (rawPhone.startsWith(code)) {
            selectedPhoneCode = code;
            rawPhone = rawPhone.substring(code.length).trim();
            break;
          }
        }
      }
      if (rawPhone.startsWith('+91')) {
        selectedPhoneCode = '+91';
        rawPhone = rawPhone.substring(3).trim();
      }
    }

    final nameController = TextEditingController(text: initialContact?['name'] ?? '');
    final phoneController = TextEditingController(text: rawPhone);
    final phoneFocusNode = FocusNode();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        bool isSaving = false;
        return StatefulBuilder(
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
                    editIndex != null
                        ? l10n.emergencyContacts
                        : "Add Emergency Contact",
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
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (_) {
                      phoneFocusNode.requestFocus();
                    },
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    onChanged: (_) {
                      setStateDialog(() {});
                    },
                    decoration: InputDecoration(
                      labelText: l10n.name,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
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
                    focusNode: phoneFocusNode,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    maxLength: 10,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    buildCounter: (context, {required int currentLength, required bool isFocused, required int? maxLength}) => null,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    onChanged: (_) {
                      setStateDialog(() {});
                    },
                    decoration: InputDecoration(
                      labelText: l10n.mobileNumber,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
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
                                  formKey.currentState?.validate();
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
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (formKey.currentState?.validate() ?? false) {
                                  setStateDialog(() {
                                    isSaving = true;
                                  });

                                  final name = nameController.text.trim();
                                  final mobileNumber = phoneController.text.trim();
                                  final countryCode = selectedPhoneCode;
                                  final userId = await AppPreference.instance.get(
                                    key: AppPreference.KEY_USER_ID,
                                  );
                                  final targetVehicleId =
                                      (vehicleId != null && vehicleId.isNotEmpty)
                                          ? vehicleId
                                          : keyId;

                                  final apiService = NetworkApiService();
                                  final contactId = initialContact?['id'] ?? '';
                                  final isEdit = contactId.isNotEmpty;
                                  
                                  final payload = {
                                    "userId": userId,
                                    "vehicleId": targetVehicleId,
                                    "name": name,
                                    "countryCode": countryCode,
                                    "mobileNumber": mobileNumber,
                                  };

                                  final result = isEdit 
                                      ? await apiService.getPutApiResponse(
                                          "${ApiURL.addEmergencyNumber}/$contactId",
                                          payload,
                                        )
                                      : await apiService.getPostApiResponse(
                                          ApiURL.addEmergencyNumber,
                                          payload,
                                        );

                                  result.fold(
                                    (failure) {
                                      setStateDialog(() {
                                        isSaving = false;
                                      });
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(failure.message),
                                            backgroundColor: theme.colorScheme.error,
                                          ),
                                        );
                                      }
                                    },
                                    (data) {
                                      final newContact = {
                                        'name': name,
                                        'phone': '$countryCode $mobileNumber',
                                        'countryCode': countryCode,
                                        'mobileNumber': mobileNumber,
                                      };
                                      if (isEdit) {
                                        newContact['id'] = contactId;
                                      }
                                      setState(() {
                                        if (editIndex != null &&
                                            editIndex < _contacts.length) {
                                          _contacts[editIndex] = newContact;
                                        } else {
                                          _contacts.add(newContact);
                                        }
                                      });
                                      _saveEmergencyContacts(keyId);
                                      if (currentVehicle != null) {
                                        _fetchEmergencyContacts(currentVehicle);
                                      }
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
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
      );
    },
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
    final secondaryTextColor = colorScheme.onSurface.withValues(alpha: 0.6);

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

            final garageState = context.read<MyGarageCubit>().state;
            bool wasLastVehicle = false;
            if (garageState is VehiclesLoaded) {
               wasLastVehicle = garageState.vehicles.length <= 1;
            } else {
               final mapState = context.read<MapCubit>().state;
               if (mapState is MapLoaded) {
                  wasLastVehicle = (mapState.vehicleList.vehicles?.length ?? 0) <= 1;
               }
            }

            if (wasLastVehicle) {
               Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                 MaterialPageRoute(
                   builder: (context) => const ChoiceSelector(),
                 ),
                 (route) => false,
               );
            } else {
               Navigator.pop(context);
            }
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
                          titlePadding: const EdgeInsets.only(left: 48, bottom: 16, right: 16),
                          title: IgnorePointer(
                            child: AnimatedOpacity(
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
                                      bgColor.withValues(alpha: 0.8),
                                      bgColor,
                                    ],
                                  ),
                                ),
                              ),
                                Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(
                                      onTap: () => _showImageSourceDialog(
                                        context,
                                        vehicle.id,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withValues(alpha: 0.2),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                vehicle.vehicleName.isNotEmpty
                                    ? vehicle.vehicleName
                                    : (widget.passedVehicle != null &&
                                              ("${widget.passedVehicle!.vehicleMaker ?? ''} ${widget.passedVehicle!.vehicleModel ?? ''}"
                                                      .trim())
                                                  .isNotEmpty
                                          ? "${widget.passedVehicle!.vehicleMaker ?? ''} ${widget.passedVehicle!.vehicleModel ?? ''}"
                                                .trim()
                                          : l10n.vehicleDetailsLabel),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: primaryTextColor,
                                  letterSpacing: 0.5,
                                ),
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
                                          .withValues(alpha: 0.1),
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
                                    vehicle.imei,
                                    vehicle.tankCapacity,
                                    vehicle.id,
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
                                    vehicle.imei,
                                    vehicle.vehicleMileage,
                                    vehicle.id,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (!widget.isFromGarage &&
                            vehicle.imei.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          LockCard(
                            cardColor: cardColor,
                            primaryTextColor: primaryTextColor,
                            secondaryTextColor: secondaryTextColor,
                            isLocked: vehicle.vehicleLock,
                            onLock: () async {
                              final brandAndModel = [
                                vehicle.vehicleMaker,
                                vehicle.vehicleModel,
                              ].where((s) => s.isNotEmpty).join(' ');

                              final success = await VehiclePinDialog.show(
                                context,
                                vehicle.vehicleLock,
                                brandAndModel.isNotEmpty
                                    ? brandAndModel
                                    : 'Vehicle',
                                vehicle.imei,
                              );
                              if (success) {
                                if (context.mounted) {
                                  context
                                      .read<VehicleControlCubit>()
                                      .updateVehicleLock(
                                        vehicle.id,
                                        !vehicle.vehicleLock,
                                      );
                                }
                              } else {
                                // Force a fake state update in cubit to reset the button state
                                // since we canceled. The quickest way is to just let the user tap the X,
                                // or we can refresh the list. We will just load current vehicle details to refresh.
                                if (context.mounted) {
                                  context
                                      .read<VehicleControlCubit>()
                                      .loadVehicleDetails(vehicle.id, vehicle.imei);
                                }
                              }
                            },
                            onInfoTap: () => _showSleepModeDialog(context),
                          ),
                        ],

                        const SizedBox(height: 12),

                        VehicleOnMapCard(
                          cardColor: cardColor,
                          primaryTextColor: primaryTextColor,
                          secondaryTextColor: secondaryTextColor,
                          accentColor: theme.colorScheme.primary,
                          selectedIcon: state.tempIcon,
                          selectedColor: state.tempColor,
                          vehicleType: vehicle.vehicleType,
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

                        if ((widget.passedVehicle?.imei?.trim().isNotEmpty ?? false) ||
                            (vehicle.imei.isNotEmpty && vehicle.imei != vehicle.id)) ...[
                          const SizedBox(height: 12),

                          JourneyCard(
                            cardColor: cardColor,
                            primaryTextColor: primaryTextColor,
                            secondaryTextColor: secondaryTextColor,
                            distance: state.journeyDistance,
                            hours: state.journeyHours,
                            minutes: state.journeyMinutes,
                            onTap: () {
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                              AppNavigation.setIndex(2);
                            },
                          ),
                        ],

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
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                        ),

                        if (widget.isFromGarage == false)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationControlsScreen(
                                    passedImei: vehicle.imei.isNotEmpty
                                        ? vehicle.imei
                                        : null,
                                  ),
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
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
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
                                BlocBuilder<AppCubit, AppState>(
                                  builder: (context, appState) {
                                    return Text(
                                      l10n.unmapStep1(appState.companyMobileNumber.isNotEmpty ? appState.companyMobileNumber : ''),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: secondaryTextColor,
                                        height: 1.4,
                                      ),
                                    );
                                  },
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
                                          .withValues(alpha: 0.6),
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
                                  ..._contacts.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final contact = entry.value;
                                    final name = contact['name'] ?? '';
                                    final phone = contact['phone'] ?? '';
                                    return GestureDetector(
                                      onTap: () {
                                        final keyId = vehicle.id.isNotEmpty
                                            ? vehicle.id
                                            : (vehicle.vehicleNumber.isNotEmpty
                                                  ? vehicle.vehicleNumber
                                                  : 'default');
                                        _showAddContactDialog(
                                          context,
                                          keyId,
                                          initialContact: contact,
                                          editIndex: index,
                                          vehicleId: vehicle.id,
                                          currentVehicle: vehicle,
                                        );
                                      },
                                      child: Container(
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
                                                .withValues(alpha: 0.08),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor: theme
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.1),
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
                                                    .withValues(alpha: 0.8),
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                _confirmAndDeleteContact(
                                                  context,
                                                  contact,
                                                  vehicle,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
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
                                      _showAddContactDialog(
                                        context,
                                        keyId,
                                        vehicleId: vehicle.id,
                                        currentVehicle: vehicle,
                                      );
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
                            color: theme.colorScheme.onSurface.withValues(alpha: 
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
              title: Text(l10n.camera),
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
              title: Text(l10n.gallery),
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
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<VehicleControlCubit>();
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: l10n.cropImageTitle,
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(title: l10n.cropImageTitle),
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
    String vehicleId,
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
      builder: (context) {
        bool isLoadingDefault = false;
        return StatefulBuilder(
          builder: (context, setStateDialog) => Dialog(
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
                      Expanded(
                        child: Text(
                          l10n.tankCapacity,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: l10n.tankCapacityHint,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
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
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  if (vehicleId.isNotEmpty)
                    isLoadingDefault
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : TextButton(
                            onPressed: () async {
                              setStateDialog(() => isLoadingDefault = true);
                              final data = await cubit.fetchDefaultVehicleModelDetails(vehicleId);
                              setStateDialog(() => isLoadingDefault = false);
                              if (data != null && data['tankCapacity'] != null) {
                                String cap = data['tankCapacity'].toString().replaceAll(RegExp(r'[^0-9.]'), '');
                                controller.text = cap;
                              }
                            },
                            child: Text(
                              "Default",
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
      },
    );
  }

  void _showMileageDialog(
    BuildContext context,
    String vehicleIMEI,
    String currentVal,
    String vehicleId,
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
      builder: (context) {
        bool isLoadingDefault = false;
        return StatefulBuilder(
          builder: (context, setStateDialog) => Dialog(
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
                      Expanded(
                        child: Text(
                          l10n.vehicleMileage,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: l10n.mileageHint,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
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
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  if (vehicleId.isNotEmpty)
                    isLoadingDefault
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : TextButton(
                            onPressed: () async {
                              setStateDialog(() => isLoadingDefault = true);
                              final data = await cubit.fetchDefaultVehicleModelDetails(vehicleId);
                              setStateDialog(() => isLoadingDefault = false);
                              if (data != null && data['mileage'] != null) {
                                String mil = data['mileage'].toString().replaceAll(RegExp(r'[^0-9.]'), '');
                                controller.text = mil;
                              }
                            },
                            child: Text(
                              "Default",
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
      },
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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.sleepModeDesc2,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
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
            child: Text(l10n.cancel),
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
