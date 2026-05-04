class OverspeedAlertModel {
  final String? id;
  final String title;
  final int speedLimit;
  final int duration;
  final String? vehicleId;
  final String? imei;
  final String? createdAt;
  final String? updatedAt;

  OverspeedAlertModel({
    this.id,
    required this.title,
    required this.speedLimit,
    required this.duration,
    this.vehicleId,
    this.imei,
    this.createdAt,
    this.updatedAt,
  });

  OverspeedAlertModel copyWith({
    String? id,
    String? title,
    int? speedLimit,
    int? duration,
    String? vehicleId,
    String? imei,
    String? createdAt,
    String? updatedAt,
  }) => OverspeedAlertModel(
    id: id ?? this.id,
    title: title ?? this.title,
    speedLimit: speedLimit ?? this.speedLimit,
    duration: duration ?? this.duration,
    vehicleId: vehicleId ?? this.vehicleId,
    imei: imei ?? this.imei,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory OverspeedAlertModel.fromJson(Map<String, dynamic> json) =>
      OverspeedAlertModel(
        id: json['_id']?.toString(),
        title: json['alert_title']?.toString() ?? '',
        speedLimit: _toInt(json['speed_limit']),
        duration: _toInt(json['duration']),
        vehicleId: json['vehicle_id']?.toString(),
        imei: json['imei']?.toString(),
        createdAt: json['createdAt']?.toString(),
        updatedAt: json['updatedAt']?.toString(),
      );

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'alert_title': title,
    'speed_limit': speedLimit,
    'duration': duration,
    'vehicle_id': vehicleId,
    'imei': imei,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
