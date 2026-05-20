class PurchasePlanRequestModel {
  final String imei;
  final String planId;
  final String paymentStatus;
  final num amountPaid;

  PurchasePlanRequestModel({
    required this.imei,
    required this.planId,
    required this.paymentStatus,
    required this.amountPaid,
  });

  Map<String, dynamic> toJson() {
    return {
      'imei': imei,
      'planId': planId,
      'paymentStatus': paymentStatus,
      'amountPaid': amountPaid,
    };
  }
}
