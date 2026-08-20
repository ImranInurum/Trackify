import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import 'package:trackify/feature/fuel_logs/presentation/cubit/fuel_stations_cubit.dart';
import 'package:trackify/feature/fuel_logs/presentation/cubit/fuel_stations_state.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../../data/model/fuel_station_model.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class NearbyFuelStationsDashboard extends StatelessWidget {
  const NearbyFuelStationsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    return BlocBuilder<FuelStationsCubit, FuelStationsState>(
      builder: (context, state) {
        if (state is FuelStationsLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: const Center(child: TrackifyLoader()),
          );
        }

        if (state is FuelStationsError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Text(
                  'Could not load stations',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: textScaler.scale(11),
                  ),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () =>
                      context.read<FuelStationsCubit>().fetchNearbyStations(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }

        if (state is! FuelStationsLoaded || state.stations.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No fuel stations found nearby',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: textScaler.scale(11),
                ),
              ),
            ),
          );
        }

        final stations = state.stations.take(4).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.fuelStationNearVehicle,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: textScaler.scale(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      l10n.seeAll,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: textScaler.scale(11),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Station rows (match second screenshot) ──
            ...stations.map((s) => _buildStationItem(context, s)),
          ],
        );
      },
    );
  }

  Widget _buildStationItem(BuildContext context, FuelStation station) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // ── Brand logo ──
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(child: _getBrandLogo(station.brand)),
                ),

                const SizedBox(width: 12),

                // ── Name + distance & price ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Station name
                      Text(
                        station.name,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: textScaler.scale(12),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Distance + price on the same line (matches screenshot 2)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: theme.colorScheme.onSurface,
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${station.distance?.toStringAsFixed(2) ?? '0.00'} km away',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: textScaler.scale(10),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '₹N/A',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: textScaler.scale(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Chevron ──
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBrandLogo(String? brand) {
    const fallback = Icon(Icons.local_gas_station, color: Colors.grey, size: 24);
    if (brand == null) return fallback;

    final b = brand.toLowerCase();
    String? url;

    if (b.contains('indian oil') || b.contains('iocl')) {
      url = 'https://upload.wikimedia.org/wikipedia/en/thumb/8/8c/Indian_Oil_Logo.svg/200px-Indian_Oil_Logo.svg.png';
    } else if (b.contains('bpcl') || b.contains('bharat petroleum')) {
      url = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/ef/Bharat_Petroleum_Logo.svg/200px-Bharat_Petroleum_Logo.svg.png';
    } else if (b.contains('hp') || b.contains('hindustan petroleum')) {
      url = 'https://upload.wikimedia.org/wikipedia/en/thumb/5/52/HP_Logo.svg/200px-HP_Logo.svg.png';
    } else if (b.contains('shell')) {
      url = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e8/Shell_logo.svg/200px-Shell_logo.svg.png';
    } else if (b.contains('nayara') || b.contains('essar')) {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Nayara_Energy_Logo.svg/200px-Nayara_Energy_Logo.svg.png';
    }

    if (url != null) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: Image.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => fallback,
        ),
      );
    }

    return fallback;
  }
}
