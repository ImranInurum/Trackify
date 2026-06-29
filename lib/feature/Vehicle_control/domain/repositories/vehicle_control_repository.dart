import '../entities/vehicle_control_entity.dart';

abstract class VehicleControlRepository {
  Future<VehicleControlEntity> getVehicleControlDetails(String vehicleIMEI);
  Future<void> updateVehicleIcon(String vehicleIMEI, String icon);
  Future<void> updateVehicleColor(String vehicleIMEI, String color);
  Future<void> updateTankCapacity(String vehicleIMEI, String capacity);
  Future<void> updateMileage(String vehicleIMEI, String mileage);
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
  });
  Future<void> updateVehicleImage(String vehicleIMEI, String imagePath);
  Future<void> updateVehicleLock(String vehicleIMEI, bool lockState);
  Future<void> deleteVehicle(String vehicleId);
}

class VehicleNotFoundException implements Exception {
  final String message;
  final VehicleControlEntity fallbackVehicle;

  const VehicleNotFoundException(this.message, this.fallbackVehicle);

  @override
  String toString() => 'VehicleNotFoundException: $message';
}
