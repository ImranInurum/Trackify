import 'package:flutter_bloc/flutter_bloc.dart';

import 'device_data_state.dart';

class DeviceDataCubit extends Cubit<DeviceDataState> {
  DeviceDataCubit() : super(DeviceDataLoading());

  void load() async {
    await Future.delayed(const Duration(milliseconds: 400));
    emit(DeviceDataLoaded());
  }

  void selectPlan(int index) {
    if (state is DeviceDataLoaded) {
      final current = state as DeviceDataLoaded;
      emit(current.copyWith(selectedIndex: index));
    }
  }
}