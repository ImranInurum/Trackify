import '../../domain/entities/vehicle_control_entity.dart';
import '../../domain/repositories/vehicle_control_repository.dart';

class VehicleControlRepositoryImpl implements VehicleControlRepository {
  @override
  Future<VehicleControlEntity> getVehicleControlDetails(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return VehicleControlEntity(
      id: vehicleId,
      vehicleName: "MT 15 V2",
      vehicleNumber: "GJ 01 AB 1234",
      fuelType: "Petrol",
      tankCapacity: "13",
      vehicleMileage: "45",
      bikeImage: null,
      selectedIcon: 'Bike',
      selectedColor: 'White',
    );
  }

  @override
  Future<void> updateVehicleIcon(String vehicleId, String icon) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateVehicleColor(String vehicleId, String color) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateTankCapacity(String vehicleId, String capacity) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateMileage(String vehicleId, String mileage) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateVehicleDetails(String vehicleId, String name, String number, String fuelType) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateVehicleImage(String vehicleId, String imagePath) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
