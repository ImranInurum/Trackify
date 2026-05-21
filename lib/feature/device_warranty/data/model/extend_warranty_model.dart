import '../../domain/entities/extend_warranty_entity.dart';

class ExtendWarrantyRequest {
  final String imei;
  final String planId;
  final String paymentStatus;
  final String transactionId;
  final String paymentMethod;
  final double amountPaid;

  const ExtendWarrantyRequest({
    required this.imei,
    required this.planId,
    required this.paymentStatus,
    required this.transactionId,
    required this.paymentMethod,
    required this.amountPaid,
  });

  Map<String, dynamic> toJson() {
    return {
      'imei': imei,
      'planId': planId,
      'paymentStatus': paymentStatus,
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
      'amountPaid': amountPaid,
    };
  }
}

class ExtendWarrantyResponseModel extends ExtendWarrantyEntity {
  const ExtendWarrantyResponseModel({
    required super.id,
    required super.imei,
    required super.vehicleId,
    required super.planId,
    required super.durationMonths,
    required super.startDate,
    required super.expiryDate,
    required super.expiryDateText,
    required super.daysLeft,
    required super.amountPaid,
    required super.paymentStatus,
  });

  factory ExtendWarrantyResponseModel.fromJson(Map<String, dynamic> json) {
    return ExtendWarrantyResponseModel(
      id: json['_id'] as String? ?? '',
      imei: json['imei'] as String? ?? '',
      vehicleId: json['vehicleId'] as String? ?? '',
      planId: json['planId'] as String? ?? '',
      durationMonths: (json['durationMonths'] as num?)?.toInt() ?? 0,
      startDate: json['startDate'] as String? ?? '',
      expiryDate: json['expiryDate'] as String? ?? '',
      expiryDateText: json['expiryDateText'] as String? ?? '',
      daysLeft: (json['daysLeft'] as num?)?.toInt() ?? 0,
      amountPaid: (json['amountPaid'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['paymentStatus'] as String? ?? '',
    );
  }
}
