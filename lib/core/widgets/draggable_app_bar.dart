import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';
import 'package:trackify/feature/device_warranty/data/model/warranty_status_model.dart';
import 'package:trackify/feature/device_warranty/data/repository/device_warranty_repository_impl.dart';
import 'package:trackify/feature/device_warranty/data/data_source/device_warranty_data_source.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/app/app_navigation.dart';
import '../../l10n/app_localizations.dart';

class DraggableAppBar extends StatefulWidget {
  final List<Vehicles>? vehicles;
  final Color? backgroundColor;
  final VoidCallback? onAddVehicle;
  final ValueChanged<Vehicles>? onDeviceTap;
  final Vehicles? selectedDevice;

  /// Shown in collapsed mode on the selected device row
  final Widget? collapsedTrailing;

  final Widget? expandedTrailing;
  final int? refreshKey;

  const DraggableAppBar({
    super.key,
    this.vehicles,
    this.backgroundColor,
    this.onAddVehicle,
    this.onDeviceTap,
    this.selectedDevice,
    this.collapsedTrailing,
    this.expandedTrailing,
    this.refreshKey,
  });

  @override
  State<DraggableAppBar> createState() => _DraggableAppBarState();
}

class _DraggableAppBarState extends State<DraggableAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandFactor;
  late final Animation<double> _overlayOpacity;

  final Map<String, Map<String, dynamic>> _deviceStatusMap = {};
  final Map<String, WarrantyStatusModel?> _warrantyStatusMap = {};
  final Set<String> _fetchingImeis = {};
  Timer? _statusTimer;

  List<Vehicles> get _vehicles => widget.vehicles ?? [];

  Vehicles? get _selectedDevice {
    if (widget.selectedDevice != null) return widget.selectedDevice;
    if (_vehicles.isNotEmpty) return _vehicles.first;
    return null;
  }

  bool get _isExpanded => _controller.value > 0.5;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _expandFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _overlayOpacity = Tween<double>(
      begin: 0,
      end: 0.45,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _startStatusTimer();
  }

  void _startStatusTimer() {
    _fetchStatuses();
    _statusTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      _fetchStatuses();
    });
  }

  @override
  void didUpdateWidget(DraggableAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vehicles != widget.vehicles ||
        oldWidget.selectedDevice != widget.selectedDevice ||
        oldWidget.refreshKey != widget.refreshKey) {
      if (oldWidget.refreshKey != widget.refreshKey) {
        _warrantyStatusMap.clear();
      }
      _fetchStatuses();
    }
  }

  void _fetchStatuses() {
    for (final device in _vehicles) {
      final imei = device.imei ?? '';
      if (imei.isNotEmpty) {
        _fetchDeviceStatus(imei);
        _fetchWarrantyStatus(imei);
      }
    }
  }

  Future<void> _fetchDeviceStatus(String imei) async {
    if (imei.isEmpty || _fetchingImeis.contains(imei)) return;
    _fetchingImeis.add(imei);
    try {
      final response = await http
          .get(
            Uri.parse(ApiURL.deviceStatus(imei)),
            headers: {
              'Authorization': 'Bearer ${ApiURL.authToken}',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          data['imei'] = imei; // Ensure imei is present for identification
          if (mounted) {
            setState(() {
              _deviceStatusMap[imei] = data;
            });
            context.read<AppCubit>().handleDeviceData(data);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching device status for $imei: $e");
    } finally {
      _fetchingImeis.remove(imei);
    }
  }

  Future<void> _fetchWarrantyStatus(String imei) async {
    if (imei.isEmpty || _warrantyStatusMap.containsKey(imei)) return;
    try {
      final repository = DeviceWarrantyRepositoryImpl(
        DeviceWarrantyRemoteDataSourceImpl(NetworkApiService()),
      );
      final result = await repository.getDeviceWarrantyStatus(imei);
      if (mounted) {
        setState(() {
          _warrantyStatusMap[imei] = result.fold((l) => null, (r) => r);
        });
        
        // Sync global state for the selected device
        final r = _warrantyStatusMap[imei];
        if (r != null && _selectedDevice != null && _selectedDevice!.imei == imei) {
          final daysLeft = r.warranty?.daysLeft;
          final bool apiIsExpired = r.warranty?.isExpired ?? false;
          final expired = (daysLeft != null && daysLeft > 0) ? false : (apiIsExpired || (daysLeft != null && daysLeft <= 0));
          
          final previouslyExpired = AppPreference.instance.getBoolSync(key: 'KEY_WARRANTY_EXPIRED', defaultValue: true);
          if (previouslyExpired != expired) {
            AppPreference.instance.setBool(key: 'KEY_WARRANTY_EXPIRED', value: expired).then((_) {
              AppNavigation.refreshNavigationState();
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching warranty status for $imei: $e");
      if (mounted) {
        setState(() {
          _warrantyStatusMap[imei] = null;
        });
      }
    }
  }

  void _expand() {
    _controller.forward();
  }

  void _collapse() {
    _controller.reverse();
  }

  void _toggle() {
    if (_isExpanded) {
      _collapse();
    } else {
      _expand();
    }
  }

  void _handleSheetTap() {
    _toggle();
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    final nextValue = _controller.value + (delta / 120);
    _controller.value = nextValue.clamp(0.0, 1.0);
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity > 150) {
      _expand();
      return;
    }

    if (velocity < -150) {
      _collapse();
      return;
    }

    if (_controller.value >= 0.5) {
      _expand();
    } else {
      _collapse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final selected = _selectedDevice;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            if (_controller.value > 0)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _collapse,
                  child: Container(
                    color: Colors.black.withValues(alpha: _overlayOpacity.value),
                  ),
                ),
              ),

            Align(
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color:
                          widget.backgroundColor ?? Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(26),
                          bottomRight: Radius.circular(26),
                        ),
                        side: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 0.8,
                        ),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: topInset),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Full tappable sheet area except handle
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _handleSheetTap,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRect(
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          heightFactor: _expandFactor.value,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              16,
                                              10,
                                              4,
                                              8,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.myGarage,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.onSurface,
                                                    ),
                                                  ),
                                                ),
                                                if (widget.expandedTrailing !=
                                                    null)
                                                  widget.expandedTrailing!,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      if (selected != null)
                                        _buildVehicleRow(
                                          selected,
                                          isHeaderRow: true,
                                          isHighlighted: _isExpanded,
                                        ),

                                      ClipRect(
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          heightFactor: _expandFactor.value,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (_vehicles.length > 1)
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  itemCount: _vehicles.length,
                                                  itemBuilder: (context, index) {
                                                    final device =
                                                        _vehicles[index];

                                                    if (device.vehicleNumber ==
                                                        selected
                                                            ?.vehicleNumber) {
                                                      return const SizedBox.shrink(); // skip selected as it's at the top
                                                    }

                                                    return _buildVehicleRow(
                                                      device,
                                                      isHeaderRow: false,
                                                      isHighlighted: false,
                                                    );
                                                  },
                                                ),

                                              if (widget.onAddVehicle != null)
                                                InkWell(
                                                  onTap: widget.onAddVehicle,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 18,
                                                          vertical: 16,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .add_box_outlined,
                                                          color: Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.addVehicle,
                                                          style: TextStyle(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: _toggle,
                                        onVerticalDragUpdate:
                                            _handleVerticalDragUpdate,
                                        onVerticalDragEnd:
                                            _handleVerticalDragEnd,
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                            top: 0,
                                            bottom: 4,
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Theme.of(
                                                  context,
                                                ).dividerColor,
                                                width: 0.25,
                                              ),
                                            ),
                                          ),
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 180,
                                            ),
                                            transitionBuilder:
                                                (child, animation) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  );
                                                },
                                            child: _isExpanded
                                                ? Image.asset(
                                                    AppImages.arrowUpIcon,
                                                    height: 60,
                                                    width: 80,
                                                    key: const ValueKey(
                                                      'expanded_handle',
                                                    ),
                                                  )
                                                : Container(
                                                    key: const ValueKey(
                                                      'collapsed_handle',
                                                    ),
                                                    width: 55,
                                                    height: 2.5,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(alpha: 0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            24,
                                                          ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: IgnorePointer(
                              child: Container(
                                height: 26,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: 0.15,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                          .withValues(alpha: 0.75),
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                          .withValues(alpha: 0.05),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVehicleRow(
    Vehicles device, {
    required bool isHeaderRow,
    required bool isHighlighted,
  }) {
    final imei = device.imei ?? '';
    final isSelectedDevice =
        _selectedDevice != null && device.id == _selectedDevice!.id;
    final bool isPrefExpired =
        isSelectedDevice &&
        AppPreference.instance.getBoolSync(key: 'KEY_WARRANTY_EXPIRED', defaultValue: true);

    final warranty = _warrantyStatusMap[imei];
    final daysLeft = warranty?.warranty?.daysLeft;
    final bool isFetchedExpired = warranty != null &&
        ((daysLeft != null && daysLeft > 0)
            ? false
            : (warranty.warranty?.isExpired == true || (daysLeft ?? 0) <= 0));

    final bool isExpired =
        warranty != null ? isFetchedExpired : isPrefExpired;

    String statusLabel = isExpired
        ? AppLocalizations.of(context)!.expired
        : 'Offline';
    Color statusColor = Colors.grey;

    if (imei.isNotEmpty && !isExpired) {
      if (_deviceStatusMap.containsKey(imei)) {
        final statusData = _deviceStatusMap[imei];
        final statusStr = statusData?['status']?.toString();
        if (statusStr != null) {
          statusLabel = statusStr;
          if (statusStr.toLowerCase() == 'moving') {
            statusColor = Colors.green;
          } else if (statusStr.toLowerCase() == 'idle') {
            statusColor = Colors.red;
          } else if (statusStr.toLowerCase() == 'parking' ||
              statusStr.toLowerCase() == 'parked') {
            statusColor = Colors.blue;
          } else {
            statusColor = Colors.grey;
          }
        }
      }
    }

    return Material(
      color: isHighlighted
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
          : Colors.transparent,
      child: InkWell(
        onTap: isHeaderRow
            ? null
            : () {
                widget.onDeviceTap?.call(device);
                _collapse();
              },
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              _buildVehicleImageOrIcon(context, device),
              const SizedBox(width: 8),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${device.vehicleMaker} ${device.vehicleModel}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          device.vehicleNumber,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Tag
                        _buildTag(device),
                        // Status Container
                        if (device.imei == null || device.imei!.isEmpty)
                          !_isExpanded
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.orange.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.shield,
                                        color: Colors.orange,
                                        size: 10,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.buyTrackifyDevice,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink()
                        else if (isExpired && _isExpanded)
                          const SizedBox.shrink()
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, color: statusColor, size: 7),
                                const SizedBox(width: 4),
                                Text(
                                  statusLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
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

              // Right Side info / icon
              if (!_isExpanded && isHeaderRow)
                if (device.imei == null || device.imei!.isEmpty)
                  const SizedBox.shrink()
                else
                  widget.collapsedTrailing ??
                      Icon(
                        Icons.notifications_none_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                      )
              else if (_isExpanded)
                if (device.imei == null || device.imei!.isEmpty)
                  Row(
                    children: [
                      const Icon(Icons.shield, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.buyTrackifyDevice,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  )
                else
                  (() {
                    if (!_warrantyStatusMap.containsKey(device.imei)) {
                      return const SizedBox(
                        height: 12,
                        width: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }

                    final warranty = _warrantyStatusMap[device.imei];
                    if (warranty == null || warranty.warranty == null) {
                      return const SizedBox.shrink();
                    }

                    int daysLeft = warranty.warranty?.daysLeft ?? 0;

                    Color textColor;
                    String text;

                    if (daysLeft <= 0) {
                      textColor = Colors.grey;
                      text = AppLocalizations.of(context)!.expired;
                    } else if (daysLeft <= 15) {
                      textColor = Colors.red;
                      text = AppLocalizations.of(
                        context,
                      )!.daysLeftText(daysLeft.toString());
                    } else if (daysLeft <= 60) {
                      textColor = Colors.orange;
                      text = AppLocalizations.of(
                        context,
                      )!.daysLeftText(daysLeft.toString());
                    } else if (daysLeft <= 150) {
                      textColor = Colors.amber; // Yellow
                      text = AppLocalizations.of(
                        context,
                      )!.daysLeftText(daysLeft.toString());
                    } else if (daysLeft <= 250) {
                      textColor = Colors.lightGreen;
                      text = AppLocalizations.of(
                        context,
                      )!.daysLeftText(daysLeft.toString());
                    } else {
                      textColor = Colors.green;
                      text = AppLocalizations.of(
                        context,
                      )!.daysLeftText(daysLeft.toString());
                    }

                    return Text(
                      text,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    );
                  })(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(Vehicles device) {
    return Text(
      device.fuelType, // Default for now
      style: TextStyle(
        fontSize: 11,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildVehicleImageOrIcon(BuildContext context, Vehicles device) {
    final type = device.vehicleType.toLowerCase();

    if (type.contains('car') || type.contains('4_wheeler') || type.contains('commercial ev')) {
      return Image.asset(
        AppImages.carImage,
        height: 60,
        width: 60,
        fit: BoxFit.contain,
      );
    } else if (type.contains('auto rickshaw') || type.contains('auto') || type.contains('3_wheeler')) {
      return Image.asset(
        AppImages.rickshawImage,
        height: 60,
        width: 60,
        fit: BoxFit.contain,
      );
    } else if (type.contains('bus')) {
      return Image.asset(
        AppImages.busImage,
        height: 60,
        width: 60,
        fit: BoxFit.contain,
      );
    } else if (type.contains('van') || type.contains('truck') || type.contains('pickup') || type.contains('pick-up')) {
      return Image.asset(
        AppImages.vanImage,
        height: 60,
        width: 60,
        fit: BoxFit.contain,
      );
    } else if (type.contains('bus')) {
      return Icon(
        Icons.directions_bus,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      );
    } else if (type.contains('van')) {
      return Icon(
        Icons.airport_shuttle,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      );
    } else if (type.contains('tractor')) {
      return Icon(
        Icons.agriculture,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      );
    } else {
      // Default to bike image
      return Image.asset(
        AppImages.bikeImage,
        height: 60,
        width: 60,
        fit: BoxFit.contain,
      );
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
