class RideHistoryResponseModel {
  final bool? status;
  final String? message;
  final RideSummaryModel? summary;
  final CurrentLocationModel? currentLocation;
  final int? count;
  final List<RideDataPointModel>? data;

  RideHistoryResponseModel({
    this.status,
    this.message,
    this.summary,
    this.currentLocation,
    this.count,
    this.data,
  });

  factory RideHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return RideHistoryResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      summary: json['summary'] != null
          ? RideSummaryModel.fromJson(json['summary'] as Map<String, dynamic>)
          : null,
      currentLocation: json['currentLocation'] != null
          ? CurrentLocationModel.fromJson(
              json['currentLocation'] as Map<String, dynamic>)
          : null,
      count: json['count'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RideDataPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RideSummaryModel {
  final String? startTime;
  final String? endTime;
  final int? durationMinutes;
  final String? durationHours;
  final double? avgSpeed;
  final double? topSpeed;
  final double? totalDistanceKm;

  RideSummaryModel({
    this.startTime,
    this.endTime,
    this.durationMinutes,
    this.durationHours,
    this.avgSpeed,
    this.topSpeed,
    this.totalDistanceKm,
  });

  factory RideSummaryModel.fromJson(Map<String, dynamic> json) {
    return RideSummaryModel(
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      durationMinutes: json['durationMinutes'] as int?,
      durationHours: json['durationHours']?.toString(),
      avgSpeed: (json['avgSpeed'] as num?)?.toDouble(),
      topSpeed: (json['topSpeed'] as num?)?.toDouble(),
      totalDistanceKm: (json['totalDistanceKm'] as num?)?.toDouble(),
    );
  }
}

class CurrentLocationModel {
  final String? lat;
  final String? lng;
  final double? speed;
  final String? time;

  CurrentLocationModel({
    this.lat,
    this.lng,
    this.speed,
    this.time,
  });

  factory CurrentLocationModel.fromJson(Map<String, dynamic> json) {
    return CurrentLocationModel(
      lat: json['lat']?.toString(),
      lng: json['lng']?.toString(),
      speed: (json['speed'] as num?)?.toDouble(),
      time: json['time'] as String?,
    );
  }
}

class RideDataPointModel {
  final String? id;
  final String? imei;
  final String? gs;
  final String? dt;
  final String? tm;
  final String? lat;
  final String? lng;
  final int? spd;
  final int? crs;
  final int? alt;
  final String? st;
  final int? mcc;
  final int? mnc;
  final int? lac;
  final int? cid;
  final double? dist;
  final int? ign;
  final int? pwr;
  final double? ext;
  final double? bat;
  final int? acc;
  final String? createdAt;
  final String? updatedAt;

  RideDataPointModel({
    this.id,
    this.imei,
    this.gs,
    this.dt,
    this.tm,
    this.lat,
    this.lng,
    this.spd,
    this.crs,
    this.alt,
    this.st,
    this.mcc,
    this.mnc,
    this.lac,
    this.cid,
    this.dist,
    this.ign,
    this.pwr,
    this.ext,
    this.bat,
    this.acc,
    this.createdAt,
    this.updatedAt,
  });

  factory RideDataPointModel.fromJson(Map<String, dynamic> json) {
    return RideDataPointModel(
      id: json['_id'] as String?,
      imei: json['imei'] as String?,
      gs: json['gs'] as String?,
      dt: json['dt'] as String?,
      tm: json['tm'] as String?,
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
      spd: json['spd'] as int?,
      crs: json['crs'] as int?,
      alt: json['alt'] as int?,
      st: json['st'] as String?,
      mcc: json['mcc'] as int?,
      mnc: json['mnc'] as int?,
      lac: json['lac'] as int?,
      cid: json['cid'] as int?,
      dist: (json['dist'] as num?)?.toDouble(),
      ign: json['ign'] as int?,
      pwr: json['pwr'] as int?,
      ext: (json['ext'] as num?)?.toDouble(),
      bat: (json['bat'] as num?)?.toDouble(),
      acc: json['acc'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
