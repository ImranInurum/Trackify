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
  String? sId;
  String? userId;
  String? vehicleType;
  String? fuelType;
  String? vehicleMaker;
  String? vehicleNumber;
  String? vehicleModel;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Vehicles({
    this.sId,
    this.userId,
    this.vehicleType,
    this.fuelType,
    this.vehicleMaker,
    this.vehicleNumber,
    this.vehicleModel,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Vehicles.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    vehicleType = json['vehicleType'];
    fuelType = json['fuelType'];
    vehicleMaker = json['vehicleMaker'];
    vehicleNumber = json['vehicleNumber'];
    vehicleModel = json['vehicleModel'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Vehicles copyWith({
    String? sId,
    String? userId,
    String? vehicleType,
    String? fuelType,
    String? vehicleMaker,
    String? vehicleNumber,
    String? vehicleModel,
    String? createdAt,
    String? updatedAt,
    int? iV,
  }) => Vehicles(
    sId: sId ?? this.sId,
    userId: userId ?? this.userId,
    vehicleType: vehicleType ?? this.vehicleType,
    fuelType: fuelType ?? this.fuelType,
    vehicleMaker: vehicleMaker ?? this.vehicleMaker,
    vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    vehicleModel: vehicleModel ?? this.vehicleModel,
    createdAt: createdAt ?? this.vehicleModel,
    updatedAt: updatedAt ?? this.updatedAt,
    iV: iV ?? this.iV,
  );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['vehicleType'] = vehicleType;
    data['fuelType'] = fuelType;
    data['vehicleMaker'] = vehicleMaker;
    data['vehicleNumber'] = vehicleNumber;
    data['vehicleModel'] = vehicleModel;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
