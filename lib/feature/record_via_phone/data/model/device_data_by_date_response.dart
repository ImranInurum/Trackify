class DeviceDataByDateResponse {
  bool? status;
  String? message;
  int? count;
  List<DataByDate>? data;

  DeviceDataByDateResponse({this.status, this.message, this.count, this.data});

  DeviceDataByDateResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <DataByDate>[];
      json['data'].forEach((v) {
        data!.add(DataByDate.fromJson(v));
      });
    }
  }

  DeviceDataByDateResponse copyWith({
    bool? status,
    String? message,
    int? count,
    List<DataByDate>? data,
  }) => DeviceDataByDateResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    count: count ?? this.count,
    data: data ?? this.data,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataByDate {
  String? id;
  String? imei;
  String? gs;
  String? dt;
  String? tm;
  String? lt;
  String? ns;
  String? lg;
  String? ew;
  double? sp;
  int? sg;
  String? createdAt;
  String? updatedAt;
  int? v;

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
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  DataByDate.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    imei = json['imei']?.toString();
    gs = json['gs']?.toString();
    dt = json['dt']?.toString();
    tm = json['tm']?.toString();
    lt = json['lt']?.toString();
    ns = json['ns']?.toString();
    lg = json['lg']?.toString();
    ew = json['ew']?.toString();
    sp = (json['sp'] as num?)?.toDouble();
    sg = (json['sg'] as num?)?.toInt();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    v = (json['__v'] as num?)?.toInt();
  }

  DataByDate copyWith({
    String? id,
    String? imei,
    String? gs,
    String? dt,
    String? tm,
    String? lt,
    String? ns,
    String? lg,
    String? ew,
    double? sp,
    int? sg,
    String? createdAt,
    String? updatedAt,
    int? v,
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
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
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
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
