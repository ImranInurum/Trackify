class UserVehicles {
  bool? status;
  String? message;
  int? count;
  List<Vehicles>? vehicles;

  UserVehicles({this.status, this.message, this.count, this.vehicles});

  UserVehicles.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(Vehicles.fromJson(v));
      });
    }
  }

  UserVehicles copyWith({
    bool? status,
    String? message,
    int? count,
    List<Vehicles>? vehicles,
  }) => UserVehicles(
    status: status ?? this.status,
    message: message ?? this.message,
    count: count ?? this.count,
    vehicles: vehicles ?? this.vehicles,
  );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['count'] = count;
    if (vehicles != null) {
      data['vehicles'] = vehicles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vehicles {
  final String id;
  final String userId;
  final String vehicleType;
  final String fuelType;
  final String brandId;
  final String vehicleMaker;
  final String modelId;
  final String vehicleModel;
  final String vehicleNumber;
  final String? imei;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;

  Vehicles({
    required this.id,
    required this.userId,
    required this.vehicleType,
    required this.fuelType,
    required this.brandId,
    required this.vehicleMaker,
    required this.modelId,
    required this.vehicleModel,
    required this.vehicleNumber,
    required this.imei,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Vehicles.fromJson(Map<String, dynamic>? json) {
    return Vehicles(
      id: json?['_id'] ?? '',
      userId: json?['userId'] ?? '',
      vehicleType: json?['vehicleType'] ?? '',
      fuelType: json?['fuelType'] ?? '',
      brandId: json?['brandId'] ?? '',
      vehicleMaker: json?['vehicleMaker'] ?? '',
      modelId: json?['modelId'] ?? '',
      vehicleModel: json?['vehicleModel'] ?? '',
      vehicleNumber: json?['vehicleNumber'] ?? '',
      imei: json?['imei'] ?? '',
      createdAt: json?['createdAt'] != null
          ? DateTime.tryParse(json?['createdAt'])
          : null,
      updatedAt: json?['updatedAt'] != null
          ? DateTime.tryParse(json?['updatedAt'])
          : null,
      version: json?['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'vehicleType': vehicleType,
      'fuelType': fuelType,
      'brandId': brandId,
      'vehicleMaker': vehicleMaker,
      'modelId': modelId,
      'vehicleModel': vehicleModel,
      'vehicleNumber': vehicleNumber,
      'imei': imei,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }
}