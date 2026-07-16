import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import '../../domain/entity/current_plan_entity.dart';
import '../../domain/usecase/get_current_data_plan_usecase.dart';
import '../../domain/usecase/get_recharge_plans_usecase.dart';
import 'device_data_state.dart';

class DeviceDataCubit extends Cubit<DeviceDataState> {
  final GetRechargePlansUseCase _getRechargePlansUseCase;
  final GetCurrentDataPlanUseCase _getCurrentDataPlanUseCase;

  DeviceDataCubit(
    this._getRechargePlansUseCase,
    this._getCurrentDataPlanUseCase,
  ) : super(const DeviceDataLoading());

  void load({String? customImei}) async {
    emit(const DeviceDataLoading());

    final imei = customImei ?? AppPreference.instance.getSync(key: AppPreference.IMEI);

    // Fetch recharge plans first (required)
    final plansResult = await _getRechargePlansUseCase();

    plansResult.fold(
      (failure) => emit(DeviceDataError(failure.message)),
      (plans) async {
        // Fetch current plan separately (optional – failure is silently ignored)
        CurrentPlanEntity? currentPlan;
        if (imei.isNotEmpty) {
          final currentPlanResult = await _getCurrentDataPlanUseCase(imei);
          currentPlanResult.fold(
            (_) => currentPlan = null,
            (plan) => currentPlan = plan,
          );
        }

        emit(DeviceDataLoaded(
          plans: plans,
          currentPlan: currentPlan,
        ));
      },
    );
  }

  void selectPlan(int index) {
    if (state is DeviceDataLoaded) {
      final current = state as DeviceDataLoaded;
      emit(current.copyWith(selectedIndex: index));
    }
  }
}