class VehicleListResponse {
  final bool? status;
  final String? message;
  final int? count;
  final List<Vehicle>? vehicles;

  VehicleListResponse({
    this.status,
    this.message,
    this.count,
    this.vehicles,
  });

  factory VehicleListResponse.fromJson(Map<String, dynamic> json) {
    return VehicleListResponse(
      status: json['status'],
      message: json['message'],
      count: json['count'],
      vehicles: json['vehicles'] != null
          ? (json['vehicles'] as List).map((i) => Vehicle.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'count': count,
      'vehicles': vehicles?.map((i) => i.toJson()).toList(),
    };
  }
}

class Vehicle {
  final String? id;
  final String? userId;
  final String? vehicleType;
  final String? fuelType;
  final String? vehicleMaker;
  final String? vehicleNumber;
  final String? vehicleModel;
  final String? createdAt;
  final String? updatedAt;

  Vehicle({
    this.id,
    this.userId,
    this.vehicleType,
    this.fuelType,
    this.vehicleMaker,
    this.vehicleNumber,
    this.vehicleModel,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      userId: json['userId'],
      vehicleType: json['vehicleType'],
      fuelType: json['fuelType'],
      vehicleMaker: json['vehicleMaker'],
      vehicleNumber: json['vehicleNumber'],
      vehicleModel: json['vehicleModel'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'vehicleType': vehicleType,
      'fuelType': fuelType,
      'vehicleMaker': vehicleMaker,
      'vehicleNumber': vehicleNumber,
      'vehicleModel': vehicleModel,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
