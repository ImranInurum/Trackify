import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import '../../../../core/config/network/exceptions.dart';
import '../../domain/entities/vehicle_control_entity.dart';
import '../../domain/repositories/vehicle_control_repository.dart';
import '../state/vehicle_control_state.dart';
import 'package:trackify/main.dart';
import 'package:trackify/feature/map/presentation/cubit/map_cubit.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_cubit.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';

class VehicleControlCubit extends Cubit<VehicleControlState> {
  final VehicleControlRepository repository;

  VehicleControlCubit(this.repository) : super(VehicleControlInitial());

  /// Directly loads vehicle details from a [Vehicle] object without making
  /// any API call. Used for vehicles that have no device installed (empty IMEI),
  /// so we show the vehicle's profile data instead of fetching live device data.
  void loadFromVehicle(Vehicle vehicle) {
    final maker = vehicle.vehicleMaker?.trim() ?? '';
    final model = vehicle.vehicleModel?.trim() ?? '';
    final combined = (maker.isNotEmpty && model.isNotEmpty)
        ? '$maker $model'
        : (model.isNotEmpty ? model : maker);

    final entity = VehicleControlEntity(
      id: vehicle.id ?? '',
      imei: vehicle.imei ?? '',
      vehicleName: combined,
      vehicleNumber: vehicle.vehicleNumber ?? '',
      fuelType: vehicle.fuelType ?? '',
      tankCapacity: vehicle.tankCapacity ?? '',
      vehicleMileage: vehicle.mileage ?? '',
      bikeImage: null,
      selectedIcon: 'Bike',
      selectedColor: 'White',
      vehicleLock: false,
      vehicleType: vehicle.vehicleType ?? '',
      vehicleMaker: maker,
      vehicleModel: model,
    );

    emit(
      VehicleControlLoaded(
        vehicle: entity,
        tempIcon: entity.selectedIcon,
        tempColor: entity.selectedColor,
      ),
    );
  }

  @override
  void emit(VehicleControlState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  void _refreshGlobalVehicleLists({bool forceRefresh = false}) {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      try {
        context.read<MapCubit>().fetchVehicles(forceRefresh: forceRefresh);
        context.read<MyGarageCubit>().fetchVehicles();
        context.read<ProfileCubit>().fetchVehicles();
      } catch (e) {
        // Handle gracefully if any cubit is not available
      }
    }
  }

  Future<void> loadVehicleDetails([String? vehicleIdParam, String? vehicleIMEI]) async {
    try {
      final actualIMEI = (vehicleIMEI == null || vehicleIMEI.isEmpty)
          ? await AppPreference.instance.get(key: AppPreference.IMEI)
          : vehicleIMEI;
          
      final actualId = (vehicleIdParam == null || vehicleIdParam.isEmpty)
          ? await AppPreference.instance.get(key: AppPreference.KEY_SELECTED_UID)
          : vehicleIdParam;

      if (actualId.isEmpty && actualIMEI.isEmpty) {
        emit(VehicleControlLoading());
        final vehicle = await repository.getVehicleControlDetails(actualId, actualIMEI);
        emit(
          VehicleControlLoaded(
            vehicle: vehicle,
            tempIcon: vehicle.selectedIcon,
            tempColor: vehicle.selectedColor,
          ),
        );
        return;
      }

      final cacheKey = actualId.isNotEmpty ? actualId : actualIMEI;
      VehicleControlEntity? cachedVehicle;
      final box = Hive.box('map_cache');
      final cacheData = box.get('vehicle_control_$cacheKey');
      if (cacheData != null) {
        try {
          cachedVehicle = VehicleControlEntity.fromJson(
            jsonDecode(cacheData.toString()),
          );
        } catch (_) {}
      }

      final isAlreadyLoaded =
          (state is VehicleControlLoaded &&
          (state as VehicleControlLoaded).vehicle.id == cacheKey);

      if (!isAlreadyLoaded) {
        if (cachedVehicle != null) {
          emit(
            VehicleControlLoaded(
              vehicle: cachedVehicle,
              tempIcon: cachedVehicle.selectedIcon,
              tempColor: cachedVehicle.selectedColor,
            ),
          );
        } else {
          emit(VehicleControlLoading());
        }
      }

      final vehicle = await repository.getVehicleControlDetails(actualId, actualIMEI);

      // Save to cache
      await box.put(
        'vehicle_control_$cacheKey',
        jsonEncode(vehicle.toJson()),
      );
      await AppPreference.instance.set(
        key: "last_vehicle_control_id",
        value: cacheKey,
      );

      emit(
        VehicleControlLoaded(
          vehicle: vehicle,
          tempIcon: vehicle.selectedIcon,
          tempColor: vehicle.selectedColor,
        ),
      );

      if (vehicle.imei.isNotEmpty) {
        _fetchStatistics(vehicle.imei);
      }
    } on VehicleNotFoundException catch (e) {
      emit(
        VehicleControlLoaded(
          vehicle: e.fallbackVehicle,
          tempIcon: e.fallbackVehicle.selectedIcon,
          tempColor: e.fallbackVehicle.selectedColor,
          actionError: e.message,
        ),
      );
    } catch (e) {
      final isConnectionError =
          e is NoInternetException ||
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
      final vehicleId = currentState.vehicle.id;
      
      final json = currentState.vehicle.toJson();
      json['selectedIcon'] = currentState.tempIcon;
      json['selectedColor'] = currentState.tempColor;
      final updatedVehicle = VehicleControlEntity.fromJson(json);
      emit(currentState.copyWith(vehicle: updatedVehicle));
      
      try {
        await repository.updateVehicleIcon(vehicleId, currentState.tempIcon);
        await repository.updateVehicleColor(
          vehicleId,
          currentState.tempColor,
        );
        
        final box = Hive.box('map_cache');
        await box.put(
          'vehicle_control_${updatedVehicle.id}',
          jsonEncode(updatedVehicle.toJson()),
        );

        _refreshGlobalVehicleLists();
      } catch (e) {
        emit(currentState.copyWith(actionError: e.toString()));
      }
    }
  }

  Future<void> updateTankCapacity(String vehicleIMEI, String capacity) async {
    final currentState = state;
    try {
      if (currentState is VehicleControlLoaded) {
        final json = currentState.vehicle.toJson();
        json['tankCapacity'] = capacity;
        final updatedVehicle = VehicleControlEntity.fromJson(json);
        emit(currentState.copyWith(vehicle: updatedVehicle));
        
        await repository.updateTankCapacity(
          currentState.vehicle.id,
          capacity,
          currentState.vehicle.vehicleMileage,
        );
        
        final box = Hive.box('map_cache');
        await box.put(
          'vehicle_control_${updatedVehicle.id}',
          jsonEncode(updatedVehicle.toJson()),
        );
      } else {
        await repository.updateTankCapacity(vehicleIMEI, capacity, '');
        loadVehicleDetails(null, vehicleIMEI);
      }
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
      if (currentState is VehicleControlLoaded) {
        final json = currentState.vehicle.toJson();
        json['vehicleMileage'] = mileage;
        final updatedVehicle = VehicleControlEntity.fromJson(json);
        emit(currentState.copyWith(vehicle: updatedVehicle));
        
        await repository.updateMileage(
          currentState.vehicle.id,
          mileage,
          currentState.vehicle.tankCapacity,
        );
        
        final box = Hive.box('map_cache');
        await box.put(
          'vehicle_control_${updatedVehicle.id}',
          jsonEncode(updatedVehicle.toJson()),
        );
      } else {
        await repository.updateMileage(vehicleIMEI, mileage, '');
        loadVehicleDetails(null, vehicleIMEI);
      }
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
    required String vehicleId,
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
      if (currentState is VehicleControlLoaded) {
        final json = currentState.vehicle.toJson();
        json['vehicleName'] = vehicleName;
        json['vehicleNumber'] = vehicleNumber;
        json['fuelType'] = fuelType;
        json['vehicleType'] = vehicleType;
        json['vehicleMaker'] = vehicleMaker;
        json['vehicleModel'] = vehicleModel;
        json['brandId'] = brandId;
        json['modelId'] = modelId;
        final updatedVehicle = VehicleControlEntity.fromJson(json);
        emit(currentState.copyWith(vehicle: updatedVehicle));
      }
      
      await repository.updateVehicleDetails(
        vehicleId: vehicleId,
        vehicleName: vehicleName,
        vehicleNumber: vehicleNumber,
        fuelType: fuelType,
        vehicleType: vehicleType,
        vehicleMaker: vehicleMaker,
        vehicleModel: vehicleModel,
        brandId: brandId,
        modelId: modelId,
      );
      if (currentState is VehicleControlLoaded) {
        loadVehicleDetails(currentState.vehicle.id, currentState.vehicle.imei);
      } else {
        loadVehicleDetails(vehicleId, null);
      }
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
      if (currentState is VehicleControlLoaded) {
        final json = currentState.vehicle.toJson();
        json['bikeImage'] = imagePath;
        final updatedVehicle = VehicleControlEntity.fromJson(json);
        emit(currentState.copyWith(vehicle: updatedVehicle));
        
        await repository.updateVehicleImage(currentState.vehicle.id, imagePath);
      } else {
        await repository.updateVehicleImage(vehicleIMEI, imagePath);
      }
      if (currentState is VehicleControlLoaded) {
        loadVehicleDetails(currentState.vehicle.id, vehicleIMEI);
      } else {
        loadVehicleDetails(null, vehicleIMEI);
      }
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
      if (currentState is VehicleControlLoaded) {
        final json = currentState.vehicle.toJson();
        json['vehicleLock'] = lockState;
        final updatedVehicle = VehicleControlEntity.fromJson(json);
        emit(currentState.copyWith(vehicle: updatedVehicle));
        
        await repository.updateVehicleLock(currentState.vehicle.id, lockState);
      } else {
        await repository.updateVehicleLock(vehicleIMEI, lockState);
      }
      if (currentState is VehicleControlLoaded) {
        loadVehicleDetails(currentState.vehicle.id, vehicleIMEI);
      } else {
        loadVehicleDetails(null, vehicleIMEI);
      }
      _refreshGlobalVehicleLists();
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<Map<String, dynamic>?> fetchDefaultVehicleModelDetails(String vehicleId) async {
    try {
      if (vehicleId.isEmpty) return null;
      return await repository.getVehicleModelDetails(vehicleId);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteVehicle(String vehicleId, String vehicleIMEI) async {
    final currentState = state;
    try {
      emit(VehicleControlLoading());
      await repository.deleteVehicle(vehicleId);

      final box = Hive.box('map_cache');
      final cacheKey = vehicleId.isNotEmpty ? vehicleId : vehicleIMEI;
      await box.delete('vehicle_control_$cacheKey');
      await box.delete('vehicles_data');
      await box.delete('common_vehicles_data');

      final prefs = AppPreference.instance;
      final userId = await prefs.get(key: AppPreference.KEY_USER_ID);
      if (userId.isNotEmpty) {
        await box.delete('profile_vehicles_$userId');
      }

      final lastViewedId = await prefs.get(key: "last_vehicle_control_id");
      if (lastViewedId == cacheKey) {
        await prefs.clearByKey(key: "last_vehicle_control_id");
      }

      // If the deleted vehicle was the currently selected one, clear selected preferences
      final currentSelectedUid = await prefs.get(
        key: AppPreference.KEY_SELECTED_UID,
      );
      final currentSelectedImei = await prefs.get(key: AppPreference.IMEI);
      if (currentSelectedUid == vehicleId ||
          (vehicleIMEI.isNotEmpty && currentSelectedImei == vehicleIMEI)) {
        await prefs.set(key: AppPreference.KEY_SELECTED_UID, value: '');
        await prefs.set(key: AppPreference.IMEI, value: '');
      }

      emit(const VehicleControlDeleted());
      _refreshGlobalVehicleLists(forceRefresh: true);
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }
  Future<void> _fetchStatistics(String imei) async {
    try {
      final unit = await AppPreference.instance.get(key: AppPreference.KEY_DISTANCE_UNIT);
      final url = ApiURL.statistics(imei, unit: unit.isNotEmpty ? unit : 'km');
      final apiService = NetworkApiService();
      final response = await apiService.getGetApiResponse(url);

      response.fold(
        (failure) {
          // Handle silently
        },
        (data) {
          if (state is VehicleControlLoaded) {
            final currentState = state as VehicleControlLoaded;
            
            String distance = "0.0";
            String hours = "0";
            String minutes = "0";

            if (data is Map<String, dynamic> && data['data'] != null && data['data']['journey'] != null) {
              final journey = data['data']['journey'];
              final distVal = journey['distanceTravelled'];
              if (distVal is double) {
                distance = distVal.toStringAsFixed(1);
              } else if (distVal is int) {
                distance = distVal.toString();
              } else {
                distance = distVal?.toString() ?? "0.0";
              }
              
              int totalMinutes = 0;
              final minsVal = journey['timeDurationMinutes'];
              if (minsVal is int) {
                totalMinutes = minsVal;
              } else if (minsVal is String) {
                totalMinutes = int.tryParse(minsVal) ?? 0;
              }
              
              hours = (totalMinutes ~/ 60).toString();
              minutes = (totalMinutes % 60).toString();
            }

            emit(
              currentState.copyWith(
                journeyDistance: distance,
                journeyHours: hours,
                journeyMinutes: minutes,
              ),
            );
          }
        },
      );
    } catch (e) {
      // Handle silently
    }
  }
}
