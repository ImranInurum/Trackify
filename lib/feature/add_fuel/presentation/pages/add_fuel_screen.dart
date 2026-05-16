import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trackify/feature/add_fuel/domain/entities/add_fuel_entity.dart';
import 'package:trackify/feature/add_fuel/presentation/cubit/add_fuel_cubit.dart';
import 'package:trackify/feature/add_fuel/presentation/cubit/add_fuel_state.dart';
import 'package:trackify/feature/fuel_logs/presentation/pages/fuel_station_screen.dart';
import 'package:trackify/l10n/app_localizations.dart';

import 'package:trackify/feature/fuel_logs/presentation/cubit/fuel_logs_cubit.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_cubit.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_state.dart';
import 'package:trackify/feature/service_logs/presentation/widgets/vehicle_selection_app_bar.dart';

class AddFuelScreen extends StatefulWidget {
  const AddFuelScreen({super.key});

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



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
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
            onPressed: (isFullTankSelected || isPartialTankSelected)
                ? () {
                    final combinedDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );

                    final entity = AddFuelEntity(
                      vehicle: 'SP 125',
                      dateTime: combinedDateTime,
                      fuelStation: 'C.M. Petro Point',
                      odometer: int.parse(
                        odometerController.text,
                      ),
                      amount: double.parse(
                        amountController.text,
                      ),
                      pricePerLitre: double.parse(
                        priceController.text,
                      ),
                      fullTank: isFullTankSelected,
                    );

                    context.read<AddFuelCubit>().saveFuel(entity);
                  }
                : null,
            child: Text(
              l10n.save,
              style: TextStyle(
                fontSize: 20,
                color: (isFullTankSelected || isPartialTankSelected) 
                    ? colorScheme.onPrimary 
                    : colorScheme.onSurface.withOpacity(0.38),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: BlocListener<
            AddFuelCubit,
            AddFuelState>(
          listener: (context, state) {

            if (state is AddFuelSuccess) {

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.savedSuccessfully,
                  ),
                ),
              );
            }
          },

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
                      icon: const Icon(
                        Icons.arrow_back,
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
                              context.read<FuelLogsCubit>().loadFuelLogs();
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FuelStationScreen(),
                            ),
                          );
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
                                child: Text(
                                  l10n.fuelStationName,
                                   style: TextStyle(
                                    color: colorScheme.secondary,
                                    fontSize: 16,
                                  ),
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
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
                        decoration:
                        _inputDecoration(
                          ('32857'),
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
                                  decoration:
                                  _inputDecoration(
                                    ('700.00'),
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
                                  decoration:
                                  _inputDecoration(
                                    ('106.54'),
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

                      Row(
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

          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
