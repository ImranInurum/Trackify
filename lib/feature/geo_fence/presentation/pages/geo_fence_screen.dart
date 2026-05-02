import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/geo_fence_cubit.dart';
import '../cubit/geo_fence_state.dart';
import '../widgets/geo_fence_empty_state.dart';
import 'add_geo_fence_screen.dart';

class GeoFenceScreen extends StatefulWidget {
  final String? vehicleName;
  const GeoFenceScreen({super.key, this.vehicleName});

  @override
  State<GeoFenceScreen> createState() => _GeoFenceScreenState();
}

class _GeoFenceScreenState extends State<GeoFenceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GeoFenceCubit>().fetchGeoFences();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<GeoFenceCubit, GeoFenceState>(
      builder: (context, state) {
        if (state is GeoFenceLoading) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
          );
        }

        if (state is GeoFenceError) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: Center(
              child: Text(
                state.message,
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),
          );
        }

        if (state is GeoFenceLoaded && state.geoFences.isNotEmpty) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              backgroundColor: colorScheme.surface,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "Geo-fence",
                style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: state.geoFences.length,
              itemBuilder: (context, index) {
                final fence = state.geoFences[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getIconForType(fence.type),
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fence.name,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Radius: ${fence.radius.toInt()}m",
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                                fontSize: 13,
                              ),
                            ),
                            if (fence.vehicleName != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                fence.vehicleName!,
                                style: TextStyle(
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Toggle Switch
                      Switch(
                        value: fence.isActive,
                        onChanged: (val) {
                          // TODO: Implement toggle action
                        },
                        activeColor: colorScheme.primary,
                        activeTrackColor: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                      // Popup Menu
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                        onSelected: (value) {
                          if (value == 'edit') {
                            // TODO: Implement edit
                          } else if (value == 'delete') {
                            // TODO: Implement delete
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddGeoFenceScreen(vehicleName: widget.vehicleName),
                  ),
                );
              },
              backgroundColor: colorScheme.primary,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 30, color: Colors.black),
            ),
          );
        }

        return GeoFenceEmptyState(
          onAddPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddGeoFenceScreen(vehicleName: widget.vehicleName),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'office':
        return Icons.apartment_outlined;
      case 'family':
        return Icons.person_outline;
      case 'parking':
        return Icons.local_parking_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }
}
