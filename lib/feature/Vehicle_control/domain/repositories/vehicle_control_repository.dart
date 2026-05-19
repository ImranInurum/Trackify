import '../entities/vehicle_control_entity.dart';

abstract class VehicleControlRepository {
  Future<VehicleControlEntity> getVehicleControlDetails(String vehicleIMEI);
  Future<void> updateVehicleIcon(String vehicleIMEI, String icon);
  Future<void> updateVehicleColor(String vehicleIMEI, String color);
  Future<void> updateTankCapacity(String vehicleIMEI, String capacity);
  Future<void> updateMileage(String vehicleIMEI, String mileage);
  Future<void> updateVehicleDetails(String vehicleIMEI, String name, String number, String fuelType);
  Future<void> updateVehicleImage(String vehicleIMEI, String imagePath);
  Future<void> updateVehicleLock(String vehicleIMEI, bool lockState);
  Future<void> deleteVehicle(String vehicleIMEI);
}

class VehicleNotFoundException implements Exception {
  final String message;
  final VehicleControlEntity fallbackVehicle;

  const VehicleNotFoundException(this.message, this.fallbackVehicle);

  @override
  String toString() => 'VehicleNotFoundException: $message';
}
