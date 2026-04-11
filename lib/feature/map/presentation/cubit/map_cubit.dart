import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/widgets/loading_screen_ol.dart';
import 'package:trackify/feature/map/domain/usecase/map_case.dart';

import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapCase _mapCase;

  MapCubit(this._mapCase) : super(MapInitial());

  Future<void> fetchVehicles() async {
    LoadingScreenOL().show();
    emit(MapLoading());

    final result = await _mapCase.fetchVehiclesByUserId();

    result.fold(
      (failure) {
        emit(MapError(failure.message ?? ""));
        LoadingScreenOL().hide();
      },
      (vehicleList) {
        emit(MapLoaded(vehicleList));
        LoadingScreenOL().hide();
      },
    );
  }
}
