import '../entities/vehicle_control_entity.dart';

abstract class VehicleControlRepository {
  Future<VehicleControlEntity> getVehicleControlDetails(String vehicleId, String vehicleIMEI);
  Future<void> updateVehicleIcon(String vehicleId, String icon);
  Future<void> updateVehicleColor(String vehicleId, String color);
  Future<void> updateTankCapacity(String vehicleId, String capacity, String currentMileage);
  Future<void> updateMileage(String vehicleId, String mileage, String currentCapacity);
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
  });
  Future<void> updateVehicleImage(String vehicleId, String imagePath);
  Future<void> updateVehicleLock(String vehicleId, bool lockState);
  Future<void> deleteVehicle(String vehicleId);
}

class VehicleNotFoundException implements Exception {
  final String message;
  final VehicleControlEntity fallbackVehicle;

  const VehicleNotFoundException(this.message, this.fallbackVehicle);

  @override
  String toString() => 'VehicleNotFoundException: $message';
}
