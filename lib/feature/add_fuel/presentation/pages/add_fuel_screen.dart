import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trackify/feature/add_fuel/domain/entities/add_fuel_entity.dart';
import 'package:trackify/feature/add_fuel/presentation/cubit/add_fuel_cubit.dart';
import 'package:trackify/feature/add_fuel/presentation/cubit/add_fuel_state.dart';
import 'package:trackify/feature/fuel_logs/presentation/pages/fuel_station_screen.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/feature/fuel_logs/data/repository/overpass_service.dart';
import 'package:geolocator/geolocator.dart';

import 'package:trackify/feature/fuel_logs/presentation/cubit/fuel_logs_cubit.dart';
import 'package:trackify/feature/fuel_logs/presentation/cubit/fuel_logs_state.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_cubit.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_state.dart';
import 'package:trackify/feature/service_logs/presentation/widgets/vehicle_selection_app_bar.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';

class AddFuelScreen extends StatefulWidget {
  final bool isEditMode;
  final RefuelLog? initialLog;
  const AddFuelScreen({super.key, this.isEditMode = false, this.initialLog});

  @override
  State<AddFuelScreen> createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends State<AddFuelScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  final odometerController =TextEditingController();
  final amountController = TextEditingController();
  final priceController = TextEditingController();
  final fuelBeforeRefuelController = TextEditingController();

  late final l10n = AppLocalizations.of(context)!;
  late final theme = Theme.of(context);
  late final colorScheme = theme.colorScheme;
  late final mediaQuery = MediaQuery.of(context);
  late final screenWidth = mediaQuery.size.width;
  late final screenHeight = mediaQuery.size.height;

  bool isFullTankSelected = false;
  bool isPartialTankSelected = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? selectedFuelStationName;
  bool _isLoadingNearest = false;

  Future<void> _loadNearestFuelStation() async {
    setState(() {
      _isLoadingNearest = true;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      ).timeout(const Duration(seconds: 5));

      final overpassService = OverpassService();
      final stations = await overpassService.fetchNearbyFuelStations(
        position.latitude,
        position.longitude,
      );

      if (stations.isNotEmpty && mounted) {
        setState(() {
          selectedFuelStationName = stations.first.name;
        });
      }
    } catch (e) {
      debugPrint('Error getting nearest station: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingNearest = false;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }



  void _validateForm() {
    setState(() {});
  }

  bool get _isFormValid {
    if (odometerController.text.trim().isEmpty) return false;
    if (amountController.text.trim().isEmpty) return false;
    if (priceController.text.trim().isEmpty) return false;
    if (!isFullTankSelected && !isPartialTankSelected) return false;
    if (isPartialTankSelected && fuelBeforeRefuelController.text.trim().isEmpty) return false;
    return true;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    if (widget.isEditMode && widget.initialLog != null) {
      final log = widget.initialLog!;
      odometerController.text = log.odometer;
      amountController.text = log.amount;
      priceController.text = log.rate;
      _selectedDate = log.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(log.dateTime);
      selectedFuelStationName = log.location;
      isFullTankSelected = true; // Default since not in log model
    } else {
      _loadNearestFuelStation();
    }
    
    odometerController.addListener(_validateForm);
    amountController.addListener(_validateForm);
    priceController.addListener(_validateForm);
    fuelBeforeRefuelController.addListener(_validateForm);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!widget.isEditMode) {
        final serviceState = context.read<ServiceLogsCubit>().state;
        if (serviceState is ServiceLogsLoaded && serviceState.selectedVehicle != null) {
          _autofillOdometer(serviceState.selectedVehicle);
        }
      }
    });
  }

  String _formatOdometer(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null) {
      return parsed.toInt().toString();
    }
    return value;
  }

  void _autofillOdometer(Vehicle? vehicle) {
    if (vehicle == null) return;

    // First priority: Odometer from FuelLogsCubit dashboard state
    final fuelLogsState = context.read<FuelLogsCubit>().state;
    if (fuelLogsState is FuelLogsLoaded) {
      final odo = fuelLogsState.odometerReading;
      if (odo.isNotEmpty && odo != "0" && odo != "null") {
        odometerController.text = _formatOdometer(odo);
        _validateForm();
        return;
      }
    }

    // Second priority: Odometer from AppCubit live devices
    final imei = vehicle.imei;
    final id = vehicle.id;
    final appState = context.read<AppCubit>().state;
    final liveDevice = appState.devices.firstWhere(
      (d) =>
          (imei != null && imei.isNotEmpty && d['imei']?.toString() == imei) ||
          (id != null && id.isNotEmpty && (d['id']?.toString() == id || d['_id']?.toString() == id)),
      orElse: () => <String, dynamic>{},
    );
    if (liveDevice.isNotEmpty && liveDevice['odometer'] != null) {
      final odometerVal = liveDevice['odometer'].toString();
      if (odometerVal.isNotEmpty && odometerVal != "0") {
        odometerController.text = _formatOdometer(odometerVal);
        _validateForm();
        return;
      }
    }
    odometerController.clear();
    _validateForm();
  }

  @override
  void dispose() {
    odometerController.removeListener(_validateForm);
    amountController.removeListener(_validateForm);
    priceController.removeListener(_validateForm);
    fuelBeforeRefuelController.removeListener(_validateForm);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18),
        child: SizedBox(
          height: 58,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
              ),
            ),
            onPressed: _isFormValid
                ? () async {
                    // if (widget.isEditMode) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Update API is currently unavailable')),
                    //   );
                    //   return;
                    // }

                    final combinedDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );

                    final currentServiceState = context.read<ServiceLogsCubit>().state;
                    if (currentServiceState is ServiceLogsLoaded) {
                      final entity = AddFuelEntity(
                        vehicle: currentServiceState.selectedVehicle?.id ?? '',
                        dateTime: combinedDateTime,
                        fuelStation: selectedFuelStationName ?? l10n.fuelStationName,
                        odometer: (double.tryParse(
                          odometerController.text,
                        ) ?? 0).toInt(),
                        amount: double.tryParse(
                          amountController.text,
                        ) ?? 0,
                        pricePerLitre: double.tryParse(
                          priceController.text,
                        ) ?? 0,
                        fullTank: isFullTankSelected?"1":"2",
                        fuelBeforeRefuel: fuelBeforeRefuelController.text
                      );
                      if (widget.isEditMode && widget.initialLog != null) {
                        await context.read<AddFuelCubit>().updateFuel(widget.initialLog!.id, entity);
                      } else {
                        await context.read<AddFuelCubit>().saveFuel(entity);
                      }
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                    }

                  }
                : null,
            child: Text(
              l10n.save,
              style: TextStyle(
                fontSize: 20,
                color: _isFormValid 
                    ? colorScheme.onPrimary 
                    : colorScheme.onSurface.withOpacity(0.38),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<AddFuelCubit, AddFuelState>(
              listener: (context, state) {
                if (state is AddFuelSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.savedSuccessfully,
                      ),
                    ),
                  );
                }
              },
            ),
            BlocListener<AppCubit, AppState>(
              listener: (context, state) {
                if (odometerController.text.trim().isEmpty) {
                  final serviceState = context.read<ServiceLogsCubit>().state;
                  if (serviceState is ServiceLogsLoaded && serviceState.selectedVehicle != null) {
                    _autofillOdometer(serviceState.selectedVehicle);
                  }
                }
              },
            ),
            BlocListener<ServiceLogsCubit, ServiceLogsState>(
              listenWhen: (previous, current) {
                if (previous is ServiceLogsLoaded && current is ServiceLogsLoaded) {
                  return previous.selectedVehicle?.id != current.selectedVehicle?.id;
                }
                return current is ServiceLogsLoaded;
              },
              listener: (context, state) {
                if (state is ServiceLogsLoaded && state.selectedVehicle != null) {
                  _autofillOdometer(state.selectedVehicle);
                }
              },
            ),
            BlocListener<FuelLogsCubit, FuelLogsState>(
              listener: (context, state) {
                if (state is FuelLogsLoaded) {
                  final odo = state.odometerReading;
                  if (odo.isNotEmpty && odo != "0" && odo != "null") {
                    odometerController.text = _formatOdometer(odo);
                    _validateForm();
                  }
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    Text(
                      l10n.addRefuelingDetails,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                BlocBuilder<ServiceLogsCubit, ServiceLogsState>(
                  builder: (context, serviceState) {
                    if (serviceState is ServiceLogsLoaded) {
                      return Column(
                        children: [
                          VehicleSelectionAppBar(
                            isMinimal: true,
                            title: l10n.fuelLogs,
                            selectedVehicle: serviceState.selectedVehicle,
                            vehicles: serviceState.vehicles,
                            onBack: () => Navigator.pop(context),
                            onVehicleSelected: (vehicle) {
                              context.read<ServiceLogsCubit>().selectVehicle(vehicle.id!);
                              context.read<FuelLogsCubit>().loadFuelLogs(vehicle.id ?? '');
                              _autofillOdometer(vehicle);
                            },
                          ),

                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 20),

                _card(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [

                      Row(
                        children: [

                          Expanded(
                            child:
                            GestureDetector(
                              onTap: _selectDate,
                              child: _fieldContainer(
                                title: l10n.date,
                                icon:
                                Icons.calendar_today,
                                value:
                                DateFormat('dd MMM yyyy').format(_selectedDate),
                              ),
                            ),
                          ),

                          const SizedBox(
                              width: 15),

                          Expanded(
                            child:
                            GestureDetector(
                              onTap: _selectTime,
                              child: _fieldContainer(
                                title: l10n.time,
                                icon:
                                Icons.access_time,
                                value:
                                _selectedTime.format(context),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        l10n.fuelStation,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FuelStationScreen(),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              selectedFuelStationName = result;
                            });
                          }
                        },
                        child: Container(
                          height: 60,
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 16,
                          ),
                          decoration:
                          BoxDecoration(
                            color: theme.cardColor,
                            borderRadius:
                            BorderRadius
                                .circular(20),
                            border: Border.all(
                              color: colorScheme.secondary.withOpacity(0.2),
                            ),
                          ),

                          child: Row(
                            children: [

                              Icon(
                                Icons.location_on,
                                color: colorScheme.secondary,
                              ),

                              const SizedBox(
                                  width: 12),

                              Expanded(
                                child: _isLoadingNearest
                                    ? Row(
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: colorScheme.secondary,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Locating nearest...',
                                            style: TextStyle(
                                              color: colorScheme.secondary,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        selectedFuelStationName ?? l10n.fuelStationName,
                                        style: TextStyle(
                                          color: colorScheme.secondary,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                              ),

                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal:
                                  18,
                                  vertical:
                                  8,
                                ),
                                decoration:
                                BoxDecoration(
                                  color: colorScheme.secondaryContainer,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    20,
                                  ),
                                ),
                                child:
                                Text(
                                  l10n.change,
                                  style:
                                  TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _card(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [

                      Text(
                        l10n.currentOdometer,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller:
                        odometerController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration:
                        _inputDecoration(
                          '000',
                          Icons.speed,
                        ),
                      ),

                      const SizedBox(
                          height: 12),

                      Text(
                        l10n.lastRecorded,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                          colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(
                          height: 20),

                      Row(
                        children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [

                                Text(
                                  l10n.totalAmount,
                                  style:
                                  TextStyle(
                                    fontSize:
                                    18,
                                  ),
                                ),

                                const SizedBox(
                                    height:
                                    12),

                                TextField(
                                  controller:
                                  amountController,
                                   keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                   inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                                  decoration:
                                  _inputDecoration(
                                    '000',
                                    Icons
                                        .currency_rupee,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                              width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [

                                Text(
                                  l10n.pricePerLitre,
                                  style:
                                  TextStyle(
                                    fontSize:
                                    18,
                                  ),
                                ),

                                const SizedBox(
                                    height:
                                    12),

                                TextField(
                                  controller:
                                  priceController,
                                   keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                   inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                                  decoration:
                                  _inputDecoration(
                                    '000',
                                    Icons
                                        .currency_rupee,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _card(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [

                      Text(
                        l10n.tankStatus,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 20),

                      BlocBuilder<ServiceLogsCubit, ServiceLogsState>(
                        builder: (context, serviceState) {
                          String? capacity;
                          if (serviceState is ServiceLogsLoaded && serviceState.selectedVehicle != null) {
                            final cap = serviceState.selectedVehicle!.tankCapacity;
                            if (cap != null && cap.trim().isNotEmpty && cap != "null" && cap != "0") {
                              capacity = cap;
                            }
                          }
                          return Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isFullTankSelected = true;
                                      isPartialTankSelected = false;
                                    });
                                  },
                                  child:
                                  _tankOption(
                                    l10n.fullTank,
                                    isFullTankSelected,
                                    subtitle: (isFullTankSelected && capacity != null) ? '$capacity ${l10n.liters}' : null,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isFullTankSelected = false;
                                      isPartialTankSelected = true;
                                    });
                                  },
                                  child:
                                  _tankOption(
                                    l10n.partialTank,
                                    isPartialTankSelected,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      ),

                      if (isPartialTankSelected) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.fuelBeforeRefuel,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: TextField(
                                  controller: fuelBeforeRefuelController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: ('0'),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    filled: true,
                                    fillColor: theme.cardColor,
                                    suffixIcon: Container(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            l10n.liters,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: colorScheme.onSurfaceVariant,
                                              ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      l10n.fuelBeforeRefuelDesc,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: colorScheme.onSurface.withOpacity(0.6),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius:
        BorderRadius.circular(28),
      ),
      child: child,
    );
  }

  Widget _fieldContainer({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          height: 70,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius:
            BorderRadius.circular(
              20,
            ),
          ),

          child: Row(
            children: [

              Icon(
                icon,
                color: colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: 12),

              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
      String hint,
      IconData icon,
      ) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Icon(icon),

      filled: true,
      fillColor: theme.cardColor,

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _tankOption(
      String title,
      bool selected,
      {String? subtitle}
      ) {
    return Container(
      height: 72,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primaryContainer
            : theme.cardColor,
        borderRadius:
        BorderRadius.circular(20),
        border: selected
            ? Border.all(
          color: colorScheme.primary,
          width: 1.5,
        )
            : null,
      ),

      child: Row(
        children: [

          Icon(
            selected
                ? Icons.check_circle
                : Icons.radio_button_off,
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
