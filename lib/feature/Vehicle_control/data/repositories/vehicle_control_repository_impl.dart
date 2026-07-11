import 'dart:io';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import '../../domain/entities/vehicle_control_entity.dart';
import '../../domain/repositories/vehicle_control_repository.dart';

class VehicleControlRepositoryImpl implements VehicleControlRepository {
  final BaseApiServices _apiService = NetworkApiService();

  @override
  Future<VehicleControlEntity> getVehicleControlDetails(
    String vehicleIMEI,
  ) async {
    String actualIMEI = vehicleIMEI;
    if (actualIMEI.isEmpty) {
      try {
        final userId = await AppPreference.instance.get(
          key: AppPreference.KEY_USER_ID,
        );
        if (userId.isNotEmpty) {
          final vehiclesRes = await _apiService.getGetApiResponse(
            ApiURL.getVehiclesByUserId(userId),
          );
          vehiclesRes.fold((failure) => null, (data) {
            final list = VehicleListResponse.fromJson(data);
            if (list.vehicles != null && list.vehicles!.isNotEmpty) {
              final firstImei = list.vehicles!.first.imei;
              if (firstImei != null && firstImei.isNotEmpty) {
                actualIMEI = firstImei;
                // NOTE: Do NOT overwrite AppPreference.IMEI here.
                // The user's selected vehicle preference must only be changed
                // through explicit user actions, not as a side-effect of loading data.
              }
            }
          });
        }
      } catch (_) {}
    }

    // 1. Fetch details from vehicle-control GET api
    final controlResult = await _apiService.getGetApiResponse(
      ApiURL.getVehicleControl(actualIMEI),
    );

    AppException? apiFailure;
    Map<String, dynamic> controlData = {};
    controlResult.fold((failure) => apiFailure = failure, (data) {
      if (data is Map && data['success'] == true && data['data'] != null) {
        controlData = Map<String, dynamic>.from(data['data']);
      }
    });

    String vehicleName = "";
    String vehicleNumber = "";
    String fuelType = "";
    String vehicleType = '';
    String vehicleMaker = '';
    String vehicleModel = '';
    bool fallbackSuccess = false;

    if (controlData.containsKey('vehicleDetails') &&
        controlData['vehicleDetails'] != null) {
      final details = Map<String, dynamic>.from(controlData['vehicleDetails']);
      final maker = details['vehicleMaker'] ?? details['brandId'] ?? '';
      final model = details['vehicleModel'] ?? details['modelId'] ?? '';
      vehicleName = maker.isNotEmpty && model.isNotEmpty
          ? '$maker $model'
          : (model.isNotEmpty ? model : vehicleName);
      vehicleNumber = details['vehicleNumber'] ?? vehicleNumber;
      fuelType = details['fuelType'] ?? fuelType;
      vehicleType = details['vehicleType'] ?? '';
      vehicleMaker = maker;
      vehicleModel = model;
    } else {
      try {
        final userId = await AppPreference.instance.get(
          key: AppPreference.KEY_USER_ID,
        );
        if (userId.isNotEmpty) {
          final vehiclesRes = await _apiService.getGetApiResponse(
            ApiURL.getVehiclesByUserId(userId),
          );
          vehiclesRes.fold((failure) => null, (data) {
            final list = VehicleListResponse.fromJson(data);
            final match = list.vehicles?.firstWhere(
              (v) => v.imei == vehicleIMEI,
              orElse: () => Vehicle(),
            );
            if (match != null && match.id != null) {
              vehicleName = match.vehicleModel ?? vehicleName;
              vehicleNumber = match.vehicleNumber ?? vehicleNumber;
              fuelType = match.fuelType ?? fuelType;
              vehicleType = match.vehicleType ?? vehicleType;
              vehicleMaker = match.vehicleMaker ?? match.brandId ?? vehicleMaker;
              vehicleModel = match.vehicleModel ?? vehicleModel;
              fallbackSuccess = true;
            }
          });
        }
      } catch (_) {}
    }

    String tankCapacity = '';
    String vehicleMileage = '';
    // Try to load tankCapacity & mileage from vehicle list first as fallback
    try {
      final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);
      if (userId.isNotEmpty) {
        final vehiclesRes = await _apiService.getGetApiResponse(ApiURL.getVehiclesByUserId(userId));
        vehiclesRes.fold((failure) => null, (data) {
          final list = VehicleListResponse.fromJson(data);
          final match = list.vehicles?.firstWhere(
            (v) => v.imei == actualIMEI,
            orElse: () => Vehicle(),
          );
          if (match != null && match.id != null) {
            if (tankCapacity.isEmpty) tankCapacity = match.tankCapacity ?? '';
            if (vehicleMileage.isEmpty) vehicleMileage = match.mileage ?? '';
            if (vehicleType.isEmpty) vehicleType = match.vehicleType ?? '';
            if (vehicleMaker.isEmpty) vehicleMaker = match.vehicleMaker ?? match.brandId ?? '';
            if (vehicleModel.isEmpty) vehicleModel = match.vehicleModel ?? '';
            if (fuelType.isEmpty) fuelType = match.fuelType ?? '';
            if (vehicleNumber.isEmpty) vehicleNumber = match.vehicleNumber ?? '';
          }
        });
      }
    } catch (_) {}

    // Override with control API data if available
    if (controlData.containsKey('tankCapacity') && controlData['tankCapacity'] != null) {
      tankCapacity = controlData['tankCapacity'].toString();
    }
    if (controlData.containsKey('vehicleMileage') && controlData['vehicleMileage'] != null) {
      vehicleMileage = controlData['vehicleMileage'].toString();
    }
    final selectedIcon = controlData['vehicleIcon'] ?? 'Bike';
    final selectedColor = controlData['vehicleColor'] ?? 'White';
    final vehicleLock = controlData['vehicleLock'] ?? false;

    String? bikeImage;
    if (controlData['vehicleImage'] != null) {
      final img = controlData['vehicleImage'].toString();
      bikeImage = img.startsWith('http') ? img : '${ApiURL.baseURL}/$img';
    }

    final entity = VehicleControlEntity(
      id: actualIMEI,
      vehicleName: vehicleName,
      vehicleNumber: vehicleNumber,
      fuelType: fuelType,
      tankCapacity: tankCapacity,
      vehicleMileage: vehicleMileage,
      bikeImage: bikeImage,
      selectedIcon: selectedIcon,
      selectedColor: selectedColor,
      vehicleLock: vehicleLock,
      vehicleType: vehicleType,
      vehicleMaker: vehicleMaker,
      vehicleModel: vehicleModel,
    );

    if (apiFailure != null && !fallbackSuccess && controlData.isEmpty) {
      if (apiFailure is NotFoundException ||
          apiFailure?.statusCode == 404 ||
          apiFailure?.message.contains("Vehicle not found") == true) {
        throw VehicleNotFoundException(apiFailure!.message, entity);
      }
      throw apiFailure!;
    }

    return entity;
  }

  @override
  Future<void> updateVehicleIcon(String vehicleIMEI, String icon) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleControl(vehicleIMEI),
      {"imei": vehicleIMEI, "vehicleIcon": icon},
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> updateVehicleColor(String vehicleIMEI, String color) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleControl(vehicleIMEI),
      {"imei": vehicleIMEI, "vehicleColor": color},
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> updateTankCapacity(String vehicleIMEI, String capacity) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleControl(vehicleIMEI),
      {"imei": vehicleIMEI, "tankCapacity": capacity},
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> updateMileage(String vehicleIMEI, String mileage) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleControl(vehicleIMEI),
      {"imei": vehicleIMEI, "vehicleMileage": mileage},
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> updateVehicleLock(String vehicleIMEI, bool lockState) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleControl(vehicleIMEI),
      {"imei": vehicleIMEI, "vehicleLock": lockState},
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
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
    final Map<String, dynamic> payload = {
      'vehicleName': vehicleName,
      'vehicleNumber': vehicleNumber,
      'fuelType': fuelType,
      'vehicleType': vehicleType,
      'vehicleMaker': vehicleMaker,
      'vehicleModel': vehicleModel,
    };

    if (brandId.isNotEmpty) {
      payload['brandId'] = brandId;
    }
    if (modelId.isNotEmpty) {
      payload['modelId'] = modelId;
    }

    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleDetails(vehicleIMEI),
      payload,
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> updateVehicleImage(String vehicleIMEI, String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw const FormatException("Image file does not exist");
    }
    final bytes = await file.readAsBytes();
    final response = await _apiService.getPostUploadMultiPartApiResponse(
      ApiURL.updateVehicleControl(vehicleIMEI),
      {"imei": vehicleIMEI},
      bytes,
      imagePath.split('/').last,
      'vehicleImage',
      'PUT',
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    final response = await _apiService.getDeleteApiResponse(
      ApiURL.deleteVehicle(vehicleId),
      {},
    );
    response.fold((failure) => throw failure, (success) => null);
  }
}
