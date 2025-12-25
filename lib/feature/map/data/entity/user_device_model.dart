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
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.devices != null) {
      data['devices'] = this.devices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserDevices {
  int? id;
  int? userIdFK;
  String? imei;
  String? deviceName;
  String? name;
  String? email;
  String? role;

  UserDevices({
    this.id,
    this.userIdFK,
    this.imei,
    this.deviceName,
    this.name,
    this.email,
    this.role,
  });

  UserDevices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userIdFK = json['user_id_FK'];
    imei = json['imei'];
    deviceName = json['device_name'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id_FK'] = this.userIdFK;
    data['imei'] = this.imei;
    data['device_name'] = this.deviceName;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    return data;
  }
}
