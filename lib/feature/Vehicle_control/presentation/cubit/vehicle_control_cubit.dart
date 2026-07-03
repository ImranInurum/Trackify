import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import '../../../../core/config/network/exceptions.dart';
import '../../domain/entities/vehicle_control_entity.dart';
import '../../domain/repositories/vehicle_control_repository.dart';
import '../state/vehicle_control_state.dart';
import 'package:trackify/main.dart';
import 'package:trackify/feature/map/presentation/cubit/map_cubit.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_cubit.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_cubit.dart';

class VehicleControlCubit extends Cubit<VehicleControlState> {
  final VehicleControlRepository repository;

  VehicleControlCubit(this.repository) : super(VehicleControlInitial());

  @override
  void emit(VehicleControlState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  void _refreshGlobalVehicleLists() {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      try {
        context.read<MapCubit>().fetchVehicles();
        context.read<MyGarageCubit>().fetchVehicles();
        context.read<ProfileCubit>().fetchVehicles();
      } catch (e) {
        // Handle gracefully if any cubit is not available
      }
    }
  }

  Future<void> loadVehicleDetails([String? vehicleIMEI]) async {
    try {
      final actualIMEI = (vehicleIMEI == null || vehicleIMEI.isEmpty)
          ? await AppPreference.instance.get(key: AppPreference.IMEI)
          : vehicleIMEI;

      if (actualIMEI.isEmpty) {
        emit(VehicleControlLoading());
        final vehicle = await repository.getVehicleControlDetails(actualIMEI);
        emit(VehicleControlLoaded(
          vehicle: vehicle,
          tempIcon: vehicle.selectedIcon,
          tempColor: vehicle.selectedColor,
        ));
        return;
      }

      VehicleControlEntity? cachedVehicle;
      final box = Hive.box('map_cache');
      final cacheData = box.get('vehicle_control_$actualIMEI');
      if (cacheData != null) {
        try {
          cachedVehicle = VehicleControlEntity.fromJson(jsonDecode(cacheData.toString()));
        } catch (_) {}
      }

      final isAlreadyLoaded = (state is VehicleControlLoaded &&
          (state as VehicleControlLoaded).vehicle.imei == actualIMEI);

      if (!isAlreadyLoaded) {
        if (cachedVehicle != null) {
          emit(VehicleControlLoaded(
            vehicle: cachedVehicle,
            tempIcon: cachedVehicle.selectedIcon,
            tempColor: cachedVehicle.selectedColor,
          ));
        } else {
          emit(VehicleControlLoading());
        }
      }

      final vehicle = await repository.getVehicleControlDetails(actualIMEI);

      // Save to cache
      await box.put('vehicle_control_$actualIMEI', jsonEncode(vehicle.toJson()));
      await AppPreference.instance.set(key: "last_vehicle_control_imei", value: actualIMEI);

      emit(VehicleControlLoaded(
        vehicle: vehicle,
        tempIcon: vehicle.selectedIcon,
        tempColor: vehicle.selectedColor,
      ));
    } on VehicleNotFoundException catch (e) {
      emit(VehicleControlLoaded(
        vehicle: e.fallbackVehicle,
        tempIcon: e.fallbackVehicle.selectedIcon,
        tempColor: e.fallbackVehicle.selectedColor,
        actionError: e.message,
      ));
    } catch (e) {
      final isConnectionError = e is NoInternetException ||
          e.toString().contains("SocketException") ||
          e.toString().contains("No Internet") ||
          e.toString().contains("Connection failed");

      if (state is VehicleControlLoaded) {
        final currentState = state as VehicleControlLoaded;
        if (!isConnectionError) {
          emit(currentState.copyWith(actionError: e.toString()));
        }
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  void updateLocalIcon(String icon) {
    if (state is VehicleControlLoaded) {
      final currentState = state as VehicleControlLoaded;
      emit(currentState.copyWith(tempIcon: icon));
    }
  }

  void updateLocalColor(String color) {
    if (state is VehicleControlLoaded) {
      final currentState = state as VehicleControlLoaded;
      emit(currentState.copyWith(tempColor: color));
    }
  }

  Future<void> saveChanges(String vehicleIMEI) async {
    final currentState = state;
    if (currentState is VehicleControlLoaded) {
      try {
        await repository.updateVehicleIcon(vehicleIMEI, currentState.tempIcon);
        await repository.updateVehicleColor(vehicleIMEI, currentState.tempColor);
        loadVehicleDetails(vehicleIMEI);
        _refreshGlobalVehicleLists();
      } catch (e) {
        emit(currentState.copyWith(actionError: e.toString()));
      }
    }
  }

  Future<void> updateTankCapacity(String vehicleIMEI, String capacity) async {
    final currentState = state;
    try {
      await repository.updateTankCapacity(vehicleIMEI, capacity);
      loadVehicleDetails(vehicleIMEI);
      _refreshGlobalVehicleLists();
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> updateMileage(String vehicleIMEI, String mileage) async {
    final currentState = state;
    try {
      await repository.updateMileage(vehicleIMEI, mileage);
      loadVehicleDetails(vehicleIMEI);
      _refreshGlobalVehicleLists();
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> updateVehicleDetails({
    required String vehicleIMEI,
    required String vehicleName,
    required String vehicleNumber,
    required String fuelType,
    required String vehicleType,
    required String vehicleMaker,
    required String vehicleModel,
    required String brandId,
    required String modelId,
  }) async {
    final currentState = state;
    try {
      await repository.updateVehicleDetails(
        vehicleIMEI: vehicleIMEI,
        vehicleName: vehicleName,
        vehicleNumber: vehicleNumber,
        fuelType: fuelType,
        vehicleType: vehicleType,
        vehicleMaker: vehicleMaker,
        vehicleModel: vehicleModel,
        brandId: brandId,
        modelId: modelId,
      );
      loadVehicleDetails(vehicleIMEI);
      _refreshGlobalVehicleLists();
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> updateVehicleImage(String vehicleIMEI, String imagePath) async {
    final currentState = state;
    try {
      await repository.updateVehicleImage(vehicleIMEI, imagePath);
      loadVehicleDetails(vehicleIMEI);
      _refreshGlobalVehicleLists();
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> updateVehicleLock(String vehicleIMEI, bool lockState) async {
    final currentState = state;
    try {
      await repository.updateVehicleLock(vehicleIMEI, lockState);
      loadVehicleDetails(vehicleIMEI);
      _refreshGlobalVehicleLists();
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> deleteVehicle(String vehicleId, String vehicleIMEI) async {
    final currentState = state;
    try {
      emit(VehicleControlLoading());
      await repository.deleteVehicle(vehicleId);
      
      final box = Hive.box('map_cache');
      await box.delete('vehicle_control_$vehicleIMEI');
      
      final lastViewedIMEI = await AppPreference.instance.get(key: "last_vehicle_control_imei");
      if (lastViewedIMEI == vehicleIMEI) {
        await AppPreference.instance.clearByKey(key: "last_vehicle_control_imei");
      }

      emit(const VehicleControlDeleted());
      _refreshGlobalVehicleLists();
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }
}
