class StatisticsResponseModel {
  final bool success;
  final String message;
  final StatisticsData? data;

  const StatisticsResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory StatisticsResponseModel.fromJson(Map<String, dynamic> json) {
    return StatisticsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? StatisticsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class StatisticsData {
  final SelectedDateModel? selectedDate;
  final VehicleModel? vehicle;
  final RidingBehaviourModel? ridingBehaviour;
  final JourneyModel? journey;
  final SpeedModel? speed;
  final FuelModel? fuel;

  const StatisticsData({
    this.selectedDate,
    this.vehicle,
    this.ridingBehaviour,
    this.journey,
    this.speed,
    this.fuel,
  });

  factory StatisticsData.fromJson(Map<String, dynamic> json) {
    return StatisticsData(
      selectedDate: json['selectedDate'] != null
          ? SelectedDateModel.fromJson(
              json['selectedDate'] as Map<String, dynamic>,
            )
          : null,
      vehicle: json['vehicle'] != null
          ? VehicleModel.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
      ridingBehaviour: json['ridingBehaviour'] != null
          ? RidingBehaviourModel.fromJson(
              json['ridingBehaviour'] as Map<String, dynamic>,
            )
          : null,
      journey: json['journey'] != null
          ? JourneyModel.fromJson(json['journey'] as Map<String, dynamic>)
          : null,
      speed: json['speed'] != null
          ? SpeedModel.fromJson(json['speed'] as Map<String, dynamic>)
          : null,
      fuel: json['fuel'] != null
          ? FuelModel.fromJson(json['fuel'] as Map<String, dynamic>)
          : null,
    );
  }
}

class SelectedDateModel {
  final String date;
  final String displayText;
  final String previousDate;
  final String nextDate;

  const SelectedDateModel({
    required this.date,
    required this.displayText,
    required this.previousDate,
    required this.nextDate,
  });

  factory SelectedDateModel.fromJson(Map<String, dynamic> json) {
    return SelectedDateModel(
      date: json['date']?.toString() ?? '',
      displayText: json['displayText']?.toString() ?? '',
      previousDate: json['previousDate']?.toString() ?? '',
      nextDate: json['nextDate']?.toString() ?? '',
    );
  }
}

class VehicleModel {
  final String id;
  final String userId;
  final String imei;
  final String vehicleName;
  final String vehicleNumber;
  final String displayName;

  const VehicleModel({
    required this.id,
    required this.userId,
    required this.imei,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.displayName,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      imei: json['imei']?.toString() ?? '',
      vehicleName: json['vehicleName']?.toString() ?? '',
      vehicleNumber: json['vehicleNumber']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
    );
  }
}

class RidingBehaviourModel {
  final int score;
  final String scoreText;
  final String statusText;
  final String comparisonText;

  const RidingBehaviourModel({
    required this.score,
    required this.scoreText,
    required this.statusText,
    required this.comparisonText,
  });

  factory RidingBehaviourModel.fromJson(Map<String, dynamic> json) {
    return RidingBehaviourModel(
      score: _toInt(json['score']),
      scoreText: json['scoreText']?.toString() ?? '',
      statusText: json['statusText']?.toString() ?? '',
      comparisonText: json['comparisonText']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class JourneyModel {
  final double distanceTravelled;
  final String distanceTravelledText;
  final int timeDurationMinutes;
  final String timeDurationText;
  final String distanceComparisonText;
  final String durationComparisonText;

  const JourneyModel({
    required this.distanceTravelled,
    required this.distanceTravelledText,
    required this.timeDurationMinutes,
    required this.timeDurationText,
    required this.distanceComparisonText,
    required this.durationComparisonText,
  });

  factory JourneyModel.fromJson(Map<String, dynamic> json) {
    return JourneyModel(
      distanceTravelled: _toDouble(json['distanceTravelled']),
      distanceTravelledText: json['distanceTravelledText']?.toString() ?? '',
      timeDurationMinutes: _toInt(json['timeDurationMinutes']),
      timeDurationText: json['timeDurationText']?.toString() ?? '',
      distanceComparisonText: json['distanceComparisonText']?.toString() ?? '',
      durationComparisonText: json['durationComparisonText']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class SpeedModel {
  final double averageSpeed;
  final String averageSpeedText;
  final double topSpeed;
  final String topSpeedText;
  final String averageSpeedComparisonText;
  final String topSpeedComparisonText;

  const SpeedModel({
    required this.averageSpeed,
    required this.averageSpeedText,
    required this.topSpeed,
    required this.topSpeedText,
    required this.averageSpeedComparisonText,
    required this.topSpeedComparisonText,
  });

  factory SpeedModel.fromJson(Map<String, dynamic> json) {
    return SpeedModel(
      averageSpeed: _toDouble(json['averageSpeed']),
      averageSpeedText: json['averageSpeedText']?.toString() ?? '',
      topSpeed: _toDouble(json['topSpeed']),
      topSpeedText: json['topSpeedText']?.toString() ?? '',
      averageSpeedComparisonText:
          json['averageSpeedComparisonText']?.toString() ?? '',
      topSpeedComparisonText: json['topSpeedComparisonText']?.toString() ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class FuelModel {
  final double fuelConsumed;
  final String fuelConsumedText;
  final double fuelCost;
  final String fuelCostText;
  final String fuelConsumedComparisonText;
  final String fuelCostComparisonText;

  const FuelModel({
    required this.fuelConsumed,
    required this.fuelConsumedText,
    required this.fuelCost,
    required this.fuelCostText,
    required this.fuelConsumedComparisonText,
    required this.fuelCostComparisonText,
  });

  factory FuelModel.fromJson(Map<String, dynamic> json) {
    return FuelModel(
      fuelConsumed: _toDouble(json['fuelConsumed']),
      fuelConsumedText: json['fuelConsumedText']?.toString() ?? '',
      fuelCost: _toDouble(json['fuelCost']),
      fuelCostText: json['fuelCostText']?.toString() ?? '',
      fuelConsumedComparisonText:
          json['fuelConsumedComparisonText']?.toString() ?? '',
      fuelCostComparisonText: json['fuelCostComparisonText']?.toString() ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
