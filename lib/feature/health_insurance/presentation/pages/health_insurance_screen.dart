import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/feature/health_insurance/presentation/cubit/health_insurance_cubit.dart';
import 'package:trackify/feature/health_insurance/presentation/cubit/health_insurance_state.dart';
import 'package:trackify/feature/health_insurance/domain/entities/health_insurance_entity.dart';

import '../../../../l10n/app_localizations.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class HealthInsuranceScreen extends StatefulWidget {
  const HealthInsuranceScreen({super.key});

  @override
  State<HealthInsuranceScreen> createState() => _HealthInsuranceScreenState();
}

class _HealthInsuranceScreenState extends State<HealthInsuranceScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController policyNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HealthInsuranceCubit>().getData();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    policyNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HealthInsuranceCubit>();
    final state = cubit.state;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
        ),
        title: Text(
          l10n.healthInsurance, ),
      ),
      body: BlocConsumer<HealthInsuranceCubit, HealthInsuranceState>(
        listenWhen: (previous, current) {
           return previous.saveSuccess != current.saveSuccess || 
                  previous.saveError != current.saveError || 
                  (previous.isLoading && !current.isLoading && current.data?.savedData != null);
        },
        listener: (context, state) {
          if (state.saveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.healthInsuranceSavedSuccess),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state.saveError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.saveError!),
                backgroundColor: Colors.red,
              ),
            );
          }
          
          if (state.data?.savedData != null) {
             if (cardNumberController.text.isEmpty) {
                cardNumberController.text = state.data!.savedData!.healthInsuranceCardNumber;
             }
             if (policyNumberController.text.isEmpty) {
                policyNumberController.text = state.data!.savedData!.policyNumber;
             }
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: TrackifyLoader());
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.bloodGroup,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeightManager.regular,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.onSurfaceVariant),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                          isExpanded: true,
                          value: state.selectedBloodGroup,
                          hint: Text(
                            l10n.selectBloodGroup,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeightManager.medium,
                              fontSize: 14,
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: colorScheme.primary,
                            size: 35,
                          ),
                          items: (state.data?.bloodGroup ?? []).map((e) {
                            return DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(color: colorScheme.onSurface),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              cubit.selectBloodGroup(value);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.healthInsurance,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeightManager.medium,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.onSurfaceVariant),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                          isExpanded: true,
                          value: state.selectedInsurance,
                          hint: Text(
                            l10n.healthInsurance,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeightManager.medium,
                              fontSize: 14,
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: colorScheme.primary,
                            size: 35,
                          ),
                          items: (state.data?.insuranceList ?? []).map((e) {
                            return DropdownMenuItem<String>(
                              value: e.name,
                              child: Text(
                                e.name,
                                style: TextStyle(color: colorScheme.onSurface),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              final selected = (state.data?.insuranceList ?? []).cast<HealthInsuranceOptionEntity>().firstWhere(
                                (e) => e.name == value,
                                orElse: () => const HealthInsuranceOptionEntity(id: '', name: ''),
                              );
                              cubit.selectInsuranceList(selected.name, selected.id);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// CARD NUMBER
                    TextField(
                      controller: cardNumberController,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        filled: false,
                        labelText: l10n.healthInsuranceCardNumber,
                        labelStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// POLICY NUMBER
                    TextField(
                      controller: policyNumberController,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        filled: false,
                        labelText: l10n.policyNumber,
                        labelStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// SAVE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 47,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: state.isSaving
                            ? null
                            : () {
                                cubit.save(
                                  cardNumber: cardNumberController.text.trim(),
                                  policyNumber: policyNumberController.text.trim(),
                                );
                              },
                        child: state.isSaving
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Text(
                                l10n.save,
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 17),
                  ],
                ),
              );
            },
      ),
    );
  }
}
