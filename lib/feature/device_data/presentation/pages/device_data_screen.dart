import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../../order_summary/domain/entities/order_summary_entity.dart';
import '../../../order_summary/presentation/pages/order_summary_screen.dart';
import '../../domain/entity/recharge_plan_entity.dart';
import '../cubit/device_data_cubit.dart';
import '../cubit/device_data_state.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_cubit.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_state.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';

class DeviceDataScreen extends StatefulWidget {
  const DeviceDataScreen({super.key});

  @override
  State<DeviceDataScreen> createState() => _DeviceDataScreenState();
}

class _DeviceDataScreenState extends State<DeviceDataScreen> {
  String? _currentImei;

  @override
  void initState() {
    super.initState();
    context.read<DeviceDataCubit>().load();
    context.read<ServiceLogsCubit>().loadVehicles();
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
      return const Scaffold(body: const Center(child: TrackifyLoader()));
    }

    if (state is DeviceDataError) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: color.onSurface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.redAccent,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: text.bodyLarge,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.read<DeviceDataCubit>().load(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final data = state as DeviceDataLoaded;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(l10n.deviceDataPlanLabel),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: color.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// TOP CARD — dynamic from current plan API
          Builder(
            builder: (_) {
              final plan = data.currentPlan;
              final vehicleName = plan != null
                  ? "${plan.vehicleMaker} ${plan.vehicleModel}".trim()
                  : "";
              final vehicleDisplayName = vehicleName.isNotEmpty
                  ? vehicleName
                  : l10n.vehicleNamePlaceholder;
              final planText = plan?.currentPlanText.isNotEmpty == true
                  ? plan!.currentPlanText
                  : '--';
              final expiryText = plan?.expiryDateText.isNotEmpty == true
                  ? plan!.expiryDateText
                  : '--';
              Color? dynamicSubColor;
              String? daysLeftStr;

              if (plan != null) {
                if (plan.daysLeft <= 0) {
                  dynamicSubColor = Colors.grey;
                  daysLeftStr = l10n.expired;
                } else if (plan.daysLeft <= 15) {
                  dynamicSubColor = Colors.red;
                  daysLeftStr = l10n.expiresInDays(plan.daysLeft);
                } else if (plan.daysLeft <= 60) {
                  dynamicSubColor = Colors.orange;
                  daysLeftStr = l10n.expiresInDays(plan.daysLeft);
                } else if (plan.daysLeft <= 150) {
                  dynamicSubColor = Colors.amber; // Yellow
                  daysLeftStr = l10n.expiresInDays(plan.daysLeft);
                } else if (plan.daysLeft <= 250) {
                  dynamicSubColor = Colors.lightGreen;
                  daysLeftStr = l10n.expiresInDays(plan.daysLeft);
                } else {
                  dynamicSubColor = Colors.green;
                  daysLeftStr = l10n.expiresInDays(plan.daysLeft);
                }
              }

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.vehicle,
                      style: text.bodySmall?.copyWith(
                        color: color.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            vehicleDisplayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showVehicleSelector(context),
                          child: Text(
                            l10n.switchLabel,
                            style: text.bodySmall?.copyWith(
                              color: color.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _infoColumn(
                            context,
                            l10n.currentPlan,
                            planText,
                          ),
                        ),
                        Expanded(
                          child: _infoColumn(
                            context,
                            l10n.expiryDate,
                            expiryText,
                            sub: daysLeftStr,
                            subColor: dynamicSubColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          Text(
            l10n.rechargePlans,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          /// Dynamic plans mapping
          if (data.plans.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  l10n.noDataAvailable,
                  style: text.bodyMedium?.copyWith(
                    color: color.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else ...[
            for (int i = 0; i < data.plans.length; i++) ...[
              _buildPlanItem(context, data, data.plans[i], i),
              const SizedBox(height: 12),
            ],
          ],

          const SizedBox(height: 8),

          /// BUTTON (dynamic)
          if (data.plans.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final index = data.selectedIndex;
                    if (index < 0 || index >= data.plans.length) return;

                    final plan = data.plans[index];

                    // Calculate discount: originalPrice - price
                    final discount = plan.originalPrice > plan.price
                        ? plan.originalPrice - plan.price
                        : 0.0;

                    // Calculate GST: if gstApplicable is true, GST is 18% of price, else 0
                    final gst = plan.gstApplicable ? (plan.price * 0.18) : 0.0;
                    final toPay = plan.price + gst;

                    final selectedPlan = OrderSummaryEntity(
                      id: plan.id,
                      title: plan.isSuperCombo
                          ? plan.planName
                          : l10n.rechargePlans,
                      validity: plan.validityText,
                      price: plan.price.toInt(),
                      originalPrice: plan.originalPrice.toInt(),
                      discount: discount.toInt(),
                      gst: gst.toInt(),
                      toPay: toPay.toInt(),
                      benefit: plan.features,
                      isCombo: plan.isSuperCombo,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderSummaryScreen(plan: selectedPlan),
                      ),
                    ).then((success) {
                      if (success == true && context.mounted) {
                        context.read<DeviceDataCubit>().load();
                      }
                    });
                  },
                  child: Text(
                    _buttonText(l10n, data.plans, data.selectedIndex),
                    style: text.labelLarge?.copyWith(
                      color: color.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Helper builder for plan list items
  Widget _buildPlanItem(
    BuildContext context,
    DeviceDataLoaded state,
    RechargePlanEntity plan,
    int index,
  ) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    if (plan.isSuperCombo) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          _comboPlanCard(context, state, plan, index),
          if (plan.tagText.isNotEmpty)
            Positioned(
              top: -20,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.superCombo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      plan.tagText,
                      style: text.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    } else {
      return _planCard(context, state: state, index: index, plan: plan);
    }
  }

  /// 🔥 COMBO PLAN WITH RADIO (UI SAME)
  Widget _comboPlanCard(
    BuildContext context,
    DeviceDataLoaded state,
    RechargePlanEntity plan,
    int index,
  ) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;
    final isSelected = state.selectedIndex == index;

    return GestureDetector(
      onTap: () => context.read<DeviceDataCubit>().selectPlan(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.shadowColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: color.primary, width: 1.2)
              : Border.all(color: Colors.transparent, width: 1.2),
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
                  color: isSelected
                      ? color.primary
                      : color.onSurface.withOpacity(0.5),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    plan.planName,
                    style: text.bodyMedium?.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    plan.validityText,
                    style: text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${l10n.currencySymbol}${plan.price.toStringAsFixed(0)}",
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (plan.originalPrice > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        "${l10n.currencySymbol}${plan.originalPrice.toStringAsFixed(0)}",
                        style: text.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: color.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            if (plan.savingText.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                plan.savingText,
                style: text.bodySmall?.copyWith(color: Colors.green),
              ),
            ],

            const SizedBox(height: 12),

            ...plan.features.map((feature) => _feature(context, feature)),

            if (plan.popularText.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                plan.popularText,
                style: text.bodySmall?.copyWith(color: color.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 🔥 NORMAL PLAN WITH RADIO
  Widget _planCard(
    BuildContext context, {
    required DeviceDataLoaded state,
    required int index,
    required RechargePlanEntity plan,
  }) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final color = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final isSelected = state.selectedIndex == index;

    return GestureDetector(
      onTap: () => context.read<DeviceDataCubit>().selectPlan(index),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected
                  ? color.primary
                  : color.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 10),

            /// Left: validity + feature
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        plan.validityText,
                        style: text.bodyMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.validityLabel,
                        style: text.bodySmall?.copyWith(
                          color: color.onSurface.withOpacity(0.6),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (plan.features.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.check, color: theme.primaryColor, size: 15),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            plan.features[0],
                            style: text.bodySmall?.copyWith(fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            /// Right: original price (strikethrough) + price + GST
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "${l10n.currencySymbol}${plan.price.toStringAsFixed(0)}",
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (plan.originalPrice > 0) ...[
                      const SizedBox(width: 6),
                      Text(
                        "${l10n.currencySymbol}${plan.originalPrice.toStringAsFixed(0)}",
                        style: text.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: color.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ],
                ),
                if (plan.gstApplicable)
                  Text(
                    l10n.plusGst,
                    style: text.bodySmall?.copyWith(
                      fontSize: 10,
                      color: color.onSurface.withOpacity(0.55),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buttonText(
    AppLocalizations l10n,
    List<RechargePlanEntity> plans,
    int index,
  ) {
    if (index < 0 || index >= plans.length) return l10n.continueText;
    final plan = plans[index];
    if (plan.isSuperCombo) {
      return l10n.continueSuperCombo;
    }
    if (plan.validityText.contains("12")) {
      return l10n.continue12Month;
    } else if (plan.validityText.contains("6")) {
      return l10n.continue6Month;
    }
    return "${l10n.continueText} ${plan.validityText}";
  }

  Widget _infoColumn(
    BuildContext context,
    String title,
    String value, {
    String? sub,
    Color? subColor,
  }) {
    final text = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: text.bodySmall?.copyWith(
            color: color.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: text.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (sub != null)
          Text(
            sub,
            style: text.bodySmall?.copyWith(color: subColor ?? color.primary),
          ),
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
          Expanded(
            child: Text(
              textValue,
              style: text.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showVehicleSelector(BuildContext context) {
    final serviceState = context.read<ServiceLogsCubit>().state;
    if (serviceState is! ServiceLogsLoaded) return;

    final vehicles = serviceState.vehicles;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  // If _currentImei is set, use it. Otherwise use the globally selected vehicle.
                  final isSelected = _currentImei != null 
                      ? vehicle.imei == _currentImei
                      : vehicle.id == serviceState.selectedVehicle?.id;

                  return Container(
                    color: isSelected
                        ? theme.scaffoldBackgroundColor.withOpacity(1)
                        : theme.cardColor,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/bike2.png',
                            width: 50,
                            height: 50,
                          ),
                          title: Text(
                            "${vehicle.vehicleMaker ?? ""} ${vehicle.vehicleModel ?? ""}".trim(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(vehicle.vehicleNumber ?? ""),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                              : null,
                          onTap: () {
                            Navigator.pop(context);
                            if (mounted) {
                              setState(() {
                                _currentImei = vehicle.imei;
                              });
                              context.read<DeviceDataCubit>().load(customImei: vehicle.imei);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
