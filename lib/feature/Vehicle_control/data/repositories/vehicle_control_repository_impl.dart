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
    String vehicleIdParam,
    String vehicleIMEI,
  ) async {
    String actualIMEI = vehicleIMEI;
    String vehicleId = vehicleIdParam;
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
              }
              final firstId = list.vehicles!.first.id;
              if (firstId != null && firstId.isNotEmpty) {
                vehicleId = firstId;
              }
              // NOTE: Do NOT overwrite AppPreference.IMEI here.
              // The user's selected vehicle preference must only be changed
              // through explicit user actions, not as a side-effect of loading data.
            }
          });
        }
      } catch (_) {}
    }

    // 1. Fetch details from vehicle-control GET api
    final targetId = vehicleId.isNotEmpty ? vehicleId : actualIMEI;
    final controlResult = await _apiService.getGetApiResponse(
      ApiURL.getVehicleControl(targetId),
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
    String brandId = '';
    String modelId = '';
    bool fallbackSuccess = false;

    if (controlData.containsKey('vehicleDetails') &&
        controlData['vehicleDetails'] != null) {
      final details = Map<String, dynamic>.from(controlData['vehicleDetails']);
      vehicleId = details['_id']?.toString() ?? details['id']?.toString() ?? details['vehicleId']?.toString() ?? '';
      brandId = _extractRawId(details['brandId']);
      modelId = _extractRawId(details['modelId']);
      final maker = details['vehicleMaker']?.toString() ?? '';
      final model = details['vehicleModel']?.toString() ?? '';
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
              vehicleId = match.id!;
              brandId = match.brandId ?? brandId;
              modelId = match.modelId ?? modelId;
              vehicleMaker = match.vehicleMaker ?? match.brandId ?? vehicleMaker;
              vehicleModel = match.vehicleModel ?? vehicleModel;
              vehicleName = vehicleMaker.isNotEmpty && vehicleModel.isNotEmpty 
                  ? '$vehicleMaker $vehicleModel' 
                  : (vehicleModel.isNotEmpty ? vehicleModel : (vehicleMaker.isNotEmpty ? vehicleMaker : vehicleName));
              vehicleNumber = match.vehicleNumber ?? vehicleNumber;
              fuelType = match.fuelType ?? fuelType;
              vehicleType = match.vehicleType ?? vehicleType;
              fallbackSuccess = true;
            }
          });
        }
      } catch (_) {}
    }

    if (vehicleId.isEmpty) {
      if (controlData.containsKey('_id')) {
        vehicleId = controlData['_id']?.toString() ?? '';
      } else if (controlData.containsKey('vehicleId')) {
        vehicleId = controlData['vehicleId']?.toString() ?? '';
      }
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
            if (vehicleId.isEmpty) vehicleId = match.id!;
            if (brandId.isEmpty) brandId = match.brandId ?? '';
            if (modelId.isEmpty) modelId = match.modelId ?? '';
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

    if (vehicleMaker.isNotEmpty && vehicleModel.isNotEmpty) {
      vehicleName = '$vehicleMaker $vehicleModel';
    } else if (vehicleName.isEmpty) {
      vehicleName = vehicleModel.isNotEmpty ? vehicleModel : (vehicleMaker.isNotEmpty ? vehicleMaker : vehicleName);
    }

    final entity = VehicleControlEntity(
      id: vehicleId.isNotEmpty ? vehicleId : actualIMEI,
      imei: actualIMEI,
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
      brandId: brandId,
      modelId: modelId,
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
  Future<void> updateVehicleIcon(String vehicleId, String icon) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleControl(vehicleId),
      {"vehicleId": vehicleId, "vehicleIcon": icon},
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> updateVehicleColor(String vehicleId, String color) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleControl(vehicleId),
      {"vehicleId": vehicleId, "vehicleColor": color},
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> updateTankCapacity(String vehicleId, String capacity, String currentMileage) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleControl(vehicleId),
      {"vehicleId": vehicleId, "tankCapacity": capacity, "vehicleMileage": currentMileage},
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> updateMileage(String vehicleId, String mileage, String currentCapacity) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleControl(vehicleId),
      {"vehicleId": vehicleId, "vehicleMileage": mileage, "tankCapacity": currentCapacity},
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> updateVehicleLock(String vehicleId, bool lockState) async {
    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleControl(vehicleId),
      {"vehicleId": vehicleId, "vehicleLock": lockState},
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  String _extractRawId(dynamic value) {
    if (value == null) return '';
    if (value is Map) {
      return value['_id']?.toString() ?? value['id']?.toString() ?? '';
    }
    return value.toString();
  }

  String _formatVehicleType(String type) {
    final lower = type.trim().toLowerCase();
    if (lower == 'car' || lower == '4_wheeler' || lower == '4 wheeler' || lower == 'four_wheeler') {
      return '4_wheeler';
    } else if (lower == 'bike' || lower == 'scooter' || lower == '2_wheeler' || lower == '2 wheeler' || lower == 'two_wheeler') {
      return '2_wheeler';
    } else if (lower == '3_wheeler' || lower == '3 wheeler' || lower == 'three_wheeler') {
      return '3_wheeler';
    } else if (lower == 'commercial' || lower == 'tractor') {
      return '4_wheeler';
    }
    return type.isNotEmpty ? type : '4_wheeler';
  }

  String _formatFuelType(String fuel) {
    final lower = fuel.trim().toLowerCase();
    return lower.isNotEmpty ? lower : 'petrol';
  }

  @override
  Future<void> updateVehicleDetails({
    required String vehicleId,
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
      'vehicleType': _formatVehicleType(vehicleType),
      'fuelType': _formatFuelType(fuelType),
      'brandId': brandId,
      'modelId': modelId,
      'vehicleNumber': vehicleNumber,
    };

    final targetId = vehicleId.isNotEmpty ? vehicleId : vehicleIMEI;

    final response = await _apiService.getPutApiResponse(
      ApiURL.updateVehicleDetails(targetId),
      payload,
    );
    response.fold((failure) => throw failure, (success) => null);
  }

  @override
  Future<void> updateVehicleImage(String vehicleId, String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw const FormatException("Image file does not exist");
    }
    final bytes = await file.readAsBytes();
    final response = await _apiService.getPostUploadMultiPartApiResponse(
      ApiURL.updateVehicleControl(vehicleId),
      {"vehicleId": vehicleId},
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
