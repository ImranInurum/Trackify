import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/feature/my_garage/domain/use_case/my_garage_use_case.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_state.dart';
import '../../../../../core/utils/shared_preferences.dart';

class MyGarageCubit extends Cubit<MyGarageState> {
  final MyGarageUseCase _myGarageUseCase;

  MyGarageCubit(this._myGarageUseCase) : super(MyGarageInitial());

  Future<void> fetchVehicles() async {
    final box = Hive.box('map_cache');
    final cachedData = box.get('common_vehicles_data');

    List<Vehicle> cachedVehicles = [];
    if (cachedData != null) {
      try {
        final decoded = jsonDecode(cachedData.toString()) as Map<String, dynamic>;
        final response = VehicleListResponse.fromJson(decoded);
        cachedVehicles = response.vehicles ?? [];
      } catch (_) {}
    }

    if (cachedVehicles.isNotEmpty) {
      emit(VehiclesLoaded(cachedVehicles));
    } else {
      emit(VehiclesLoading());
    }

    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);

    if (userId.isEmpty) {
      if (state is! VehiclesLoaded) {
        emit(const FetchVehicleError("User session not found. Please log in again."));
      }
      return;
    }

    final result = await _myGarageUseCase.getVehicles(userId: userId);

    result.fold(
      (failure) {
        if (state is! VehiclesLoaded) {
          emit(FetchVehicleError(failure.message));
        }
      },
      (response) {
        final vehicles = response.vehicles ?? [];
        try {
          box.put('common_vehicles_data', jsonEncode(response.toJson()));
        } catch (_) {}
        emit(VehiclesLoaded(vehicles));
      },
    );
  }

  void reset() {
    emit(MyGarageInitial());
  }
}
