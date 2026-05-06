import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  final List<Map<String, dynamic>> vehicleTypes = [
    {"label": "Two Wheeler", "icon": Icons.motorcycle_outlined},
    {"label": "Four Wheeler", "icon": Icons.directions_car_outlined},
    {"label": "Auto Rickshaw", "icon": Icons.electric_rickshaw_outlined},
    {"label": "Heavy Vehicle", "icon": Icons.local_shipping_outlined},
  ];

  List<Map<String, dynamic>> getAvailableFuelTypes() {
    final List<Map<String, dynamic>> allFuelTypes = [
      {"label": "Petrol", "icon": Icons.local_gas_station_outlined},
      {"label": "Diesel", "icon": Icons.local_gas_station_outlined},
      {"label": "Electric", "icon": Icons.electric_bolt_outlined},
      {"label": "CNG", "icon": Icons.gas_meter_outlined},
    ];

    if (selectedType == "Two Wheeler") {
      return allFuelTypes.where((f) => f['label'] == "Petrol" || f['label'] == "Electric").toList();
    } else if (selectedType == "Heavy Vehicle") {
      return allFuelTypes.where((f) => f['label'] != "CNG").toList();
    } else if (selectedType == "Auto Rickshaw") {
      // Assuming Auto Rickshaw has Petrol, Electric, CNG (based on common knowledge/screenshots)
      return allFuelTypes.where((f) => f['label'] != "Diesel").toList();
    }
    
    // Four Wheeler has all
    return allFuelTypes;
  }

  @override
  void initState() {
    super.initState();
    selectedType = "Two Wheeler";
    selectedFuel = widget.vehicle.fuelType;
    numberController = TextEditingController(text: widget.vehicle.vehicleNumber);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final availableFuels = getAvailableFuelTypes();

    // Ensure selectedFuel is still valid for the new type
    if (!availableFuels.any((f) => f['label'] == selectedFuel)) {
      selectedFuel = availableFuels.first['label'];
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
          "Edit Vehicle",
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
            _buildSectionTitle("Vehicle Type"),
            const SizedBox(height: 16),
            _buildHorizontalSelection(
              items: vehicleTypes,
              selectedLabel: selectedType,
              onSelect: (val) => setState(() => selectedType = val),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle("Fuel Type"),
            const SizedBox(height: 16),
            _buildHorizontalSelection(
              items: availableFuels,
              selectedLabel: selectedFuel,
              onSelect: (val) => setState(() => selectedFuel = val),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle("Vehicle Make"),
            const SizedBox(height: 12),
            _buildDropdown(
              value: selectedMake,
              items: ["Honda", "Hero", "Suzuki", "Yamaha"],
              onChanged: (val) => setState(() => selectedMake = val!),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Vehicle Model"),
            const SizedBox(height: 12),
            _buildDropdown(
              value: selectedModel,
              items: ["SP 125", "Shine", "Unicorn", "Activa"],
              onChanged: (val) => setState(() => selectedModel = val!),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Vehicle number"),
            const SizedBox(height: 12),
            _buildTextField(numberController, "e.g. MP09QV8269"),
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
                child: const Text(
                  "Update Vehicle",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    required String selectedLabel,
    required Function(String) onSelect,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Wrap(
      spacing: 20,
      runSpacing: 16,
      children: items.map((item) {
        final isSelected = item['label'] == selectedLabel;

        return GestureDetector(
          onTap: () => onSelect(item['label']),
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
