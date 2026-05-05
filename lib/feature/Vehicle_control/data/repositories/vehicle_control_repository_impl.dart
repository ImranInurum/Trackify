import '../../domain/entities/vehicle_control_entity.dart';
import '../../domain/repositories/vehicle_control_repository.dart';
import '../models/vehicle_control_model.dart';

class VehicleControlRepositoryImpl implements VehicleControlRepository {
  @override
  Future<VehicleControlEntity> getVehicleControlDetails(String vehicleId) async {
    // Mocking API call
    await Future.delayed(const Duration(seconds: 1));
    return VehicleControlModel(
      id: vehicleId,
      vehicleName: "Honda SP 125",
      vehicleNumber: "MP09QV8269",
      fuelType: "Petrol",
      tankCapacity: "11",
      vehicleMileage: "50",
      selectedIcon: "Bike",
      selectedColor: "White",
    );
  }

  @override
  Future<void> updateVehicleColor(String vehicleId, String color) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateVehicleIcon(String vehicleId, String icon) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
