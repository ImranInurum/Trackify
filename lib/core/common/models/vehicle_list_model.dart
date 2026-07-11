class VehicleListResponse {
  final bool? status;
  final String? message;
  final int? count;
  final List<Vehicle>? vehicles;

  VehicleListResponse({this.status, this.message, this.count, this.vehicles});

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

  VehicleListResponse copyWith({
    bool? status,
    String? message,
    int? count,
    List<Vehicle>? vehicles,
  }) => VehicleListResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    count: count ?? this.count,
    vehicles: vehicles ?? this.vehicles,
  );

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
  final String? brandId;
  final String? vehicleMaker;
  final String? modelId;
  final String? vehicleNumber;
  final String? vehicleModel;
  final String? imei;
  final int? status;
  final String? mileage;
  final String? tankCapacity;
  final String? warrantyStartDate;
  final String? warrantyExpiryDate;
  final String? warrantyStatus;
  final String? warrantyType;
  final String? createdAt;
  final String? updatedAt;
  final CurrentLocation? currentLocation;
  final String? lastRideTime;

  Vehicle({
    this.id,
    this.userId,
    this.vehicleType,
    this.fuelType,
    this.brandId,
    this.vehicleMaker,
    this.modelId,
    this.vehicleNumber,
    this.vehicleModel,
    this.imei,
    this.status,
    this.mileage,
    this.tankCapacity,
    this.warrantyStartDate,
    this.warrantyExpiryDate,
    this.warrantyStatus,
    this.warrantyType,
    this.createdAt,
    this.updatedAt,
    this.currentLocation,
    this.lastRideTime,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      userId: json['userId'],
      vehicleType: json['vehicleType'],
      fuelType: json['fuelType'],
      brandId: json['brandId'],
      vehicleMaker: json['vehicleMaker'],
      modelId: json['modelId'],
      vehicleNumber: json['vehicleNumber'],
      vehicleModel: json['vehicleModel'],
      imei: json['imei'],
      status: json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? ''),
      mileage: json['mileage']?.toString(),
      tankCapacity: json['tankCapacity']?.toString(),
      warrantyStartDate: json['warrantyStartDate'],
      warrantyExpiryDate: json['warrantyExpiryDate'],
      warrantyStatus: json['warrantyStatus'],
      warrantyType: json['warrantyType'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      currentLocation: json['currentLocation'] != null
          ? CurrentLocation.fromJson(json['currentLocation'])
          : null,
      lastRideTime: json['lastRideTime'],
    );
  }

  Vehicle copyWith({
    String? id,
    String? userId,
    String? vehicleType,
    String? fuelType,
    String? brandId,
    String? vehicleMaker,
    String? modelId,
    String? vehicleNumber,
    String? vehicleModel,
    String? imei,
    int? status,
    String? mileage,
    String? tankCapacity,
    String? warrantyStartDate,
    String? warrantyExpiryDate,
    String? warrantyStatus,
    String? warrantyType,
    String? createdAt,
    String? updatedAt,
    CurrentLocation? currentLocation,
    String? lastRideTime,
  }) => Vehicle(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    vehicleType: vehicleType ?? this.vehicleType,
    fuelType: fuelType ?? this.fuelType,
    brandId: brandId ?? this.brandId,
    vehicleMaker: vehicleMaker ?? this.vehicleMaker,
    modelId: modelId ?? this.modelId,
    vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    vehicleModel: vehicleModel ?? this.vehicleModel,
    imei: imei ?? this.imei,
    status: status ?? this.status,
    mileage: mileage ?? this.mileage,
    tankCapacity: tankCapacity ?? this.tankCapacity,
    warrantyStartDate: warrantyStartDate ?? this.warrantyStartDate,
    warrantyExpiryDate: warrantyExpiryDate ?? this.warrantyExpiryDate,
    warrantyStatus: warrantyStatus ?? this.warrantyStatus,
    warrantyType: warrantyType ?? this.warrantyType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    currentLocation: currentLocation ?? this.currentLocation,
    lastRideTime: lastRideTime ?? this.lastRideTime,
  );

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'vehicleType': vehicleType,
      'fuelType': fuelType,
      'brandId': brandId,
      'vehicleMaker': vehicleMaker,
      'modelId': modelId,
      'vehicleNumber': vehicleNumber,
      'vehicleModel': vehicleModel,
      'imei': imei,
      'status': status,
      'mileage': mileage,
      'tankCapacity': tankCapacity,
      'warrantyStartDate': warrantyStartDate,
      'warrantyExpiryDate': warrantyExpiryDate,
      'warrantyStatus': warrantyStatus,
      'warrantyType': warrantyType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'currentLocation': currentLocation?.toJson(),
      'lastRideTime': lastRideTime,
    };
  }
}

class CurrentLocation {
  final double? lat;
  final double? lng;
  final double? speed;
  final String? time;

  CurrentLocation({this.lat, this.lng, this.speed, this.time});

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      lat: json['lat'] != null ? double.tryParse(json['lat'].toString()) : null,
      lng: json['lng'] != null ? double.tryParse(json['lng'].toString()) : null,
      speed: json['speed'] != null
          ? double.tryParse(json['speed'].toString())
          : null,
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'speed': speed,
      'time': time,
    };
  }
}
