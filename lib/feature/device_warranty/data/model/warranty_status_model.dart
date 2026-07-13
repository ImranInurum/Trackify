class WarrantyStatusModel {
  final bool success;
  final String imei;
  final WarrantyStatusData? warranty;

  WarrantyStatusModel({
    required this.success,
    required this.imei,
    this.warranty,
  });

  factory WarrantyStatusModel.fromJson(Map<String, dynamic> json) {
    return WarrantyStatusModel(
      success: json['success'] ?? false,
      imei: json['imei'] ?? '',
      warranty: json['warranty'] != null
          ? WarrantyStatusData.fromJson(json['warranty'])
          : null,
    );
  }
}

class WarrantyStatusData {
  final String startDate;
  final String expiryDate;
  final int durationMonths;
  final int daysLeft;
  final bool isExpired;
  final String status;
  final String paymentMethod;
  final num amountPaid;

  WarrantyStatusData({
    required this.startDate,
    required this.expiryDate,
    required this.durationMonths,
    required this.daysLeft,
    required this.isExpired,
    required this.status,
    required this.paymentMethod,
    required this.amountPaid,
  });

  factory WarrantyStatusData.fromJson(Map<String, dynamic> json) {
    return WarrantyStatusData(
      startDate: json['startDate'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      durationMonths: json['durationMonths'] ?? 0,
      daysLeft: json['daysLeft'] ?? 0,
      isExpired: json['isExpired'] ?? false,
      status: json['status'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      amountPaid: json['amountPaid'] ?? 0,
    );
  }
}
