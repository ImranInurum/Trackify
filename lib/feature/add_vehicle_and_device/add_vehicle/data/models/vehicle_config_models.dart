class VehicleConfig {
  final String id;
  final String type;
  final List<String> supportedFuelTypes;

  VehicleConfig({
    required this.id,
    required this.type,
    required this.supportedFuelTypes,
  });

  factory VehicleConfig.fromJson(Map<String, dynamic> json) {
    return VehicleConfig(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      supportedFuelTypes: List<String>.from(json['supportedFuelTypes'] ?? []),
    );
  }
}

class VehicleMaker {
  final String id;
  final String name;

  VehicleMaker({required this.id, required this.name});

  factory VehicleMaker.fromJson(Map<String, dynamic> json) {
    return VehicleMaker(id: json['_id'] ?? '', name: json['name'] ?? '');
  }
}

class VehicleModelInfo {
  final String id;
  final String brandId;
  final String modelName;
  final String vehicleType;
  final List<String> fuelType;

  VehicleModelInfo({
    required this.id,
    required this.brandId,
    required this.modelName,
    required this.vehicleType,
    required this.fuelType,
  });

  factory VehicleModelInfo.fromJson(Map<String, dynamic> json) {
    return VehicleModelInfo(
      id: json['_id'] ?? '',
      brandId: json['brandId'] ?? '',
      modelName: json['modelName'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      fuelType: List<String>.from(json['fuelType'] ?? []),
    );
  }
}
