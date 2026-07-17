import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import '../../data/entity/assign_device_request.dart';
import '../../domain/usecase/assign_device_use_case.dart';
import 'device_installation_state.dart';

class DeviceInstallationCubit extends Cubit<DeviceInstallationState> {
  final AssignDeviceUseCase _assignDeviceUseCase;

  DeviceInstallationCubit(this._assignDeviceUseCase) : super(DeviceInstallationInitial());

  Future<bool> checkImeiOnly(String imei) async {
    emit(DeviceInstallationLoading());
    final checkResult = await _assignDeviceUseCase.checkImeiAssigned(imei.trim());
    
    bool isAssigned = false;
    Exception? caughtError;
    checkResult.fold(
      (l) {
        debugPrint('Error checking IMEI: $l');
        caughtError = l;
      },
      (r) => isAssigned = r,
    );

    if (caughtError != null) {
      emit(DeviceInstallationFailure(caughtError as dynamic));
      return false;
    }

    if (isAssigned) {
      emit(DeviceInstallationImeiAlreadyAssigned());
      return false; // Stop further flow
    } else {
      emit(DeviceInstallationInitial()); // Remove loader, IMEI is free
      return true; // Safe to proceed
    }
  }

  Future<void> assignDevice({
    required String vehicleId,
    required String imei,
    String? uid,
  }) async {
    emit(DeviceInstallationLoading());
    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);

    final checkResult = await _assignDeviceUseCase.checkImeiAssigned(imei.trim());

    bool isAssigned = false;
    Exception? caughtError;
    checkResult.fold(
      (l) {
        debugPrint('Error checking IMEI: $l');
        caughtError = l;
      },
      (r) => isAssigned = r,
    );

    if (caughtError != null) {
      emit(DeviceInstallationFailure(caughtError as dynamic));
      return;
    }

    if (isAssigned) {
      emit(DeviceInstallationImeiAlreadyAssigned());
      return;
    }

    final request = AssignDeviceRequest(
      userId: userId,
      vehicleId: vehicleId,
      imei: imei,
      uid: (uid != null && uid.isNotEmpty) ? uid : userId,
    );
    final result = await _assignDeviceUseCase.assignDevice(request: request);

    result.fold(
      (exception) => emit(DeviceInstallationFailure(exception)),
      (_) {
        AppPreference.instance.set(key: AppPreference.IMEI, value: imei);
        AppPreference.instance.set(key: AppPreference.KEY_SELECTED_UID, value: vehicleId);
        emit(DeviceInstallationSuccess());
      },
    );
  }
}
