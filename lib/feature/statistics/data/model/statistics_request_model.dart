class StatisticsRequestModel {
  final String imei;
  final String? date;

  const StatisticsRequestModel({required this.imei, this.date});

  Map<String, dynamic> toJson() {
    return {'imei': imei, if (date != null) 'date': date};
  }
}
