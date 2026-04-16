class NotificationModel {
  final bool? status;
  final String? message;
  final int? count;
  final List<NotificationData>? data;

  NotificationModel({
    this.status,
    this.message,
    this.count,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      count: json['count'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NotificationData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'count': count,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class NotificationData {
  final String? id;
  final UserInfo? userId;
  final String? title;
  final String? description;
  final String? token;
  final VehicleInfo? vehicleId;
  final String? createdAt;

  NotificationData({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.token,
    this.vehicleId,
    this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['_id'] as String?,
      userId: json['userId'] != null
          ? UserInfo.fromJson(json['userId'] as Map<String, dynamic>)
          : null,
      title: json['title'] as String?,
      description: json['description'] as String?,
      token: json['token'] as String?,
      vehicleId: json['vehicleId'] != null
          ? VehicleInfo.fromJson(json['vehicleId'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId?.toJson(),
      'title': title,
      'description': description,
      'token': token,
      'vehicleId': vehicleId?.toJson(),
      'createdAt': createdAt,
    };
  }
}

class UserInfo {
  final String? id;
  final String? name;
  final String? email;
  final String? role;

  UserInfo({
    this.id,
    this.name,
    this.email,
    this.role,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}

class VehicleInfo {
  final String? id;
  final String? userId;
  final String? vehicleType;
  final String? fuelType;
  final String? brandId;
  final String? vehicleMaker;
  final String? modelId;
  final String? vehicleModel;
  final String? vehicleNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? imei;

  VehicleInfo({
    this.id,
    this.userId,
    this.vehicleType,
    this.fuelType,
    this.brandId,
    this.vehicleMaker,
    this.modelId,
    this.vehicleModel,
    this.vehicleNumber,
    this.createdAt,
    this.updatedAt,
    this.imei,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      vehicleType: json['vehicleType'] as String?,
      fuelType: json['fuelType'] as String?,
      brandId: json['brandId'] as String?,
      vehicleMaker: json['vehicleMaker'] as String?,
      modelId: json['modelId'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
      vehicleNumber: json['vehicleNumber'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      imei: json['imei'] as String?,
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imei': imei,
    };
  }
}
