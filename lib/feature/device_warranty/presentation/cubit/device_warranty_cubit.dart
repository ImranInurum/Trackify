import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/app/app_navigation.dart';
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
      (warranty) {
        final daysLeft = warranty.warranty?.daysLeft;
        final expired = daysLeft != null ? (daysLeft <= 0) : true;
        AppPreference.instance.setBool(key: 'KEY_WARRANTY_EXPIRED', value: expired).then((_) {
          AppNavigation.refreshNavigationState();
        });
        emit(DeviceWarrantyLoaded(warranty));
      },
    );
  }
}
