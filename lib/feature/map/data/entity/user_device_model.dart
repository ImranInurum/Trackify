class UserDeviceList {
  String? message;
  int? count;
  List<UserDevices>? devices;

  UserDeviceList({this.message, this.count, this.devices});

  UserDeviceList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['devices'] != null) {
      devices = <UserDevices>[];
      json['devices'].forEach((v) {
        devices!.add(new UserDevices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    data['count'] = count;
    if (devices != null) {
      data['devices'] = devices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserDevices {
  String? sId;
  UserIdFK? userIdFK;
  String? imei;
  int? iV;
  String? createdAt;
  String? updatedAt;
  String? deviceName;

  UserDevices({this.sId,
    this.userIdFK,
    this.imei,
    this.iV,
    this.createdAt,
    this.updatedAt,
    this.deviceName});

  UserDevices.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userIdFK = json['user_id_FK'] != null
        ? new UserIdFK.fromJson(json['user_id_FK'])
        : null;
    imei = json['imei'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deviceName = json['device_name'];
  }

  Map<String, dynamic> toJson()  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (userIdFK != null) {
      data['user_id_FK'] = userIdFK!.toJson();
    }
    data['imei'] = imei;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['device_name'] = deviceName;
    return data;
  }
}

class UserIdFK {
  String? sId;
  String? name;
  String? email;
  String? role;

  UserIdFK({this.sId, this.name, this.email, this.role});

  UserIdFK.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    return data;
  }
}
