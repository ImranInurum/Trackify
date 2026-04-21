import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import '../../data/entity/assign_device_request.dart';
import '../../domain/usecase/assign_device_use_case.dart';
import 'device_installation_state.dart';

class DeviceInstallationCubit extends Cubit<DeviceInstallationState> {
  final AssignDeviceUseCase _assignDeviceUseCase;

  DeviceInstallationCubit(this._assignDeviceUseCase) : super(DeviceInstallationInitial());

  Future<void> assignDevice({
    required String vehicleId,
    required String imei,
    String? uid,
  }) async {
    emit(DeviceInstallationLoading());

    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);

    final request = AssignDeviceRequest(
      userId: userId,
      vehicleId: vehicleId,
      imei: imei,
      uid: uid
    );
    final result = await _assignDeviceUseCase.assignDevice(request: request);

    result.fold(
      (exception) => emit(DeviceInstallationFailure(exception)),
      (_) => emit(DeviceInstallationSuccess()),
    );
  }
}
