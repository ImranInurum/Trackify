import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/view/create_trip/create_trip_screen.dart';
import 'package:trackify/feature/trips/presentation/view/ride_history_details/ride_history_details_screen.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/polyline_thumbnail.dart';

import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'dart:convert';

import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/utils/distance_utils.dart';

class TripDetailsScreen extends StatefulWidget {
  final String tripName;
  final List<Ride> rides;

  const TripDetailsScreen({
    super.key,
    required this.tripName,
    required this.rides,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  bool _isFabExtended = true;
  late final Timer _fabTimer;
  File? _pickedImage;
  
  late String _currentTripName;
  String _currentTripQuote = "";

  @override
  void initState() {
    super.initState();
    _currentTripName = widget.tripName;
    _loadTripData();
    // Periodic expansion: every 17 seconds
    _fabTimer = Timer.periodic(const Duration(seconds: 17), (timer) {
      if (mounted) {
        setState(() => _isFabExtended = true);
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _isFabExtended = false);
        });
      }
    });

    // Initial collapse after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isFabExtended = false);
    });
  }

  Future<void> _loadTripData() async {
    try {
      final box = await Hive.openBox('saved_trips');
      final trips = box.get('trips_list', defaultValue: []) as List<dynamic>;
      for (var t in trips) {
        final decoded = jsonDecode(t as String);
        if (decoded['title'] == _currentTripName) {
          if (mounted) {
            setState(() {
              if (decoded['quote'] != null) {
                _currentTripQuote = decoded['quote'];
              }
              if (decoded['imagePath'] != null) {
                _pickedImage = File(decoded['imagePath'] as String);
              }
            });
          }
          break;
        }
      }
    } catch (e) {
      debugPrint('Error loading trip details: $e');
    }
  }

  @override
  void dispose() {
    _fabTimer.cancel();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      
      try {
        final box = await Hive.openBox('saved_trips');
        final trips = List<dynamic>.from(box.get('trips_list', defaultValue: []));
        for (int i = 0; i < trips.length; i++) {
          final decoded = jsonDecode(trips[i] as String);
          if (decoded['title'] == _currentTripName) {
            decoded['imagePath'] = pickedFile.path;
            trips[i] = jsonEncode(decoded);
            break;
          }
        }
        await box.put('trips_list', trips);
      } catch (e) {
        debugPrint('Error saving trip image: $e');
      }

      if (mounted) Navigator.pop(context);
    }
  }

  void _showEditDetailsDialog() {
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    final nameController = TextEditingController(text: _currentTripName);
    final quoteController = TextEditingController(
      text: _currentTripQuote.isNotEmpty ? _currentTripQuote : l10n.tripQuoteDefault,
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.tripDetails,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.tripNameLabel,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: goldColor),
                  ),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quoteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.tripQuoteLabel,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: goldColor),
                  ),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () async {
                      final newName = nameController.text.trim();
                      final newQuote = quoteController.text.trim();
                      
                      if (newName.isNotEmpty) {
                        try {
                          final box = await Hive.openBox('saved_trips');
                          final trips = List<dynamic>.from(box.get('trips_list', defaultValue: []));
                          
                          for (int i = 0; i < trips.length; i++) {
                            final decoded = jsonDecode(trips[i] as String);
                            if (decoded['title'] == _currentTripName) {
                              decoded['title'] = newName;
                              decoded['quote'] = newQuote;
                              trips[i] = jsonEncode(decoded);
                              break;
                            }
                          }
                          await box.put('trips_list', trips);
                        } catch (e) {
                          debugPrint('Error updating trip: $e');
                        }

                        if (mounted) {
                          setState(() {
                            _currentTripName = newName;
                            _currentTripQuote = newQuote;
                          });
                        }
                      }
                      
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Text(
                      l10n.save,
                      style: TextStyle(
                        color: goldColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    final parentContext = context;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Disable the delete button after first click to prevent multiple clicks
    bool isDeleting = false;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          l10n.deleteTrip, ),
        content: Text(
          l10n.deleteTripConfirmation,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (isDeleting) return;
              isDeleting = true;
              
              // Actual delete logic from Hive
              try {
                final box = await Hive.openBox('saved_trips');
                final trips = List<dynamic>.from(box.get('trips_list', defaultValue: []));
                
                // Find and remove the trip by title
                trips.removeWhere((t) {
                  try {
                    final decoded = jsonDecode(t as String);
                    return decoded['title'] == _currentTripName;
                  } catch (_) {
                    return false;
                  }
                });
                
                await box.put('trips_list', trips);
              } catch (e) {
                debugPrint('Error deleting trip: $e');
              }
              
              if (parentContext.mounted) {
                Navigator.pop(dialogContext); // Pop the dialog
                Navigator.pop(parentContext); // Pop the screen
              }
            },
            child: Text(
              l10n.yesImSure,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadImageSheet() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
             Text(
              l10n.uploadImage,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildOption(context, Icons.camera_alt_outlined, l10n.camera, () => _pickImage(ImageSource.camera)),
                const SizedBox(width: 24),
                _buildOption(context, Icons.image_outlined, l10n.gallery, () => _pickImage(ImageSource.gallery)),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
            ),
            child: Icon(icon, color: Colors.grey[700], size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.primary;
    final cardBg = theme.cardColor;
    final isDark = theme.brightness == Brightness.dark;

    // Calculate aggregate stats
    double totalDist = 0;
    int totalMinutes = 0;
    double avgSpeed = 0;
    double topSpeed = 0;

    for (var r in widget.rides) {
      totalDist += r.distance;
      totalMinutes += int.tryParse(r.duration.replaceAll('m', '')) ?? 0;
      avgSpeed += r.avgSpeed;
      if (r.topSpeed > topSpeed) topSpeed = r.topSpeed;
    }
    if (widget.rides.isNotEmpty) avgSpeed /= widget.rides.length;

    String formatDuration(int totalMinutes) {
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      return "${hours}h ${minutes}m";
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER IMAGE SECTION
            Stack(
              children: [
                Container(
                  height: 280, // Slightly taller for full width look
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _pickedImage != null && _pickedImage!.existsSync()
                          ? FileImage(_pickedImage!) as ImageProvider
                          : const AssetImage('assets/images/explore_app_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Bottom Bar Gradient & Title
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100, // Taller gradient for better blend
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.4, 1.0],
                        colors: [
                          Colors.transparent,
                          isDark
                              ? const Color(0xFF0A0D14).withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.4),
                          isDark
                              ? theme.colorScheme.shadow.withValues(alpha: 0.9)
                              : Colors.white.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.end, // Align text to bottom
                      children: [
                        Text(
                          _currentTripName,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _showEditDetailsDialog,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5B14B), // Premium Gold
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Top Buttons
                Positioned(
                  top: MediaQuery.of(context).padding.top - 7,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircularButton(
                        icon: Icons.arrow_back_ios_new,
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: isDark
                            ? Colors.black.withValues(alpha: 0.6)
                            : Colors.white.withValues(alpha: 0.6),
                        iconColor: isDark ? Colors.white : Colors.black87,
                      ),
                      _CircularButton(
                        icon: Icons.delete_outline,
                        onPressed: _showDeleteDialog,
                        backgroundColor: isDark
                            ? Colors.black.withValues(alpha: 0.6)
                            : Colors.white.withValues(alpha: 0.6),
                        iconColor: isDark ? Colors.white : Colors.black87,
                      ),
                    ],
                  ),
                ),
                // Camera Icon (Repositioned to bottom right)
                Positioned(
                  right: 16,
                  bottom: 60,
                  child: _CircularButton(
                    icon: Icons.camera_alt_outlined,
                    onPressed: _showUploadImageSheet,
                    size: 46,
                    iconSize: 22,
                    backgroundColor: isDark
                        ? Colors.black.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.6),
                    iconColor: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),

            /// TRIP QUOTE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                "\"${_currentTripQuote.isNotEmpty ? _currentTripQuote : l10n.tripQuoteDefault}\"",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// TRIP STATS CARD
            _StatCard(
              title: l10n.tripStats,
              goldColor: goldColor,
              cardBg: cardBg,
              stats: [
                _StatItem(
                  value: "${totalDist.toStringAsFixed(1)}${context.displayKms}",
                  label: l10n.distance,
                ),
                _StatItem(
                  value: formatDuration(totalMinutes),
                  label: l10n.rideDurationLabel,
                ),
                _StatItem(
                  value: "${avgSpeed.toStringAsFixed(1)}${context.displayKmh}",
                  label: l10n.avgSpeedLabel,
                ),
                _StatItem(
                  value: "${topSpeed.toStringAsFixed(1)}${context.displayKmh}",
                  label: l10n.topSpeedLabel,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// RIDING BEHAVIOUR CARD
            _BehaviourCard(
              title: l10n.ridingBehaviour,
              goldColor: goldColor,
              cardBg: cardBg,
            ),

            const SizedBox(height: 16),

            /// MAP CARD
            _MapCard(
              rides: widget.rides,
              goldColor: goldColor,
              totalDist: totalDist,
              totalDuration: formatDuration(totalMinutes),
              onTap: () {
                if (widget.rides.isNotEmpty) {
                  final mergedRide = Ride.mergeRides(widget.rides);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RideHistoryDetailsScreen(ride: mergedRide),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 100), // Bottom padding for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTripScreen(
                initialTitle: _currentTripName,
                initialSelectedRides: widget.rides,
              ),
            ),
          );
        },
        backgroundColor: goldColor,
        elevation: 4,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    axisAlignment: -1,
                    child: child,
                  ),
                );
              },
              child: _isFabExtended
                  ? Padding(
                      key: const ValueKey('extended_text'),
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        l10n.editRides,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('shrunk_text')),
            ),
            Icon(Icons.edit, color: theme.colorScheme.onPrimary, size: 24),
          ],
        ),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }
}

class _CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const _CircularButton({
    required this.icon,
    required this.onPressed,
    this.size = 44,
    this.iconSize = 24,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.white, size: iconSize),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final Color goldColor;
  final Color cardBg;
  final List<_StatItem> stats;

  const _StatCard({
    required this.title,
    required this.goldColor,
    required this.cardBg,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: goldColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stats.map((s) => _buildItem(context, s)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, _StatItem s) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.value,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            s.label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String value;
  final String label;
  _StatItem({required this.value, required this.label});
}

class _BehaviourCard extends StatelessWidget {
  final String title;
  final Color goldColor;
  final Color cardBg;

  const _BehaviourCard({
    required this.title,
    required this.goldColor,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: goldColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBehaviourItem(context, 85), // Single behavior score
        ],
      ),
    );
  }

  Widget _buildBehaviourItem(BuildContext context, int percentage) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 38,
      width: 110, // Fixed width as seen in screenshot
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Filled part
          FractionallySizedBox(
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.black.withValues(alpha: 0.1),
              ),
              alignment: Alignment.center,
              child: Text(
                "$percentage%",
                style: TextStyle(
                  color: isDark ? Colors.black : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // If 0%, show it in center of empty box
          if (percentage == 0)
            const Center(
              child: Text(
                "0%",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  final List<Ride> rides;
  final Color goldColor;
  final double totalDist;
  final String totalDuration;
  final VoidCallback? onTap;

  const _MapCard({
    required this.rides,
    required this.goldColor,
    required this.totalDist,
    required this.totalDuration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    // Collect all points for a single polyline
    final allPoints = rides.expand((r) => r.polylinePoints).toList();
    final firstRide = rides.first;
    final lastRide = rides.last;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 380,
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PolylineThumbnail(
                  points: allPoints,
                  startLabel: firstRide.startLocation,
                  endLabel: lastRide.endLocation,
                  color: Colors.yellow,
                  rideId: 'trip_${firstRide.id}_${lastRide.id}',
                ),
                // Unmerge Button
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_mosaic_outlined,
                          size: 14,
                          color: goldColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.unmerge,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Center Stats Overlay
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${totalDist.toStringAsFixed(1)} ${context.displayKms}",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: 10,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "............................",
                              style: TextStyle(color: theme.dividerColor),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 12,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          totalDuration,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Date/Time Footer
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.cardColor,
            child: Builder(
              builder: (context) {
                String formatDate(String rawDate) {
                  try {
                    DateTime? parsedDate;
                    try {
                      parsedDate = DateFormat('dd/MM/yyyy').parse(rawDate);
                    } catch (_) {
                      try {
                        parsedDate = DateTime.parse(rawDate);
                      } catch (_) {}
                    }
                    if (parsedDate != null) {
                      final now = DateTime.now();
                      if (parsedDate.year == now.year &&
                          parsedDate.month == now.month &&
                          parsedDate.day == now.day) {
                        return l10n.today;
                      }
                      return DateFormat('dd/MM/yyyy').format(parsedDate);
                    } else {
                      final now = DateTime.now();
                      if (rawDate == "${now.day}/${now.month}/${now.year}" ||
                          rawDate == DateFormat('dd/MM/yyyy').format(now)) {
                        return l10n.today;
                      }
                    }
                  } catch (_) {}
                  return rawDate;
                }

                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${formatDate(firstRide.date)} ${firstRide.startTime}",
                            style: TextStyle(color: goldColor, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${formatDate(lastRide.date)} ${lastRide.endTime}",
                            style: TextStyle(color: goldColor, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ],
      ),
    )
    );
  }
}
