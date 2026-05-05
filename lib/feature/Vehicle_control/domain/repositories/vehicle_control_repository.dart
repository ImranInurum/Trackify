import '../entities/vehicle_control_entity.dart';

abstract class VehicleControlRepository {
  Future<VehicleControlEntity> getVehicleControlDetails(String vehicleId);
  Future<void> updateVehicleIcon(String vehicleId, String icon);
  Future<void> updateVehicleColor(String vehicleId, String color);
}
