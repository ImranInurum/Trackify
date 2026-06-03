import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_state.dart';
import '../../l10n/app_localizations.dart';

class DraggableAppBar extends StatefulWidget {
  final List<Vehicles>? vehicles;
  final Color? backgroundColor;
  final VoidCallback? onAddVehicle;
  final ValueChanged<Vehicles>? onDeviceTap;
  final Vehicles? selectedDevice;

  /// Shown in collapsed mode on the selected device row
  final Widget? collapsedTrailing;

  /// Shown in expanded mode in the header row
  final Widget? expandedTrailing;
  final Map<String, bool>? vehicleStatuses;

  const DraggableAppBar({
    super.key,
    this.vehicles,
    this.backgroundColor,
    this.onAddVehicle,
    this.onDeviceTap,
    this.selectedDevice,
    this.collapsedTrailing,
    this.expandedTrailing,
    this.vehicleStatuses,
  });

  @override
  State<DraggableAppBar> createState() => _DraggableAppBarState();
}

class _DraggableAppBarState extends State<DraggableAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandFactor;
  late final Animation<double> _overlayOpacity;

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

    _expandFactor = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _overlayOpacity = Tween<double>(
      begin: 0,
      end: 0.45,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
                    color: Colors.black.withOpacity(_overlayOpacity.value),
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
                      color: widget.backgroundColor ?? Theme.of(context).cardColor,
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
                          color: Colors.black.withOpacity(0.15),
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
                                                    AppLocalizations.of(context)!.myGarage,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Theme.of(context).colorScheme.onSurface,
                                                    ),
                                                  ),
                                                ),
                                                if (widget.expandedTrailing != null)
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
                                                    final device = _vehicles[index];

                                                    if (device.vehicleNumber ==
                                                        selected?.vehicleNumber) {
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
                                                  child:  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 16,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.add_box_outlined,
                                                          color: Theme.of(context).colorScheme.primary,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          AppLocalizations.of(context)!.addVehicle,
                                                          style: TextStyle(
                                                            color: Theme.of(context).colorScheme.primary,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
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
                                        onVerticalDragUpdate: _handleVerticalDragUpdate,
                                        onVerticalDragEnd: _handleVerticalDragEnd,
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
                                                color: Theme.of(context).dividerColor,
                                                width: 0.25,
                                              ),
                                            ),
                                          ),
                                          child: AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 180),
                                            transitionBuilder: (child, animation) {
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
                                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                                                      borderRadius: BorderRadius.circular(
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
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Theme.of(context).colorScheme.primaryContainer.withOpacity(0.75),
                                      Theme.of(context).colorScheme.primaryContainer.withOpacity(0.05),
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
    final isActive = widget.vehicleStatuses?[device.id] ?? (device.id == _selectedDevice?.id);
    final isSelected = device.id == _selectedDevice?.id;

    return InkWell(
      onTap: isHeaderRow
          ? null
          : () {
              widget.onDeviceTap?.call(device);
              _collapse();
            },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        color: isHighlighted
            ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
            : Colors.transparent,
        child: Row(
          children: [
            // Image
            Image.asset(AppImages.bikeImage, height: 60, width: 60, fit: BoxFit.contain),
            const SizedBox(width: 8),
 
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${device.vehicleMaker} ${device.vehicleModel}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  BlocBuilder<RideHistoryCubit, RideHistoryState>(
                    builder: (context, state) {
                      String timeValue = "--";
                      bool displayIsActive = isActive;

                      if (isSelected &&
                          state is RideHistorySuccess &&
                          state.rides.isNotEmpty) {
                        final lastRide = state.rides.last;
                        if (lastRide.points.isNotEmpty) {
                          final lastPoint = lastRide.points.last;
                          final timeStr = lastPoint.time;
                          if (timeStr != null) {
                            try {
                              final dateTime = DateTime.parse(timeStr).toLocal();
                              timeValue = DateFormat('h:mm a').format(dateTime);

                              // Update active status based on the Previous Ride API time
                              final now = DateTime.now();
                              // Use 10 minutes threshold consistent with MapScreen
                              displayIsActive =
                                  now.difference(dateTime).inMinutes < 10;
                            } catch (e) {
                              debugPrint("Error parsing time: $e");
                            }
                          }
                        } else if (lastRide.endTime.isNotEmpty) {
                          // Fallback to endTime if points are empty but endTime exists
                          timeValue = lastRide.endTime;
                          try {
                            // Try to parse endTime if it's an ISO string to update status
                            final dateTime = DateTime.parse(lastRide.endTime).toLocal();
                             displayIsActive =
                                  DateTime.now().difference(dateTime).inMinutes < 10;
                          } catch (_) {}
                        }
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (displayIsActive ? Colors.green : Colors.red).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (displayIsActive ? Colors.green : Colors.red).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              color: displayIsActive ? Colors.green : Colors.red,
                              size: 7,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${displayIsActive ? "Active" : "Inactive"} • $timeValue",
                              style: TextStyle(
                                fontSize: 11,
                                color: displayIsActive ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        device.vehicleNumber ?? '---',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tag
                      _buildTag(device),
                    ],
                  ),
                ],
              ),
            ),

            // Right Side info / icon
            if (!_isExpanded && isHeaderRow)
              widget.collapsedTrailing ??
                  Icon(
                    Icons.notifications_none_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  )
            else if (_isExpanded && isHeaderRow)
              Text(
                AppLocalizations.of(context)!.expiresInDays('321'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                ),
              )
            else if (_isExpanded && !isHeaderRow)
              Row(
                children: [
                  const Icon(Icons.shield, color: Colors.orange, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context)!.buyTrackifyDevice,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(Vehicles device) {
    return Text(
      "${device.fuelType}", // Default for now
      style: TextStyle(
        fontSize: 11,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
