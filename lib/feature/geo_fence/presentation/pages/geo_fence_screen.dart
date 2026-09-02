import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';

import '../../domain/entity/geo_fence_entity.dart';
import '../cubit/geo_fence_cubit.dart';
import '../cubit/geo_fence_state.dart';
import '../widgets/geo_fence_empty_state.dart';
import 'add_geo_fence_screen.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class GeoFenceScreen extends StatefulWidget {
  final String? vehicleName;
  final String? imei;
  const GeoFenceScreen({super.key, this.vehicleName, this.imei});

  @override
  State<GeoFenceScreen> createState() => _GeoFenceScreenState();
}

class _GeoFenceScreenState extends State<GeoFenceScreen> {

  @override
  void initState() {
    super.initState();
    if (widget.imei != null) {
      context.read<GeoFenceCubit>().fetchGeoFences(widget.imei!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<GeoFenceCubit, GeoFenceState>(
      listener: (context, state) {
        if (state is GeoFenceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<GeoFenceCubit, GeoFenceState>(
        buildWhen: (previous, current) =>
            current is GeoFenceLoading ||
            current is GeoFenceLoaded ||
            current is GeoFenceError,
        builder: (context, state) {
          if (state is GeoFenceLoaded) {
            if (state.geoFences.isEmpty) {
              return GeoFenceEmptyState(
                onAddPressed: () => _navigateToAddScreen(),
              );
            }
            return Scaffold(
              backgroundColor: colorScheme.surface,
              appBar: AppBar(
                backgroundColor: colorScheme.surface,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  AppLocalizations.of(context)!.geoFenceTitle, ),
              ),
              body: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: state.geoFences.length,
                itemBuilder: (context, index) {
                  final fence = state.geoFences[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withOpacity( 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withOpacity( 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getIconForType(fence.type),
                            color: colorScheme.onSurface.withOpacity( 0.7),
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
                                AppLocalizations.of(context)!.geoFenceRadius(
                                  fence.radius.toInt().toString(),
                                ),
                                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 13,
                                ),
                              ),
                              if (fence.vehicleName != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  fence.vehicleName!,
                                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6),
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
                            if (!val) {
                              _showToggleConfirmation(context, fence);
                            } else {
                              context.read<GeoFenceCubit>().toggleGeoFenceStatus(fence.id, true);
                            }
                          },
                          activeColor: colorScheme.primary,
                          activeTrackColor: colorScheme.primary.withOpacity(0.3),
                        ),
                        // Popup Menu
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: colorScheme.onSurface.withOpacity( 0.7),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _navigateToAddScreen(initialFence: fence);
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(context, fence.imei, fence.id);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(AppLocalizations.of(context)!.edit),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(AppLocalizations.of(context)!.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _navigateToAddScreen(),
                backgroundColor: colorScheme.primary,
                shape: const CircleBorder(),
                child: Icon(Icons.add, size: 30, color: colorScheme.onPrimary),
              ),
            );
          }

          if (state is GeoFenceError) {
            return GeoFenceEmptyState(
              onAddPressed: () => _navigateToAddScreen(),
            );
          }

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: const Center(child: TrackifyLoader()),
          );
        },
      ),
    );
  }

  Future<void> _navigateToAddScreen({GeoFenceEntity? initialFence}) async {
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGeoFenceScreen(
          vehicleName: widget.vehicleName,
          imei: widget.imei,
          initialFence: initialFence,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String imei, String fenceId) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            l10n.geoFenceDeleteConfirmation,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: colorScheme.onSurface.withOpacity( 0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<GeoFenceCubit>().deleteGeoFence(imei, fenceId);
            },
            child: Text(
              l10n.delete,
              style: TextStyle(color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToggleConfirmation(BuildContext context, GeoFenceEntity fence) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            l10n.geoFenceTurnOffConfirmation,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: colorScheme.onSurface.withOpacity( 0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<GeoFenceCubit>().toggleGeoFenceStatus(fence.id, false);
            },
            child: Text(
              l10n.turnOff,
              style: TextStyle(color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
