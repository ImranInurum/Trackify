import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_device_warranty_status.dart';
import '../../data/model/warranty_status_model.dart';
import 'package:equatable/equatable.dart';

part 'device_warranty_status_state.dart';

class DeviceWarrantyStatusCubit extends Cubit<DeviceWarrantyStatusState> {
  final GetDeviceWarrantyStatus _getDeviceWarrantyStatus;

  DeviceWarrantyStatusCubit(this._getDeviceWarrantyStatus)
      : super(DeviceWarrantyStatusInitial());

  Future<void> fetchWarrantyStatus(String imei) async {
    emit(DeviceWarrantyStatusLoading());
    final result = await _getDeviceWarrantyStatus(imei);
    result.fold(
      (failure) => emit(DeviceWarrantyStatusError(failure.message)),
      (data) => emit(DeviceWarrantyStatusLoaded(data)),
    );
  }
}
