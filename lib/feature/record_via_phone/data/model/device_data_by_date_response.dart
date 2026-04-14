class DeviceDataByDateResponse {
  bool? status;
  String? message;
  int? total;
  List<DataByDate>? data;

  DeviceDataByDateResponse({this.status, this.message, this.total, this.data});

  DeviceDataByDateResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    // Handle the case where the API returns the list inside the 'total' parameter
    if (json['total'] is List) {
      data = <DataByDate>[];
      json['total'].forEach((v) {
        data!.add(DataByDate.fromJson(v));
      });
      total = data!.length;
    } else {
      // The original parsing logic
      total = json['total'];
      if (json['data'] != null) {
        data = <DataByDate>[];
        json['data'].forEach((v) {
          data!.add(DataByDate.fromJson(v));
        });
      }
    }
  }

  DeviceDataByDateResponse copyWith({
    bool? status,
    String? message,
    int? total,
    List<DataByDate>? data,
  }) => DeviceDataByDateResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    total: total ?? this.total,
    data: data ?? this.data,
  );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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
    imei = json['imei']?.toString();
    gs = json['gs']?.toString();
    dt = json['dt']?.toString();
    tm = json['tm']?.toString();
    lt = json['lat']?.toString();
    ns = json['ns']?.toString();
    lg = json['lng']?.toString();
    ew = json['ew']?.toString();
    sp = json['sp']?.toString();
    sg = json['sg']?.toString();
    status = json['status'];
    deviceName = json['device_name']?.toString();
    createdAt = json['createdAt']?.toString();
  }

  DataByDate copyWith({
    int? id,
    String? imei,
    String? gs,
    String? dt,
    String? tm,
    String? lt,
    String? ns,
    String? lg,
    String? ew,
    String? sp,
    String? sg,
    int? status,
    String? deviceName,
    String? createdAt,
  }) => DataByDate(
    id: id ?? this.id,
    imei: imei ?? this.imei,
    gs: gs ?? this.gs,
    dt: dt ?? this.dt,
    tm: tm ?? this.tm,
    lt: lt ?? this.lt,
    ns: ns ?? this.ns,
    lg: lg ?? this.lg,
    ew: ew ?? this.ew,
    sp: sp ?? this.sp,
    sg: sg ?? this.sg,
    status: status ?? this.status,
    deviceName: deviceName ?? this.deviceName,
    createdAt: createdAt ?? this.createdAt,
  );

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
