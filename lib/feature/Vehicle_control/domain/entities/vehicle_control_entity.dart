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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imei': imei,
      'vehicleName': vehicleName,
      'vehicleNumber': vehicleNumber,
      'fuelType': fuelType,
      'tankCapacity': tankCapacity,
      'vehicleMileage': vehicleMileage,
      'bikeImage': bikeImage,
      'selectedIcon': selectedIcon,
      'selectedColor': selectedColor,
      'vehicleLock': vehicleLock,
      'vehicleType': vehicleType,
      'vehicleMaker': vehicleMaker,
      'vehicleModel': vehicleModel,
    };
  }

  factory VehicleControlEntity.fromJson(Map<String, dynamic> json) {
    return VehicleControlEntity(
      id: json['id'] ?? '',
      imei: json['imei'] ?? '',
      vehicleName: json['vehicleName'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      fuelType: json['fuelType'] ?? '',
      tankCapacity: json['tankCapacity'] ?? '',
      vehicleMileage: json['vehicleMileage'] ?? '',
      bikeImage: json['bikeImage'],
      selectedIcon: json['selectedIcon'] ?? 'Bike',
      selectedColor: json['selectedColor'] ?? 'White',
      vehicleLock: json['vehicleLock'] ?? false,
      vehicleType: json['vehicleType'] ?? '',
      vehicleMaker: json['vehicleMaker'] ?? '',
      vehicleModel: json['vehicleModel'] ?? '',
    );
  }
}
