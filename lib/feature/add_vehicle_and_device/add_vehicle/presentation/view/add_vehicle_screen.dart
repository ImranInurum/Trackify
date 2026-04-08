import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../onboarding/presentation/cubit/splash_cubit.dart';
import '../../../../onboarding/presentation/cubit/splash_state.dart';
import '../cubit/add_vehicle_cubit.dart';
import '../cubit/add_vehicle_state.dart';
import '../../../../../core/utils/shared_preferences.dart';
import '../../../../../app/app_navigation.dart';

// ─── Data models ─────────────────────────────────────────────────────────────

enum VehicleType { twoWheeler, fourWheeler, autoRickshaw, heavyVehicle }

enum FuelType { petrol, electric }

// ─── Screen ──────────────────────────────────────────────────────────────────

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  VehicleType _selectedVehicleType = VehicleType.twoWheeler;
  FuelType _selectedFuelType = FuelType.petrol;

  String? _selectedMake;
  String? _selectedModel;

  final _vehicleNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // ── Sample data (replace with API data later) ──────────────────────────────
  final List<String> _vehicleMakes = [
    'Honda',
    'Hero',
    'Bajaj',
    'TVS',
    'Yamaha',
    'Suzuki',
  ];

  final Map<String, List<String>> _vehicleModels = {
    'Honda': ['SP 125', 'Activa 6G', 'CB Shine', 'Unicorn'],
    'Hero': ['Splendor Plus', 'HF Deluxe', 'Passion Pro', 'Xtreme 160R'],
    'Bajaj': ['Pulsar 150', 'CT 110', 'Platina 110', 'Avenger Street 160'],
    'TVS': ['Apache RTR 160', 'Star City+', 'Jupiter', 'Ntorq 125'],
    'Yamaha': ['FZ-S FI', 'R15 V4', 'MT-15', 'Fascino 125'],
    'Suzuki': ['Access 125', 'Gixxer 150', 'Intruder 150', 'Avenis 125'],
  };

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

  // ─── Logo (same SplashCubit pattern as all auth screens) ───────────────────
  Widget _buildLogo(SplashState state, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child:
            (state is SplashLoaded &&
                state.logo.path != null &&
                state.logo.path!.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: state.logo.path!,
                height: 140,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                errorWidget: (context, url, error) => Icon(
                  Icons.track_changes_rounded,
                  size: 56,
                  color: colorScheme.primary,
                ),
              )
            : Icon(Icons.track_changes_rounded, size: 56, color: colorScheme.primary),
      ),
    );
  }

  // ─── Vehicle-type circular chip ────────────────────────────────────────────
  Widget _buildVehicleTypeItem({
    required VehicleType type,
    required IconData icon,
    required String label,
  }) {
    final bool selected = _selectedVehicleType == type;
    const Color active = AppColors.secondaryLight;
    const Color inactive = Color(0xFFAAAAAA);

    return GestureDetector(
      onTap: () => setState(() => _selectedVehicleType = type),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? active : inactive,
                width: selected ? 2 : 1.5,
              ),
              color: selected ? active.withValues(alpha: 0.06) : Colors.transparent,
            ),
            child: Icon(icon, color: selected ? active : inactive, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: selected ? active : inactive,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── Fuel-type circular chip ───────────────────────────────────────────────
  Widget _buildFuelTypeItem({
    required FuelType type,
    required IconData icon,
    required String label,
  }) {
    final bool selected = _selectedFuelType == type;
    const Color active = AppColors.secondaryLight;
    const Color inactive = Color(0xFFAAAAAA);

    return GestureDetector(
      onTap: () => setState(() => _selectedFuelType = type),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? active : inactive,
                width: selected ? 2 : 1.5,
              ),
              color: selected ? active.withValues(alpha: 0.06) : Colors.transparent,
            ),
            child: Icon(icon, color: selected ? active : inactive, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: selected ? active : inactive,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── Labelled dropdown ─────────────────────────────────────────────────────
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                'Select $label',
                style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.secondaryLight),
              items: items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 14)),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Section label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
    ),
  );

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Vehicle/Device',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocListener<AddVehicleCubit, AddVehicleState>(
        listener: (context, state) {
          if (state is AddVehicleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vehicle added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Mark setup as complete in SharedPreferences
            AppPreference.instance.setBool(key: AppPreference.KEY_SETUP_COMPLETE, value: true);
            
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AppNavigation()),
                (route) => false,
              );
            }
          } else if (state is AddVehicleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Logo ─────────────────────────────────────────────────
                      BlocBuilder<SplashCubit, SplashState>(
                        builder: (context, splashState) =>
                            _buildLogo(splashState, colorScheme),
                      ),

                      const SizedBox(height: 8),

                      // ── Vehicle Type ──────────────────────────────────────────
                      _sectionLabel('Vehicle Type'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildVehicleTypeItem(
                            type: VehicleType.twoWheeler,
                            icon: Icons.two_wheeler_rounded,
                            label: 'Two Wheeler',
                          ),
                          _buildVehicleTypeItem(
                            type: VehicleType.fourWheeler,
                            icon: Icons.directions_car_rounded,
                            label: 'Four Wheeler',
                          ),
                          _buildVehicleTypeItem(
                            type: VehicleType.autoRickshaw,
                            icon: Icons.electric_rickshaw_rounded,
                            label: 'Auto Rickshaw',
                          ),
                          _buildVehicleTypeItem(
                            type: VehicleType.heavyVehicle,
                            icon: Icons.local_shipping_rounded,
                            label: 'Heavy Vehicle',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Fuel Type ─────────────────────────────────────────────
                      _sectionLabel('Fuel Type'),
                      Row(
                        children: [
                          _buildFuelTypeItem(
                            type: FuelType.petrol,
                            icon: Icons.water_drop_rounded,
                            label: 'Petrol',
                          ),
                          const SizedBox(width: 24),
                          _buildFuelTypeItem(
                            type: FuelType.electric,
                            icon: Icons.bolt_rounded,
                            label: 'Electric',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Vehicle Make ──────────────────────────────────────────
                      _buildDropdown(
                        label: 'Vehicle Make',
                        value: _selectedMake,
                        items: _vehicleMakes,
                        onChanged: (val) => setState(() {
                          _selectedMake = val;
                          _selectedModel = null; // reset model when make changes
                        }),
                      ),

                      const SizedBox(height: 20),

                      // ── Vehicle Model ─────────────────────────────────────────
                      _buildDropdown(
                        label: 'Vehicle Model',
                        value: _selectedModel,
                        items: _selectedMake != null
                            ? (_vehicleModels[_selectedMake] ?? [])
                            : [],
                        onChanged: (val) => setState(() => _selectedModel = val),
                      ),

                      const SizedBox(height: 20),

                      // ── Vehicle Number ────────────────────────────────────────
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Vehicle number',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.secondaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _vehicleNumberController,
                            textCapitalization: TextCapitalization.characters,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimaryLight,
                              letterSpacing: 1.2,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. MP46MX0743',
                              hintStyle: const TextStyle(
                                color: Color(0xFFAAAAAA),
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.secondaryLight,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter vehicle number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // ── Submit Button ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                child: SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: BlocBuilder<AddVehicleCubit, AddVehicleState>(
                    builder: (context, state) {
                      final isLoading = state is AddVehicleLoading;
                      return ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final vType = switch (_selectedVehicleType) {
                                    VehicleType.twoWheeler => 'Bike',
                                    VehicleType.fourWheeler => 'Car',
                                    VehicleType.autoRickshaw => 'Auto Rickshaw',
                                    VehicleType.heavyVehicle => 'Heavy Vehicle',
                                  };

                                  final fType = switch (_selectedFuelType) {
                                    FuelType.petrol => 'Petrol',
                                    FuelType.electric => 'Electric',
                                  };

                                  context.read<AddVehicleCubit>().addVehicle(
                                        vehicleType: vType,
                                        fuelType: fType,
                                        vehicleMaker: _selectedMake ?? '',
                                        vehicleNumber: _vehicleNumberController.text.trim(),
                                        vehicleModel: _selectedModel ?? '',
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          backgroundColor: AppColors.secondaryLight,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          disabledBackgroundColor: AppColors.secondaryLight.withValues(alpha: 0.6),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Add Vehicle/Device',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
