import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/feature/health_insurance/presentation/cubit/health_insurance_cubit.dart';
import 'package:trackify/l10n/app_localizations_ar.dart';

import '../../../../l10n/app_localizations.dart';

class HealthInsuranceScreen extends StatefulWidget {
  const HealthInsuranceScreen({super.key});

  @override
  State<HealthInsuranceScreen> createState() => _HealthInsuranceScreenState();
}

class _HealthInsuranceScreenState extends State<HealthInsuranceScreen> {
  @override
  void initState() {
    super.initState();

    context.read<HealthInsuranceCubit>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final cubit =
    context.watch<HealthInsuranceCubit>();

    final state = cubit.state;

    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        },
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface,)),
        title: Text(l10n.healthInsurance,
          style: TextStyle
            (color: colorScheme.onSurface
              , fontSize: 20,
              fontWeight: FontWeightManager.semibold
          ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.bloodGroup,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeightManager.regular,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 14,),

            Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.onSurfaceVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: colorScheme.surface,
                  isExpanded: true,
                  value: state.selectedBloodGroup,
                  hint: Text(l10n.selectBloodGroup, style:
                  TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeightManager.medium,
                    fontSize: 18,
                  ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded, color: colorScheme.onSurface,),
                  items: (state.data?.bloodGroup ?? [])
                      .map((e) {
                    return DropdownMenuItem<String>(

                      value: e,

                      child: Text(
                        e,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                        ),
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

            const SizedBox(height: 14,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.healthInsurance,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeightManager.medium,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 14,),

            Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.onSurfaceVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: colorScheme.surface,
                  isExpanded: true,
                  value: state.selectedInsurance,
                  hint: Text(l10n.healthInsurance, style:
                  TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeightManager.medium,
                    fontSize: 18,
                  ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded, color: colorScheme.onSurface,),
                  items: (state.data?.insuranceList ?? [])
                      .map((e) {
                    return DropdownMenuItem<String>(

                      value: e,

                      child: Text(
                        e,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      cubit.selectInsuranceList(value);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// CARD NUMBER
            TextField(

              style: TextStyle(
                color: colorScheme.onSurface,
              ),

              decoration:
              InputDecoration(
                filled: false,
                labelText:
                l10n.healthInsuranceCardNumber,

                labelStyle: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),

                enabledBorder:
                UnderlineInputBorder(

                  borderSide: BorderSide(
                    color:
                    colorScheme.outline,
                  ),
                ),

                focusedBorder:
                UnderlineInputBorder(

                  borderSide: BorderSide(
                    color: colorScheme.primary,
                  ),
                ),
                
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                  ),
                ),
              ),

            ),

            const SizedBox(height: 30),

            /// POLICY NUMBER
            TextField(

              style: TextStyle(
                color: colorScheme.onSurface,
              ),

              decoration:
              InputDecoration(
                filled: false,
                labelText: l10n.policyNumber,

                labelStyle: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),

                enabledBorder:
                UnderlineInputBorder(

                  borderSide: BorderSide(
                    color:
                    colorScheme.outline,
                  ),
                ),

                focusedBorder:
                UnderlineInputBorder(

                  borderSide: BorderSide(
                    color: colorScheme.primary,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// SAVE BUTTON
            SizedBox(

              width: double.infinity,

              height: 54,

              child: ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  colorScheme.primary,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  l10n.save,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 22,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 17),
          ],
        ),
      ),
    );
  }
}

