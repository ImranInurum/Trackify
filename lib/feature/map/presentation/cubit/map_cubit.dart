import 'package:flutter_bloc/flutter_bloc.dart';
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
    final body = {"imei": imei, "start_date": "2025-12-24", "end_date": "2025-12-25"};
    LoadingScreenOL().show();
    emit(MapLoading());

    final result = await _mapCase.fetchDeviceDataByDate(body);

    result.fold(
      (failure) {
        emit(MapError(failure.message ?? ""));
        LoadingScreenOL().hide();
      },
      (deviceDataByDate) {
        print("deviceDataByDate : ${deviceDataByDate.data?.length}");
        LoadingScreenOL().hide();
      },
    );
  }
}
