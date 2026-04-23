import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_state.dart';

import '../../domain/usecase/ride_history_use_case.dart';


class RideHistoryCubit extends Cubit<RideHistoryState> {
  final RideHistoryUseCase _assignDeviceUseCase;

  RideHistoryCubit(this._assignDeviceUseCase) : super(RideHistoryInitial());
  final prefs = AppPreference.instance;
  Future<void> getRideHistoryData() async {
    emit(RideHistoryLoading());
    await Future.delayed(const Duration(seconds: 2));
    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);
    final iMEI = await prefs.get(key: AppPreference.IMEI);
    final request = {
      'imei': iMEI ,
    };
    debugPrint('Assigning device with request: $request');
    final result = await _assignDeviceUseCase.getRideHistory(body: request);
    result.fold(
          (exception) => emit(RideHistoryFailure(exception)),
          (data) => emit(RideHistorySuccess(data)),
    );
  }
}
