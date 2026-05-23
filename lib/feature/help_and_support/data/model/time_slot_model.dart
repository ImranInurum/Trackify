import 'package:equatable/equatable.dart';

class SlotResponse extends Equatable {
  final String screenTitle;
  final String importantTitle;
  final String importantDescription;
  final List<DayModel> days;

  SlotResponse({
    required this.screenTitle,
    required this.importantTitle,
    required this.importantDescription,
    required this.days,
  });

  factory SlotResponse.fromJson(Map<String, dynamic> json) {
    return SlotResponse(
      screenTitle: json['screenTitle'] ?? '',
      importantTitle: json['importantTitle'] ?? '',
      importantDescription: json['importantDescription'] ?? '',
      days: (json['days'] as List? ?? [])
          .map((e) => DayModel.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        screenTitle,
        importantTitle,
        importantDescription,
        days,
      ];
}

class DayModel extends Equatable {
  final String date;
  final String dayText;
  final String monthText;
  final int dayNumber;
  final List<TimeSlotModel> slots;

  DayModel({
    required this.date,
    required this.dayText,
    required this.monthText,
    required this.dayNumber,
    required this.slots,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      date: json['date'] ?? '',
      dayText: json['dayText'] ?? '',
      monthText: json['monthText'] ?? '',
      dayNumber: json['dayNumber'] ?? 0,
      slots: (json['slots'] as List? ?? [])
          .map((e) => TimeSlotModel.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        date,
        dayText,
        monthText,
        dayNumber,
        slots,
      ];
}

class TimeSlotModel extends Equatable {
  final String id;
  final String label;
  final int starthour;
  final int endhour;
  final String startTime;
  final String endTime;

  final String date;
  final String dayText;
  final String monthText;
  final int dayNumber;

  final bool isAvailable;

  TimeSlotModel({
    required this.id,
    required this.label,
    required this.starthour,
    required this.endhour,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.dayText,
    required this.monthText,
    required this.dayNumber,
    required this.isAvailable,
  });

  String get dateText => "$dayNumber $monthText ($dayText)";
  String get displayTime => label;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['_id'] ?? json['id'] ?? '',
      label: json['displayTime'] ?? json['label'] ?? '',
      starthour: _parseHour(json['startTime'] ?? json['starthour']),
      endhour: _parseHour(json['endTime'] ?? json['endhour']),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      date: json['date'] ?? '',
      dayText: json['dayText'] ?? '',
      monthText: json['monthText'] ?? '',
      dayNumber: json['dayNumber'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
    );
  }

  static int _parseHour(dynamic time) {
    if (time is int) return time;
    try {
      return int.parse(time.toString().split(":")[0]);
    } catch (_) {
      return 0;
    }
  }

  @override
  List<Object?> get props => [
        id,
        label,
        starthour,
        endhour,
        startTime,
        endTime,
        date,
        dayText,
        monthText,
        dayNumber,
        isAvailable,
      ];
}