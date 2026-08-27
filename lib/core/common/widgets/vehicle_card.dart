import 'package:flutter/material.dart';
import 'package:trackify/feature/device_installation/presentation/pages/device_installation_screen.dart';
import 'package:trackify/feature/notifications/presentation/screen/notification_timeline.dart';

import '../../../feature/device_warranty/domain/entities/device_warranty_entity.dart';
import '../../../feature/device_warranty/data/model/warranty_status_model.dart';
import '../../../feature/device_warranty/data/repository/device_warranty_repository_impl.dart';
import '../../../feature/device_warranty/data/data_source/device_warranty_data_source.dart';
import '../../../feature/device_data/domain/entity/current_plan_entity.dart';
import '../../../feature/device_data/data/repository/device_data_repository_impl.dart';
import '../../../feature/device_data/data/data_source/device_data_remote_data_source.dart';
import '../../../core/config/network/network_api_service.dart';
import '../../../core/constants/app_images.dart';
import '../../../l10n/app_localizations.dart';
import '../models/vehicle_list_model.dart';
import 'interactive_swipe_button.dart';
import 'secure_banner.dart';

class VehicleCard extends StatefulWidget {
  final Vehicle vehicle;
  final bool hasDevice;
  final bool isDeviceInstalled;
  final bool isLocked;
  final VoidCallback onLock;
  final VoidCallback onRecharge;
  final VoidCallback onRenew;
  final VoidCallback onVehicleControl;
  final BuildContext context;
  final bool showNotificationFooter;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.hasDevice,
    this.isDeviceInstalled = false,
    this.isLocked = false,
    required this.onLock,
    required this.onRecharge,
    required this.onRenew,
    required this.onVehicleControl,
    required this.context,
    this.showNotificationFooter = true,
  });

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  Future<List<dynamic>>? _combinedFuture;

  void _fetchWarrantyAndDataPlan() {
    if (widget.isDeviceInstalled && widget.vehicle.imei != null) {
      final warrantyRepo = DeviceWarrantyRepositoryImpl(
        DeviceWarrantyRemoteDataSourceImpl(NetworkApiService()),
      );
      final dataRepo = DeviceDataRepositoryImpl(
        DeviceDataRemoteDataSourceImpl(NetworkApiService()),
      );

      final wFuture = warrantyRepo
          .getDeviceWarranty(widget.vehicle.imei!)
          .then(
            (result) =>
                result.fold((l) => null as DeviceWarrantyEntity?, (r) => r),
          );
      final dFuture = dataRepo
          .getCurrentDataPlan(widget.vehicle.imei!)
          .then(
            (result) =>
                result.fold((l) => null as CurrentPlanEntity?, (r) => r),
          );

      setState(() {
        _combinedFuture = Future.wait([wFuture, dFuture]);
      });
    } else {
      setState(() {
        _combinedFuture = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWarrantyAndDataPlan();
  }

  @override
  void didUpdateWidget(VehicleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vehicle.imei != widget.vehicle.imei ||
        oldWidget.isDeviceInstalled != widget.isDeviceInstalled) {
      _fetchWarrantyAndDataPlan();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(widget.context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 0.5,
            offset: const Offset(0, 0.5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    onTap: widget.onVehicleControl,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            (() {
                              final lower = widget.vehicle.vehicleType?.toLowerCase() ?? '';
                              if (lower.contains('auto rickshaw') || lower.contains('auto') || lower.contains('3_wheeler')) {
                                return AppImages.rickshawImage;
                              } else if (lower.contains('car') || lower.contains('4_wheeler') || lower.contains('commercial ev')) {
                                return AppImages.carImage;
                              } else if (lower.contains('bus')) {
                                return AppImages.busImage;
                              } else if (lower.contains('van') || lower.contains('truck') || lower.contains('pickup') || lower.contains('pick-up')) {
                                return AppImages.vanImage;
                              }
                              return AppImages.bikeImage;
                            })(),
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                () {
                                  String maker = widget.vehicle.vehicleMaker?.trim() ?? '';
                                  maker = maker.replaceAll(RegExp(r'Honda Motorcycle & Scooter India', caseSensitive: false), 'Honda');
                                  maker = maker.replaceAll(RegExp(r'Honda Motorcycle & Scooter', caseSensitive: false), 'Honda');
                                  maker = maker.replaceAll(RegExp(r'Hero MotoCorp', caseSensitive: false), 'Hero');
                                  maker = maker.replaceAll(RegExp(r'Suzuki Motorcycle India', caseSensitive: false), 'Suzuki');
                                  maker = maker.replaceAll(RegExp(r'Jawa Yezdi Motorcycles', caseSensitive: false), 'Jawa');
                                  maker = maker.replaceAll(RegExp(r'Bajaj Auto', caseSensitive: false), 'Bajaj');
                                  maker = maker.replaceAll(RegExp(r'TVS Motor', caseSensitive: false), 'TVS');
                                  maker = maker.replaceAll(RegExp(r'Tata Motors', caseSensitive: false), 'Tata');
                                  maker = maker.replaceAll(RegExp(r'Maruti Suzuki India', caseSensitive: false), 'Maruti Suzuki');

                                  final model = widget.vehicle.vehicleModel?.trim();
                                  final m = (maker == '?' || maker.toLowerCase() == 'null') ? '' : maker;
                                  final mod = (model == null || model == '?' || model.toLowerCase() == 'null') ? '' : model;
                                  final combined = '$m $mod'.trim();
                                  return combined.isEmpty ? '--' : combined;
                                }(),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    () {
                                      final number = widget
                                          .vehicle
                                          .vehicleNumber
                                          ?.trim();
                                      if (number == null ||
                                          number.isEmpty ||
                                          number == '?' ||
                                          number.toLowerCase() == 'null') {
                                        return '--';
                                      }
                                      return number.toUpperCase();
                                    }(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (widget.isDeviceInstalled)
                                    Text(
                                      l10n.lite4G,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  else
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.verified_user_rounded,
                                          color: Colors.orange,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          l10n.buyTrackifyDevice,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.3),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.isDeviceInstalled) ...[
                  InteractiveSwipeButton(
                    onSwipe: widget.onLock,
                    isLocked: widget.isLocked,
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 13,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "Swipe to lock or unlock the vehicle using your secure PIN.",
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.2,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<dynamic>>(
                    future: _combinedFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            _buildActionRow(
                              l10n,
                              l10n.dataPlan,
                              "Loading...",
                              l10n.rechargeNow,
                              widget.onRecharge,
                              subtitleColor: Colors.grey,
                            ),
                            _buildActionRow(
                              l10n,
                              l10n.warranty,
                              "Loading...",
                              l10n.renewNow,
                              widget.onRenew,
                              subtitleColor: Colors.grey,
                            ),
                          ],
                        );
                      }

                      DeviceWarrantyEntity? warrantyData =
                          snapshot.data?[0] as DeviceWarrantyEntity?;
                      CurrentPlanEntity? dataPlanData =
                          snapshot.data?[1] as CurrentPlanEntity?;

                      int? dataDaysLeft = dataPlanData?.daysLeft;
                      int? warrantyDaysLeft = warrantyData?.warranty?.daysLeft;

                      bool hasNoDataPlan =
                          dataPlanData == null ||
                          dataPlanData.planId.trim().isEmpty;

                      Color getSubtitleColor(
                        int? daysLeft, {
                        bool hasNoPlan = false,
                      }) {
                        if (hasNoPlan || daysLeft == null) return Colors.grey;
                        if (daysLeft <= 0) return Colors.grey;
                        if (daysLeft <= 15) return Colors.red;
                        if (daysLeft <= 60) return Colors.orange;
                        if (daysLeft <= 150) return Colors.amber;
                        if (daysLeft <= 250) return Colors.lightGreen;
                        return Colors.green;
                      }

                      String getSubtitleText(
                        int? daysLeft, {
                        bool hasNoPlan = false,
                      }) {
                        if (hasNoPlan || daysLeft == null) return "--";
                        if (daysLeft <= 0) return l10n.expired;
                        return l10n.expiresInDays(daysLeft);
                      }

                      return Column(
                        children: [
                          _buildActionRow(
                            l10n,
                            l10n.dataPlan,
                            getSubtitleText(
                              dataDaysLeft,
                              hasNoPlan: hasNoDataPlan,
                            ),
                            l10n.rechargeNow,
                            widget.onRecharge,
                            subtitleColor: getSubtitleColor(
                              dataDaysLeft,
                              hasNoPlan: hasNoDataPlan,
                            ),
                          ),
                          _buildActionRow(
                            l10n,
                            l10n.warranty,
                            getSubtitleText(warrantyDaysLeft),
                            l10n.renewNow,
                            widget.onRenew,
                            subtitleColor: getSubtitleColor(warrantyDaysLeft),
                          ),
                        ],
                      );
                    },
                  ),
                ] else ...[
                  const SecureBanner(),
                  const SizedBox(height: 16),
                  _buildInstallLink(l10n, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeviceInstallationScreen(
                          vehicleId: widget.vehicle.id,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12), // Added spacing for 'else' case
                ],
                if (widget.isDeviceInstalled) const SizedBox(height: 12),
              ],
            ),
          ),
          if (widget.showNotificationFooter && widget.isDeviceInstalled)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationTimelineScreen(),
                  ),
                );
              },
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.notifications,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    AppLocalizations l10n,
    String title,
    String subtitle,
    String btnText,
    VoidCallback onTap, {
    Color? subtitleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      subtitleColor ??
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 120,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                minimumSize: const Size(0, 34),
              ),
              child: Text(
                btnText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallLink(AppLocalizations l10n, Function onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.boughtDeviceInstallNow,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        InkWell(
          onTap: () => onTap(),
          child: Text(
            l10n.installNow,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
