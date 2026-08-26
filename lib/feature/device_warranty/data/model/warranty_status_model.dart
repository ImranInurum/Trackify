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
    final expiryDate = json['expiryDate']?.toString() ?? json['expiry_date']?.toString() ?? '';
    final daysLeftVal = json['daysLeft'] ?? json['days_left'] ?? 0;
    int daysLeft = (daysLeftVal is num) ? daysLeftVal.toInt() : (int.tryParse(daysLeftVal?.toString() ?? '') ?? 0);

    if (expiryDate.isNotEmpty) {
      try {
        final expiry = DateTime.parse(expiryDate);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);
        final diff = expiryDay.difference(today).inDays;
        if (diff >= 0) {
          daysLeft = diff;
        }
      } catch (_) {}
    }

    return WarrantyStatusData(
      startDate: json['startDate']?.toString() ?? '',
      expiryDate: expiryDate,
      durationMonths: (json['durationMonths'] as num?)?.toInt() ?? 0,
      daysLeft: daysLeft,
      isExpired: json['isExpired'] ?? (daysLeft <= 0),
      status: json['status']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      amountPaid: json['amountPaid'] ?? 0,
    );
  }
}
