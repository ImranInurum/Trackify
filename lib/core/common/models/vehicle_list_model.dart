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
  final String? vehicleMaker;
  final String? vehicleNumber;
  final String? vehicleModel;
  final String? imei;
  final String? createdAt;
  final String? updatedAt;
  final CurrentLocation? currentLocation;
  final String? lastRideTime;

  Vehicle({
    this.id,
    this.userId,
    this.vehicleType,
    this.fuelType,
    this.vehicleMaker,
    this.vehicleNumber,
    this.vehicleModel,
    this.imei,
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
      vehicleMaker: json['vehicleMaker'],
      vehicleNumber: json['vehicleNumber'],
      vehicleModel: json['vehicleModel'],
      imei: json['imei'],
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
    String? vehicleMaker,
    String? vehicleNumber,
    String? vehicleModel,
    String? imei,
    String? createdAt,
    String? updatedAt,
    CurrentLocation? currentLocation,
    String? lastRideTime,
  }) => Vehicle(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    vehicleType: vehicleType ?? this.vehicleType,
    fuelType: fuelType ?? this.fuelType,
    vehicleMaker: vehicleMaker ?? this.vehicleMaker,
    vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    vehicleModel: vehicleModel ?? this.vehicleModel,
    imei: imei ?? this.imei,
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
      'vehicleMaker': vehicleMaker,
      'vehicleNumber': vehicleNumber,
      'vehicleModel': vehicleModel,
      'imei': imei,
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
