import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:trackify/core/widgets/loading_screen_ol.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';
import 'package:trackify/feature/map/domain/usecase/map_case.dart';

import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapCase _mapCase;

  MapCubit(this._mapCase) : super(MapInitial());

  Future<void> fetchVehicles() async {
    final box = Hive.box('map_cache');
    final cachedData = box.get('vehicles_data');

    UserVehicles? cachedList;
    if (cachedData != null) {
      try {
        final decoded = jsonDecode(cachedData.toString()) as Map<String, dynamic>;
        cachedList = UserVehicles.fromJson(decoded);
      } catch (_) {
        // Cache parsing failed, ignore
      }
    }

    if (cachedList != null) {
      emit(MapLoaded(cachedList));
    } else {
      LoadingScreenOL().show();
      emit(MapLoading());
    }

    final result = await _mapCase.fetchVehiclesByUserId();

    result.fold(
      (failure) {
        if (cachedList == null) {
          emit(MapError(failure.message));
        }
        LoadingScreenOL().hide();
      },
      (vehicleList) {
        try {
          box.put('vehicles_data', jsonEncode(vehicleList.toJson()));
        } catch (_) {
          // Cache saving failed, ignore
        }
        emit(MapLoaded(vehicleList));
        LoadingScreenOL().hide();
      },
    );
  }

  void reset() {
    emit(MapInitial());
  }
}
