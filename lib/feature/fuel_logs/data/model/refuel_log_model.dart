import 'package:trackify/feature/fuel_logs/presentation/cubit/fuel_logs_state.dart';

class RefuelLogModel extends RefuelLog {
  const RefuelLogModel({
    required super.id,
    required super.dateTime,
    required super.odometer,
    required super.location,
    required super.amount,
    required super.rate,
    super.distanceSinceLast,
    super.liters,
    super.mileage,
  });

  /// Parses the date from multiple possible API field names and formats.
  /// Returns [DateTime.utc(1970)] as a safe fallback instead of [DateTime.now()]
  /// so that the timestamp never changes across rebuilds.
  static DateTime _parseDate(Map<String, dynamic> json) {
    // Try combined ISO dateTime fields first
    final dateTimeStr = json['dateTime']?.toString();
    if (dateTimeStr != null && dateTimeStr.isNotEmpty) {
      final parsed = DateTime.tryParse(dateTimeStr);
      if (parsed != null) return parsed;
    }

    // Try 'date' field (may be ISO or just a date string)
    final dateStr = json['date']?.toString();
    if (dateStr != null && dateStr.isNotEmpty) {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) return parsed;
    }

    // Try 'refuelDate' + 'refuelTime' fields (sent by AddFuelModel)
    final refuelDate = json['refuelDate']?.toString();
    if (refuelDate != null && refuelDate.isNotEmpty) {
      final refuelTime = json['refuelTime']?.toString();
      if (refuelTime != null && refuelTime.isNotEmpty) {
        // refuelTime format is "HH-mm", convert to "HH:mm"
        final normalizedTime = refuelTime.replaceAll('-', ':');
        final combined = '${refuelDate}T$normalizedTime:00';
        final parsed = DateTime.tryParse(combined);
        if (parsed != null) return parsed;
      }
      // Try date alone
      final parsed = DateTime.tryParse(refuelDate);
      if (parsed != null) return parsed;
    }

    // Try 'createdAt' as a last resort (server-generated timestamp)
    final createdAt = json['createdAt']?.toString();
    if (createdAt != null && createdAt.isNotEmpty) {
      final parsed = DateTime.tryParse(createdAt);
      if (parsed != null) return parsed;
    }

    // Safe fallback — never use DateTime.now() to prevent
    // timestamps from changing on every rebuild/parse.
    return DateTime.utc(1970);
  }

  factory RefuelLogModel.fromJson(Map<String, dynamic> json) {
    return RefuelLogModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      dateTime: _parseDate(json),
      odometer: json['currentOdometer']?.toString() ??
          json['odometerReading']?.toString() ??
          json['odometer']?.toString() ??
          '0',
      location: json['stationName']?.toString() ??
          json['fuelStation']?.toString() ??
          json['location']?.toString() ??
          'Unknown',
      amount: json['totalAmount']?.toString() ??
          json['totalCost']?.toString() ??
          json['amount']?.toString() ??
          '0',
      rate: json['pricePerLiter']?.toString() ??
          json['pricePerLitre']?.toString() ??
          json['rate']?.toString() ??
          '0',
      distanceSinceLast: json['distanceSinceLast']?.toString(),
      liters: json['fuelFilled']?.toString() ?? json['liters']?.toString(),
      mileage: json['mileage']?.toString(),
    );
  }
}
