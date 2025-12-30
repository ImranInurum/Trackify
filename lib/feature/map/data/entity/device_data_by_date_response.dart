class DeviceDataByDateResponse {
  bool? status;
  String? message;
  int? total;
  List<DataByDate>? data;

  DeviceDataByDateResponse({this.status, this.message, this.total, this.data});

  DeviceDataByDateResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <DataByDate>[];
      json['data'].forEach((v) {
        data!.add(DataByDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['total'] = total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataByDate {
  int? id;
  String? imei;
  String? gs;
  String? dt;
  String? tm;
  String? lt;
  String? ns;
  String? lg;
  String? ew;
  String? sp;
  String? sg;
  int? status;
  String? deviceName;
  String? createdAt;

  DataByDate({
    this.id,
    this.imei,
    this.gs,
    this.dt,
    this.tm,
    this.lt,
    this.ns,
    this.lg,
    this.ew,
    this.sp,
    this.sg,
    this.status,
    this.deviceName,
    this.createdAt,
  });

  DataByDate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imei = json['imei'];
    gs = json['gs'];
    dt = json['dt'];
    tm = json['tm'];
    lt = json['lt'];
    ns = json['ns'];
    lg = json['lg'];
    ew = json['ew'];
    sp = json['sp'];
    sg = json['sg'];
    status = json['status'];
    deviceName = json['device_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imei'] = imei;
    data['gs'] = gs;
    data['dt'] = dt;
    data['tm'] = tm;
    data['lt'] = lt;
    data['ns'] = ns;
    data['lg'] = lg;
    data['ew'] = ew;
    data['sp'] = sp;
    data['sg'] = sg;
    data['status'] = status;
    data['device_name'] = deviceName;
    data['created_at'] = createdAt;
    return data;
  }
}
