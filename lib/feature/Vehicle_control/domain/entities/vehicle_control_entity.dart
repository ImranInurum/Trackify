class VehicleControlEntity {
  final String id;
  final String vehicleName;
  final String vehicleNumber;
  final String fuelType;
  final String tankCapacity;
  final String vehicleMileage;
  final String? bikeImage;
  final String selectedIcon;
  final String selectedColor;

  VehicleControlEntity({
    required this.id,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.fuelType,
    required this.tankCapacity,
    required this.vehicleMileage,
    this.bikeImage,
    required this.selectedIcon,
    required this.selectedColor,
  });
}
