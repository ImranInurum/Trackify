
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../cubit/device_data_cubit.dart';
import '../cubit/device_data_state.dart';

class DeviceDataScreen extends StatefulWidget {
  const DeviceDataScreen({super.key});

  @override
  State<DeviceDataScreen> createState() => _DeviceDataScreenState();
}

class _DeviceDataScreenState extends State<DeviceDataScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DeviceDataCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    /// 🔥 Cubit state
    final state = context.watch<DeviceDataCubit>().state;

    if (state is DeviceDataLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is DeviceDataError) {
      return Scaffold(
        body: Center(child: Text(state.message)),
      );
    }

    final data = state as DeviceDataLoaded;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          l10n.deviceDataPlanLabel,
          style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: color.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// TOP CARD (UNCHANGED)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.vehicleNamePlaceholder,
                    style: text.bodySmall?.copyWith(
                        color: color.onSurface.withOpacity(0.6))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text("SP 125",
                        style: text.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(l10n.switchLabel,
                        style: text.bodySmall?.copyWith(
                            color: color.primary,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoColumn(context, l10n.dataPlan, l10n.month12Validity),                    _infoColumn(
                      context,
                      l10n.expiryDate,
                      "23 Feb 2027",
                      sub: l10n.expiresInDays("301"),
                      subColor: Colors.green,
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(l10n.rechargePlans,
              style:
              text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),

          const SizedBox(height: 12),

          /// 🔥 COMBO PLAN (index 0)
          _comboPlanCard(context, data),

          const SizedBox(height: 12),

          /// 🔥 PLAN 1 (index 1)
          _planCard(
            context,
            state: data,
            index: 1,
            title: l10n.month12Validity,
            price: "₹1186",
            oldPrice: "₹1999",
          ),

          _planCard(
            context,
            state: data,
            index: 2,
            title: l10n.month6Validity,
            price: "₹999",
          ),

          const SizedBox(height: 20),

          /// BUTTON (dynamic)
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text(
    _buttonText(l10n, data.selectedIndex)       ,
                style: text.labelLarge?.copyWith(
                  color: color.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 🔥 COMBO PLAN WITH RADIO (UI SAME)
  Widget _comboPlanCard(
      BuildContext context, DeviceDataLoaded state) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;
    final isSelected = state.selectedIndex == 0;

    return GestureDetector(
      onTap: () =>
          context.read<DeviceDataCubit>().selectPlan(0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected ? color.primary : color.primary,
              width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: color.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(l10n.superComboPlan,
                    style: text.bodyMedium?.copyWith(
                        color: color.primary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.month12Validity,
                    style: text.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Text("₹1355",
                        style: text.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text("₹3438",
                        style: text.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: color.onSurface.withOpacity(0.5),
                        )),
                  ],
                )
              ],
            ),

            const SizedBox(height: 6),
            Text(l10n.saveAmount("2083"),
                style: text.bodySmall?.copyWith(color: Colors.green)),

            const SizedBox(height: 12),

            _feature(context, l10n.appSimRecharge),
            _feature(context, l10n.extendedWarranty),
            _feature(context, l10n.plusMembership),

            const SizedBox(height: 10),

        Text(l10n.superComboPopularity,
                style: text.bodySmall?.copyWith(color: color.primary)),
          ],
        ),
      ),
    );
  }

  /// 🔥 NORMAL PLAN WITH RADIO (UI SAME)
  Widget _planCard(BuildContext context,
      {required DeviceDataLoaded state,
        required int index,
        required String title,
        required String price,
        String? oldPrice}) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final color = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final isSelected = state.selectedIndex == index;

    return GestureDetector(
      onTap: () =>
          context.read<DeviceDataCubit>().selectPlan(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: color.primary, width: 1.2)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected
                  ? color.primary
                  : color.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 10),

            Expanded(child: Text(title, style: text.bodyMedium)),

            Row(
              children: [
                Text(price,
                    style: text.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                if (oldPrice != null) ...[
                  const SizedBox(width: 8),
                  Text(oldPrice,
                      style: text.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: color.onSurface.withOpacity(0.5),
                      ))
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  String _buttonText(AppLocalizations l10n, int index) {
    if (index == 0) return l10n.continueSuperCombo;
    if (index == 1) return l10n.continue12Month;
    return l10n.continue6Month;
  }

  Widget _infoColumn(BuildContext context, String title, String value,
      {String? sub, Color? subColor}) {
    final text = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: text.bodySmall
                ?.copyWith(color: color.onSurface.withOpacity(0.6))),
        const SizedBox(height: 4),
        Text(value,
            style:
            text.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        if (sub != null)
          Text(sub,
              style: text.bodySmall?.copyWith(
                  color: subColor ?? color.primary)),
      ],
    );
  }

  Widget _feature(BuildContext context, String textValue) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Text(textValue, style: text.bodySmall),
        ],
      ),
    );
  }

}