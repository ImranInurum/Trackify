import '../entities/vehicle_control_entity.dart';

abstract class VehicleControlRepository {
  Future<VehicleControlEntity> getVehicleControlDetails(String vehicleId);
  Future<void> updateVehicleIcon(String vehicleId, String icon);
  Future<void> updateVehicleColor(String vehicleId, String color);
  Future<void> updateTankCapacity(String vehicleId, String capacity);
  Future<void> updateMileage(String vehicleId, String mileage);
  Future<void> updateVehicleDetails(String vehicleId, String name, String number, String fuelType);
  Future<void> updateVehicleImage(String vehicleId, String imagePath);
}
