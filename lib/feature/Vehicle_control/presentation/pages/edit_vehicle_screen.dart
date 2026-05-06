import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/vehicle_control_entity.dart';
import '../cubit/vehicle_control_cubit.dart';

class EditVehicleScreen extends StatefulWidget {
  final VehicleControlEntity vehicle;

  const EditVehicleScreen({super.key, required this.vehicle});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  late String selectedType;
  late String selectedFuel;
  late TextEditingController numberController;
  String selectedMake = "Honda";
  String selectedModel = "SP 125";

  List<Map<String, dynamic>> _getVehicleTypes(AppLocalizations l10n) => [
    {"key": "twoWheeler", "label": l10n.twoWheeler, "icon": Icons.motorcycle_outlined},
    {"key": "fourWheeler", "label": l10n.fourWheeler, "icon": Icons.directions_car_outlined},
    {"key": "autoRickshaw", "label": l10n.autoRickshaw, "icon": Icons.electric_rickshaw_outlined},
    {"key": "heavyVehicle", "label": l10n.heavyVehicle, "icon": Icons.local_shipping_outlined},
  ];

  List<Map<String, dynamic>> _getAvailableFuelTypes(AppLocalizations l10n) {
    final List<Map<String, dynamic>> allFuelTypes = [
      {"key": "petrol", "label": l10n.petrol, "icon": Icons.local_gas_station_outlined},
      {"key": "diesel", "label": l10n.diesel, "icon": Icons.local_gas_station_outlined},
      {"key": "electric", "label": l10n.electric, "icon": Icons.electric_bolt_outlined},
      {"key": "cng", "label": l10n.cng, "icon": Icons.gas_meter_outlined},
    ];

    if (selectedType == "twoWheeler") {
      return allFuelTypes.where((f) => f['key'] == "petrol" || f['key'] == "electric").toList();
    } else if (selectedType == "heavyVehicle") {
      return allFuelTypes.where((f) => f['key'] != "cng").toList();
    } else if (selectedType == "autoRickshaw") {
      return allFuelTypes.where((f) => f['key'] != "diesel").toList();
    }
    
    return allFuelTypes;
  }

  @override
  void initState() {
    super.initState();
    selectedType = "twoWheeler";
    selectedFuel = widget.vehicle.fuelType.toLowerCase(); // Ensure it matches our keys
    numberController = TextEditingController(text: widget.vehicle.vehicleNumber);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    
    final vehicleTypes = _getVehicleTypes(l10n);
    final availableFuels = _getAvailableFuelTypes(l10n);

    // Ensure selectedFuel is still valid for the new type
    if (!availableFuels.any((f) => f['key'] == selectedFuel)) {
      selectedFuel = availableFuels.first['key'];
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.editVehicle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(l10n.vehicleType),
            const SizedBox(height: 16),
            _buildHorizontalSelection(
              items: vehicleTypes,
              selectedKey: selectedType,
              onSelect: (val) => setState(() => selectedType = val),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle(l10n.fuelType),
            const SizedBox(height: 16),
            _buildHorizontalSelection(
              items: availableFuels,
              selectedKey: selectedFuel,
              onSelect: (val) => setState(() => selectedFuel = val),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle(l10n.vehicleMake),
            const SizedBox(height: 12),
            _buildDropdown(
              value: selectedMake,
              items: ["Honda", "Hero", "Suzuki", "Yamaha"],
              onChanged: (val) => setState(() => selectedMake = val!),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(l10n.vehicleModel),
            const SizedBox(height: 12),
            _buildDropdown(
              value: selectedModel,
              items: ["SP 125", "Shine", "Unicorn", "Activa"],
              onChanged: (val) => setState(() => selectedModel = val!),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(l10n.vehicleNumber),
            const SizedBox(height: 12),
            _buildTextField(numberController, l10n.vehicleNumberHint),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.read<VehicleControlCubit>().updateVehicleDetails(
                        widget.vehicle.id,
                        "${selectedMake} ${selectedModel}",
                        numberController.text,
                        selectedFuel,
                      );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  l10n.updateVehicle,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        color: theme.colorScheme.onSurface.withOpacity(0.6),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildHorizontalSelection({
    required List<Map<String, dynamic>> items,
    required String selectedKey,
    required Function(String) onSelect,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Wrap(
      spacing: 20,
      runSpacing: 16,
      children: items.map((item) {
        final isSelected = item['key'] == selectedKey;

        return GestureDetector(
          onTap: () => onSelect(item['key']),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? primaryColor : theme.colorScheme.onSurface.withOpacity(0.1),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    item['icon'],
                    color: isSelected ? primaryColor : theme.colorScheme.onSurface.withOpacity(0.3),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['label'],
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? primaryColor : theme.colorScheme.onSurface.withOpacity(0.4),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.onSurface.withOpacity(0.05) : theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: theme.cardColor,
          icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.onSurface.withOpacity(0.05) : theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.3)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
