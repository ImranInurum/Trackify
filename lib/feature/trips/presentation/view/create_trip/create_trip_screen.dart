import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trackify/feature/trips/presentation/cubit/create_trip_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/create_trip_state.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_state.dart';


import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/view/trip_details/trip_details_screen.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/polyline_thumbnail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/utils/distance_utils.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class CreateTripScreen extends StatefulWidget {
  final String? initialTitle;
  final List<Ride>? initialSelectedRides;

  const CreateTripScreen({
    super.key,
    this.initialTitle,
    this.initialSelectedRides,
  });

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  bool _showTooltip = false;

  @override
  void initState() {
    super.initState();
    context.read<RideHistoryCubit>().getRideHistoryData();
    _checkTooltipVisibility();
  }

  Future<void> _checkTooltipVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTooltip = prefs.getBool('has_seen_selection_tooltip') ?? false;
    if (!hasSeenTooltip) {
      setState(() {
        _showTooltip = true;
      });
    }
  }

  Future<void> _markTooltipAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_selection_tooltip', true);
    setState(() {
      _showTooltip = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.primary;

    return BlocProvider(
      create: (context) => CreateTripCubit()..init(
        title: widget.initialTitle,
        selectedRides: widget.initialSelectedRides,
      ),
      child: BlocListener<CreateTripCubit, CreateTripState>(
        listener: (context, state) {
          if (state is CreateTripSaved) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TripDetailsScreen(
                  tripName: state.title == 'Trip 1' ? l10n.tripLabel('1') : state.title,
                  rides: state.rides,
                ),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: false, // Align title to the left
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.selectRides,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: BlocBuilder<RideHistoryCubit, RideHistoryState>(
                    builder: (context, rideState) {
                      if (rideState is RideHistoryLoading) {
                        return const Center(child: TrackifyLoader());
                      }
                      if (rideState is RideHistorySuccess) {
                        final groupedRides = _groupRidesByDate(rideState.rides);

                        if (groupedRides.isEmpty) {
                          return Center(
                            child: Text(
                              l10n.noDataAvailable,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return BlocBuilder<CreateTripCubit, CreateTripState>(
                          builder: (context, createTripState) {
                            final selectedRides =
                                (createTripState is CreateTripSuccess)
                                    ? createTripState.selectedRides
                                    : [];

                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: groupedRides.length,
                              itemBuilder: (context, index) {
                                final dateStr = groupedRides.keys.elementAt(index);
                                final rides = groupedRides[dateStr]!;
                                
                                final isGroupSelected = rides.every(
                                  (r) => selectedRides.any((sr) => sr.id == r.id),
                                );

                                return _SelectionGroupCard(
                                  date: dateStr,
                                  rides: rides,
                                  isSelected: isGroupSelected,
                                  goldColor: goldColor,
                                  onToggle: () {
                                    for (var ride in rides) {
                                      context
                                          .read<CreateTripCubit>()
                                          .toggleRideSelection(ride);
                                    }
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                      if (rideState is RideHistoryFailure) {
                        return Center(
                          child: Text(
                            l10n.noDataAvailable,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),

            if (_showTooltip)
              BlocBuilder<RideHistoryCubit, RideHistoryState>(
                builder: (context, rideState) {
                  if (rideState is RideHistorySuccess && rideState.rides.isNotEmpty) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: _markTooltipAsSeen,
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + kToolbarHeight + 70,
                          right: 50,
                          child: _SelectionTooltip(
                            onSkip: _markTooltipAsSeen,
                            goldColor: goldColor,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
          ],
        ),
        bottomNavigationBar: BlocBuilder<CreateTripCubit, CreateTripState>(
          builder: (context, state) {
            if (state is CreateTripSuccess && state.selectedRides.isNotEmpty) {
              final selectedRides = state.selectedRides;
              double totalDist = 0;
              int totalMinutes = 0;
              for (var r in selectedRides) {
                totalDist += r.distance;
                totalMinutes += int.tryParse(r.duration.replaceAll('m', '')) ?? 0;
              }

              final hr = totalMinutes ~/ 60;
              final min = totalMinutes % 60;
              final durationStr = "${hr} ${l10n.hrLabel} ${min} ${l10n.minLabel}";

              return _SelectionSummarySheet(
                summary: l10n.ridesSelectedSummary(
                  selectedRides.length.toString(),
                  totalDist.toStringAsFixed(0),
                  durationStr,
                ),
                goldColor: goldColor,
                onClear: () => context.read<CreateTripCubit>().clearSelection(),
                onCreate: () => context.read<CreateTripCubit>().saveTrip(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
}

  Map<String, List<Ride>> _groupRidesByDate(List<Ride> rides) {
    final Map<String, List<Ride>> groups = {};
    for (var ride in rides) {
      if (!groups.containsKey(ride.date)) {
        groups[ride.date] = [];
      }
      groups[ride.date]!.add(ride);
    }
    return groups;
  }
}

class _SelectionGroupCard extends StatefulWidget {
  final String date;
  final List<Ride> rides;
  final bool isSelected;
  final Color goldColor;
  final VoidCallback onToggle;

  const _SelectionGroupCard({
    required this.date,
    required this.rides,
    required this.isSelected,
    required this.goldColor,
    required this.onToggle,
  });

  @override
  State<_SelectionGroupCard> createState() => _SelectionGroupCardState();
}

class _SelectionGroupCardState extends State<_SelectionGroupCard> {
  bool _isExpanded = false;

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final dt = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
        return DateFormat('EEEE, d MMM yyyy').format(dt);
      }
    } catch (_) {}
    return dateStr;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    double totalDist = 0;
    int totalMinutes = 0;
    double avgSpeed = 0;

    for (var r in widget.rides) {
      totalDist += r.distance;
      totalMinutes += int.tryParse(r.duration.replaceAll('m', '')) ?? 0;
      avgSpeed += r.avgSpeed;
    }
    if (widget.rides.isNotEmpty) avgSpeed /= widget.rides.length;

    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(widget.date),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onToggle,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        border: Border.all(color: widget.goldColor, width: 2),
                        borderRadius: BorderRadius.circular(6),
                        color: widget.isSelected ? widget.goldColor : Colors.transparent,
                      ),
                      child: widget.isSelected
                          ? Icon(Icons.check, size: 18, color: theme.colorScheme.onPrimary)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem("${totalDist.toStringAsFixed(1)}${context.displayKms}", l10n.distanceLabel),
                  _buildStatItem("${totalMinutes}${l10n.minLabel} ${widget.rides.isNotEmpty ? '00${l10n.secLabel}' : ''}", l10n.rideDurationLabel),
                  _buildStatItem("${avgSpeed.toStringAsFixed(1)}${context.displayKmh}", l10n.averageSpeed),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: theme.dividerColor.withValues(alpha: 0.1), height: 1),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Icon(Icons.route_outlined, size: 18, color: widget.goldColor),
                    const SizedBox(width: 8),
                    Text(
                      l10n.ridesCount(widget.rides.length.toString()),
                      style: TextStyle(
                        color: widget.goldColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 24,
                    ),
                  ],
                ),
              ),
              if (_isExpanded)
                Column(
                  children: [
                    const SizedBox(height: 16),
                    ...widget.rides.map((ride) => _buildIndividualRide(ride, l10n)),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndividualRide(Ride ride, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${ride.startTime} - ${ride.endTime}",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "${ride.distance.toStringAsFixed(1)}",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.displayKms,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildSmallStat("${ride.duration}", l10n.rideDurationLabel),
                    const SizedBox(width: 24),
                    _buildSmallStat("${ride.avgSpeed.toStringAsFixed(1)} ${context.displayKmh}", l10n.averageSpeed),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            height: 90,
            child: PolylineThumbnail(
              points: ride.polylinePoints,
              startLabel: ride.startLocation,
              endLabel: ride.endLocation,
              rideId: ride.id,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(String value, String label) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SelectionTooltip extends StatelessWidget {
  final VoidCallback onSkip;
  final Color goldColor;

  const _SelectionTooltip({required this.onSkip, required this.goldColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
        final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(20, 10),
          painter: _TopTrianglePainter(color: theme.cardColor),
        ),
        Container(
          width: 250,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.selectRides,
                style: TextStyle(
                  color: goldColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.selectionTooltipMessage,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onSkip,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: Colors.transparent,
                    child: Text(
                      l10n.skip,
                      style: TextStyle(
                        color: goldColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopTrianglePainter extends CustomPainter {
  final Color color;
  _TopTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width - 40, 0);
    path.lineTo(size.width - 50, size.height);
    path.lineTo(size.width - 30, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _SelectionSummarySheet extends StatelessWidget {
  final String summary;
  final Color goldColor;
  final VoidCallback onClear;
  final VoidCallback onCreate;

  const _SelectionSummarySheet({
    required this.summary,
    required this.goldColor,
    required this.onClear,
    required this.onCreate,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
 final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                summary,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onClear,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                    side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.clearSelection,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCreate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.createTrip,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
