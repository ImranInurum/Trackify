import 'package:trackify/core/common/models/vehicle_list_model.dart';

class OverspeedAlertModel {
  final String title;
  final int speedLimit;
  final int timeDuration;
  final String date;
  final List<Vehicle> vehicles; // one alert holds MULTIPLE vehicles

  OverspeedAlertModel({
    required this.title,
    required this.speedLimit,
    required this.timeDuration,
    required this.vehicles,
    required this.date,
  });

  OverspeedAlertModel copyWith({
    String? title,
    int? speedLimit,
    int? timeDuration,
    String? date,
    List<Vehicle>? vehicles,
  }) =>
      OverspeedAlertModel(
        title: title ?? this.title,
        speedLimit: speedLimit ?? this.speedLimit,
        timeDuration: timeDuration ?? this.timeDuration,
        date: date ?? this.date,
        vehicles: vehicles ?? this.vehicles,
      );

  factory OverspeedAlertModel.fromJson(Map<String, dynamic> json) =>
      OverspeedAlertModel(
        title: json['title'],
        speedLimit: json['speedLimit'],
        timeDuration: json['timeDuration'],
        date: json['date'],
        vehicles: (json['vehicles'] as List)
            .map((v) => Vehicle.fromJson(v))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'speedLimit': speedLimit,
        'timeDuration': timeDuration,
        'date': date,
        'vehicles': vehicles.map((v) => v.toJson()).toList(),
      };
}
