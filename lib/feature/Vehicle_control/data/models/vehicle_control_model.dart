import '../../domain/entities/vehicle_control_entity.dart';

class VehicleControlModel extends VehicleControlEntity {
  VehicleControlModel({
    required super.id,
    required super.vehicleName,
    required super.vehicleNumber,
    required super.fuelType,
    required super.tankCapacity,
    required super.vehicleMileage,
    super.bikeImage,
    required super.selectedIcon,
    required super.selectedColor,
    required super.vehicleLock,
  });

  factory VehicleControlModel.fromJson(Map<String, dynamic> json) {
    return VehicleControlModel(
      id: json['id'] ?? '',
      vehicleName: json['vehicleName'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      fuelType: json['fuelType'] ?? '',
      tankCapacity: json['tankCapacity'] ?? '0',
      vehicleMileage: json['vehicleMileage'] ?? '0',
      bikeImage: json['bikeImage'],
      selectedIcon: json['selectedIcon'] ?? 'Bike',
      selectedColor: json['selectedColor'] ?? 'White',
      vehicleLock: json['vehicleLock'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleName': vehicleName,
      'vehicleNumber': vehicleNumber,
      'fuelType': fuelType,
      'tankCapacity': tankCapacity,
      'vehicleMileage': vehicleMileage,
      'bikeImage': bikeImage,
      'selectedIcon': selectedIcon,
      'selectedColor': selectedColor,
      'vehicleLock': vehicleLock,
    };
  }
}
