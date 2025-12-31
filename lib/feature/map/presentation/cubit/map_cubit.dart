import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/core/widgets/loading_screen_ol.dart';
import 'package:trackify/feature/map/domain/usecase/map_case.dart';

import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapCase _mapCase;

  MapCubit(this._mapCase) : super(MapInitial());

  Future<void> fetchDevices(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(MapLoading());

    final result = await _mapCase.fetchDeviceByUserId(body);

    result.fold(
      (failure) {
        emit(MapError(failure.message ?? ""));
        LoadingScreenOL().hide();
      },
      (deviceList) {
        emit(MapLoaded(deviceList));
        LoadingScreenOL().hide();
      },
    );
  }

  Future<void> fetchDeviceDataByDate({
    required String imei,
    required String startDate,
    String? endDate,
  }) async {
    final body = {"imei": imei, "start_date": startDate, "end_date": endDate};
    LoadingScreenOL().show();
    emit(MapLoading());

    final result = await _mapCase.fetchDeviceDataByDate(body);

    result.fold(
      (failure) {
        emit(MapError(failure.message ?? ""));
        LoadingScreenOL().hide();
      },
      (deviceDataByDate) {
        final list = deviceDataByDate.data ?? [];
        final List<LatLng> points = [];

        for (var item in list) {
          try {
            if (item.gs == 'B') continue;

            final double? lat = double.tryParse(item.lt ?? '');
            final double? lng = double.tryParse(item.lg ?? '');
            if (lat == null || lng == null) continue;

            double correctedLat = item.ns == 'S' ? -lat : lat;
            double correctedLng = item.ew == 'W' ? -lng : lng;

            points.add(LatLng(correctedLat, correctedLng));
          } catch (e) {}
        }

        final Set<Polyline> polylines = {
          Polyline(
            polylineId: const PolylineId("ride_path"),
            points: points,
            color: Colors.blueAccent,
            width: 4,
          ),
        };

        emit(MapDataByDateLoaded(data: list, polylines: polylines));
        LoadingScreenOL().hide();
      },
    );
  }
}
