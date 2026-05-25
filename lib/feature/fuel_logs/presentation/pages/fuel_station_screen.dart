import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/fuel_logs/presentation/pages/widgets/fuel_stations_tab_view.dart';
import 'package:trackify/feature/fuel_logs/presentation/cubit/fuel_stations_cubit.dart';
import 'package:trackify/feature/fuel_logs/data/repository/overpass_service.dart';
import 'package:trackify/l10n/app_localizations.dart';

class FuelStationScreen extends StatelessWidget {
  const FuelStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => FuelStationsCubit(OverpassService())..fetchNearbyStations(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.fuelStations),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const FuelStationsTabView(),
      ),
    );
  }
}
