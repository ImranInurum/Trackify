import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import '../../domain/usecase/get_device_warranty_usecase.dart';
import 'device_warranty_state.dart';

class DeviceWarrantyCubit extends Cubit<DeviceWarrantyState> {
  final GetDeviceWarrantyUseCase _getDeviceWarrantyUseCase;

  DeviceWarrantyCubit(this._getDeviceWarrantyUseCase)
      : super(const DeviceWarrantyInitial());

  void load() async {
    emit(const DeviceWarrantyLoading());

    final imei = AppPreference.instance.getSync(key: AppPreference.IMEI);

    if (imei.isEmpty) {
      emit(const DeviceWarrantyError("IMEI not found"));
      return;
    }

    final result = await _getDeviceWarrantyUseCase(imei);

    result.fold(
      (failure) => emit(DeviceWarrantyError(failure.message)),
      (warranty) => emit(DeviceWarrantyLoaded(warranty)),
    );
  }
}
