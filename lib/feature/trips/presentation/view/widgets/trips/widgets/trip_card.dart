import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/polyline_thumbnail.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/utils/distance_utils.dart';


class TripCard extends StatelessWidget {
  final String title;
  final List<Ride> rides;
  final VoidCallback onTap;
  final String? imagePath;
  final String savedUnit;

  const TripCard({
    super.key,
    required this.title,
    required this.rides,
    required this.onTap,
    this.imagePath,
    this.savedUnit = 'km',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;
    final currentUnit = context.watch<AppCubit>().state.distanceUnit;
    
    double totalDist = 0;
    for (var r in rides) {
      totalDist += DistanceUnitExt.convertDistance(r.distance, savedUnit, currentUnit);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
        ),
        child: Row(
          children: [
            /// THUMBNAIL ON LEFT
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 100,
                height: 70,
                child: imagePath != null && File(imagePath!).existsSync()
                    ? Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/explore_app_image.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            
            /// TITLE AND STATS ON RIGHT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: goldColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.5), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${totalDist.toStringAsFixed(1)} ${context.displayKms}",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 14,
                        width: 1,
                        color: theme.dividerColor.withValues(alpha: 0.3),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.route_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.5), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        l10n.ridesCount(rides.length.toString()),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
