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
    return VehicleMaker(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '', 
      name: json['name']?.toString() ?? json['brandName']?.toString() ?? json['makerName']?.toString() ?? '',
    );
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
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      brandId: json['brandId']?.toString() ?? '',
      modelName: json['modelName']?.toString() ?? json['name']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString() ?? '',
      fuelType: (json['fuelType'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  @override
  bool operator ==(Object other) => other is VehicleModelInfo && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
