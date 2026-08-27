class RideHistoryResponseModel {
  final bool? status;
  final String? message;
  final List<RideTripModel>? data;

  RideHistoryResponseModel({this.status, this.message, this.data});

  factory RideHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return RideHistoryResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RideTripModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RideTripModel {
  final String? date;
  final RideSummaryModel? summary;
  final CurrentLocationModel? currentLocation;
  final int? count;
  final List<RideDataPointModel>? points;

  RideTripModel({
    this.date,
    this.summary,
    this.currentLocation,
    this.count,
    this.points,
  });

  factory RideTripModel.fromJson(Map<String, dynamic> json) {
    return RideTripModel(
      date: json['date'] as String?,
      summary: json['summary'] != null
          ? RideSummaryModel.fromJson(json['summary'] as Map<String, dynamic>)
          : null,
      currentLocation: json['currentLocation'] != null
          ? CurrentLocationModel.fromJson(
              json['currentLocation'] as Map<String, dynamic>,
            )
          : null,
      count: json['count'] as int?,
      points:
          ((json['routeData'] ??
                      json['route'] ??
                      json['data'] ??
                      json['points'] ??
                      json['history'])
                  as List<dynamic>?)
              ?.map(
                (e) => RideDataPointModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

class IgnitionTimelineModel {
  final String status;
  final String startTime;
  final String endTime;
  final int durationMinutes;

  IgnitionTimelineModel({
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  factory IgnitionTimelineModel.fromJson(Map<String, dynamic> json) {
    return IgnitionTimelineModel(
      status: json['status'] ?? 'OFF',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
    );
  }
}

class TripSegmentModel {
  final int tripNumber;
  final String startTime;
  final String endTime;
  final int durationMinutes;
  final String durationText;
  final double distance;
  final double topSpeed;

  TripSegmentModel({
    required this.tripNumber,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.durationText,
    required this.distance,
    required this.topSpeed,
  });

  factory TripSegmentModel.fromJson(Map<String, dynamic> json) {
    return TripSegmentModel(
      tripNumber: json['tripNumber'] ?? 1,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      durationText: json['durationText'] ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      topSpeed: (json['topSpeed'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class RideSummaryModel {
  final String? startTime;
  final String? endTime;
  final int? durationMinutes;
  final String? durationHours;
  final String? duration;
  final double? avgSpeed;
  final double? topSpeed;
  final double? totalDistanceKm;
  final int? tripsCount;
  final List<TripSegmentModel>? trips;
  final List<IgnitionTimelineModel>? ignitionTimeline;

  RideSummaryModel({
    this.startTime,
    this.endTime,
    this.durationMinutes,
    this.durationHours,
    this.duration,
    this.avgSpeed,
    this.topSpeed,
    this.totalDistanceKm,
    this.tripsCount,
    this.trips,
    this.ignitionTimeline,
  });

  factory RideSummaryModel.fromJson(Map<String, dynamic> json) {
    return RideSummaryModel(
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      durationMinutes: json['durationMinutes'] as int?,
      durationHours: json['durationHours']?.toString(),
      duration: json['duration'] as String?,
      avgSpeed: (json['avgSpeed'] as num?)?.toDouble(),
      topSpeed: (json['topSpeed'] as num?)?.toDouble(),
      totalDistanceKm: (json['totalDistanceKm'] as num?)?.toDouble(),
      tripsCount: json['tripsCount'] as int?,
      trips: (json['trips'] as List<dynamic>?)
          ?.map((e) => TripSegmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      ignitionTimeline: (json['ignitionTimeline'] as List<dynamic>?)
          ?.map((e) => IgnitionTimelineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CurrentLocationModel {
  final String? lat;
  final String? lng;
  final double? speed;
  final String? time;

  CurrentLocationModel({this.lat, this.lng, this.speed, this.time});

  factory CurrentLocationModel.fromJson(Map<String, dynamic> json) {
    return CurrentLocationModel(
      lat: (json['lat'] ?? json['lt'] ?? json['latitude'])?.toString(),
      lng: (json['lng'] ?? json['lg'] ?? json['longitude'])?.toString(),
      speed: (json['speed'] ?? json['sp'] as num?)?.toDouble(),
      time: json['time'] as String?,
    );
  }
}

class RideDataPointModel {
  final String? latitude;
  final String? longitude;
  final double? speed;
  final String? time;

  RideDataPointModel({this.latitude, this.longitude, this.speed, this.time});

  factory RideDataPointModel.fromJson(Map<String, dynamic> json) {
    return RideDataPointModel(
      latitude: (json['latitude'] ?? json['lat'] ?? json['lt'])?.toString(),
      longitude: (json['longitude'] ?? json['lng'] ?? json['lg'])?.toString(),
      speed: double.tryParse((json['speed'] ?? json['sp'] ?? "0").toString()),
      time: (json['time'] ?? json['createdAt']) as String?,
    );
  }
}
