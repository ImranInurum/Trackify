import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:trackify/feature/profile/domain/use_case/profile_use_case.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_state.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';

import '../../../../../core/utils/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileUseCase _psUseCase;

  ProfileCubit(this._psUseCase) : super(ProfileInitial());

  Future<void> fetchVehicles() async {
    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);

    if (userId.isEmpty) {
      emit(const FetchVehicleError("User session not found. Please log in again."));
      return;
    }

    final box = Hive.box('map_cache');
    final cacheKey = 'profile_vehicles_$userId';
    final cachedData = box.get(cacheKey);

    List<Vehicle> cachedList = [];
    if (cachedData != null) {
      try {
        final decoded = jsonDecode(cachedData.toString()) as List<dynamic>;
        cachedList = decoded.map((e) => Vehicle.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        // Cache parsing failed, ignore
      }
    }

    if (cachedList.isNotEmpty) {
      emit(VehiclesLoaded(cachedList));
    } else {
      emit(VehiclesLoading());
    }

    final result = await _psUseCase.getVehicles(userId: userId);

    result.fold(
      (failure) {
        if (cachedList.isEmpty) {
          emit(FetchVehicleError(failure.message));
        }
      },
      (response) {
        final vehicles = response.vehicles ?? [];
        try {
          box.put(cacheKey, jsonEncode(vehicles.map((e) => e.toJson()).toList()));
        } catch (_) {
          // Cache saving failed, ignore
        }
        emit(VehiclesLoaded(vehicles));
      },
    );
  }

  void reset() {
    emit(ProfileInitial());
  }
}
