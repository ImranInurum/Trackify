class VehicleControlEntity {
  final String id;
  final String imei;
  final String vehicleName;
  final String vehicleNumber;
  final String fuelType;
  final String tankCapacity;
  final String vehicleMileage;
  final String? bikeImage;
  final String selectedIcon;
  final String selectedColor;
  final bool vehicleLock;
  // From vehicleDetails
  final String vehicleType;
  final String vehicleMaker;
  final String vehicleModel;

  VehicleControlEntity({
    required this.id,
    String? imei,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.fuelType,
    required this.tankCapacity,
    required this.vehicleMileage,
    this.bikeImage,
    required this.selectedIcon,
    required this.selectedColor,
    required this.vehicleLock,
    this.vehicleType = '',
    this.vehicleMaker = '',
    this.vehicleModel = '',
  }) : imei = imei ?? id;
}
