import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../cubit/service_logs_cubit.dart';
import '../cubit/service_logs_state.dart';
import '../widgets/vehicle_selection_app_bar.dart';
import '../widgets/image_picker_box.dart';
import '../../../../l10n/app_localizations.dart';

class AddServiceLogScreen extends StatefulWidget {
  const AddServiceLogScreen({super.key});

  @override
  State<AddServiceLogScreen> createState() => _AddServiceLogScreenState();
}

class _AddServiceLogScreenState extends State<AddServiceLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _centerNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _noteController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  List<File> _billImages = [];

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _centerNameController.dispose();
    _contactController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    if (_billImages.length >= 2) return;

    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _billImages.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _billImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocConsumer<ServiceLogsCubit, ServiceLogsState>(
        listener: (context, state) {
          if (state is ServiceLogsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Service log added successfully")),
            );
            Navigator.pop(context);
          }
          if (state is ServiceLogsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is! ServiceLogsLoaded && state is! ServiceLogsSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentState = state is ServiceLogsLoaded 
              ? state 
              : (context.read<ServiceLogsCubit>().state as ServiceLogsLoaded);

          return Column(
            children: [
              VehicleSelectionAppBar(
                title: l10n.serviceLogs,
                selectedVehicle: currentState.selectedVehicle,
                vehicles: currentState.vehicles,
                onBack: () => Navigator.pop(context),
                onVehicleSelected: (vehicle) {
                  context.read<ServiceLogsCubit>().selectVehicle(vehicle.id!);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.uploadServicingBill,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            ImagePickerBox(
                              image: _billImages.isNotEmpty 
                                  ? _billImages[0] 
                                  : null,
                              isRequired: true,
                              onTap: _pickImage,
                              onRemove: _billImages.isNotEmpty
                                  ? () => _removeImage(0)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            ImagePickerBox(
                              image: _billImages.length > 1 
                                  ? _billImages[1] 
                                  : null,
                              onTap: _pickImage,
                              onRemove: _billImages.length > 1
                                  ? () => _removeImage(1)
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.maxFileSizeNote,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        _buildTextField(
                          controller: _dateController,
                          label: l10n.serviceDate,
                          isRequired: true,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          suffixIcon: Icons.calendar_today_outlined,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _amountController,
                          label: l10n.billingAmount,
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          prefixText: "₹ ",
                        ),
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _centerNameController,
                          label: l10n.serviceCenterName,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _contactController,
                          label: l10n.serviceCenterContact,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _noteController,
                          label: l10n.additionalNote,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 40),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: state is ServiceLogsSubmitting 
                                ? null 
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<ServiceLogsCubit>().saveServiceLog(
                                        date: _dateController.text,
                                        amount: _amountController.text,
                                        images: _billImages,
                                        centerName: _centerNameController.text,
                                        contact: _contactController.text,
                                        note: _noteController.text,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: theme.dividerColor,
                            ),
                            child: state is ServiceLogsSubmitting
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    l10n.saveDetails,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
    String? prefixText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: "$label${isRequired ? "*" : ""}",
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            prefixText: prefixText,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
            filled: true,
            fillColor: theme.cardColor.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return "This field is required";
            }
            return null;
          },
        ),
      ],
    );
  }
}
