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

  @override
  bool operator ==(Object other) => other is VehicleConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class VehicleMaker {
  final String id;
  final String name;

  VehicleMaker({required this.id, required this.name});

  factory VehicleMaker.fromJson(Map<String, dynamic> json) {
    return VehicleMaker(id: json['_id'] ?? '', name: json['name'] ?? '');
  }

  @override
  bool operator ==(Object other) => other is VehicleMaker && other.id == id;

  @override
  int get hashCode => id.hashCode;
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

  @override
  bool operator ==(Object other) => other is VehicleModelInfo && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
