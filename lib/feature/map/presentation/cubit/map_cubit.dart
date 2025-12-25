import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/map/domain/usecase/map_case.dart';

import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapCase _mapCase;

  MapCubit(this._mapCase) : super(MapInitial());

  Future<void> fetchDevices(Map<String, dynamic> body) async {
    emit(MapLoading());

    final result = await _mapCase.fetchDeviceByUserId(body);

    result.fold(
      (failure) => emit(MapError(failure.message ?? "")),
      (deviceList) => emit(MapLoaded(deviceList)),
    );
  }
}
