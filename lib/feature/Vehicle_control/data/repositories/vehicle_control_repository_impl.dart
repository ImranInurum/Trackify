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
  Future<VehicleControlEntity> getVehicleControlDetails(String vehicleIMEI) async {
    String actualIMEI = vehicleIMEI;
    if (actualIMEI.isEmpty) {
      try {
        final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);
        if (userId.isNotEmpty) {
          final vehiclesRes = await _apiService.getGetApiResponse(ApiURL.getVehiclesByUserId(userId));
          vehiclesRes.fold(
            (failure) => null,
            (data) {
              final list = VehicleListResponse.fromJson(data);
              if (list.vehicles != null && list.vehicles!.isNotEmpty) {
                final firstImei = list.vehicles!.first.imei;
                if (firstImei != null && firstImei.isNotEmpty) {
                  actualIMEI = firstImei;
                  AppPreference.instance.set(key: AppPreference.IMEI, value: firstImei);
                }
              }
            },
          );
        }
      } catch (_) {}
    }

    // 1. Fetch details from vehicle-control GET api
    final controlResult = await _apiService.getGetApiResponse(
      ApiURL.getVehicleControl(actualIMEI),
    );

    AppException? apiFailure;
    Map<String, dynamic> controlData = {};
    controlResult.fold(
      (failure) => apiFailure = failure,
      (data) {
        if (data is Map && data['success'] == true && data['data'] != null) {
          controlData = Map<String, dynamic>.from(data['data']);
        }
      },
    );

    String vehicleName = "MT 15 V2";
    String vehicleNumber = "GJ 01 AB 1234";
    String fuelType = "Petrol";
    String vehicleType = '';
    String vehicleMaker = '';
    String vehicleModel = '';

    if (controlData.containsKey('vehicleDetails') && controlData['vehicleDetails'] != null) {
      final details = Map<String, dynamic>.from(controlData['vehicleDetails']);
      final maker = details['vehicleMaker'] ?? '';
      final model = details['vehicleModel'] ?? '';
      vehicleName = maker.isNotEmpty && model.isNotEmpty ? '$maker $model' : (model.isNotEmpty ? model : vehicleName);
      vehicleNumber = details['vehicleNumber'] ?? vehicleNumber;
      fuelType = details['fuelType'] ?? fuelType;
      vehicleType = details['vehicleType'] ?? '';
      vehicleMaker = maker;
      vehicleModel = model;
    } else {
      try {
        final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);
        if (userId.isNotEmpty) {
          final vehiclesRes = await _apiService.getGetApiResponse(ApiURL.getVehiclesByUserId(userId));
          vehiclesRes.fold(
            (failure) => null,
            (data) {
              final list = VehicleListResponse.fromJson(data);
              final match = list.vehicles?.firstWhere(
                (v) => v.imei == vehicleIMEI,
                orElse: () => Vehicle(),
              );
              if (match != null && match.id != null) {
                vehicleName = match.vehicleModel ?? vehicleName;
                vehicleNumber = match.vehicleNumber ?? vehicleNumber;
                fuelType = match.fuelType ?? fuelType;
              }
            },
          );
        }
      } catch (_) {}
    }

    final tankCapacity = (controlData['tankCapacity'] ?? '').toString();
    final vehicleMileage = (controlData['vehicleMileage'] ?? '').toString();
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

    if (apiFailure != null) {
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
    final response = await _apiService.getPostUploadMultiPartApiResponse(
      ApiURL.updateVehicleControl(vehicleIMEI),
      {"vehicleIcon": icon},
      null,
      '',
      '',
      'PUT',
    );
    response.fold(
      (failure) => throw failure,
      (success) => null,
    );
  }

  @override
  Future<void> updateVehicleColor(String vehicleIMEI, String color) async {
    final response = await _apiService.getPostUploadMultiPartApiResponse(
      ApiURL.updateVehicleControl(vehicleIMEI),
      {"vehicleColor": color},
      null,
      '',
      '',
      'PUT',
    );
    response.fold(
      (failure) => throw failure,
      (success) => null,
    );
  }

  @override
  Future<void> updateTankCapacity(String vehicleIMEI, String capacity) async {
    final response = await _apiService.getPostUploadMultiPartApiResponse(
      ApiURL.updateVehicleControl(vehicleIMEI),
      {"tankCapacity": capacity},
      null,
      '',
      '',
      'PUT',
    );
    response.fold(
      (failure) => throw failure,
      (success) => null,
    );
  }

  @override
  Future<void> updateMileage(String vehicleIMEI, String mileage) async {
    final response = await _apiService.getPostUploadMultiPartApiResponse(
      ApiURL.updateVehicleControl(vehicleIMEI),
      {"vehicleMileage": mileage},
      null,
      '',
      '',
      'PUT',
    );
    response.fold(
      (failure) => throw failure,
      (success) => null,
    );
  }

  @override
  Future<void> updateVehicleLock(String vehicleIMEI, bool lockState) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.lockUnlockVehicle(vehicleIMEI),
      {},
    );
    response.fold(
      (failure) => throw failure,
      (success) => null,
    );
  }

  @override
  Future<void> updateVehicleDetails(String vehicleIMEI, String name, String number, String fuelType) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleDetails(vehicleIMEI),
      {
        'vehicleNumber': number,
        'fuelType': fuelType,
      },
    );
    response.fold(
      (failure) => throw failure,
      (success) => null,
    );
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
      {},
      bytes,
      imagePath.split('/').last,
      'vehicleImage',
      'PUT',
    );
    response.fold(
      (failure) => throw failure,
      (success) => null,
    );
  }

  @override
  Future<void> deleteVehicle(String vehicleIMEI) async {
    final response = await _apiService.getDeleteApiResponse(
      ApiURL.deleteVehicle(vehicleIMEI),
      {},
    );
    response.fold(
      (failure) => throw failure,
      (success) => null,
    );
  }
}
