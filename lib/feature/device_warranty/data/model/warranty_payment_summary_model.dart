import '../../domain/entities/warranty_payment_summary_entity.dart';

class WarrantyPaymentSummaryRequest {
  final String imei;
  final String planId;

  const WarrantyPaymentSummaryRequest({
    required this.imei,
    required this.planId,
  });

  Map<String, dynamic> toJson() => {
        'imei': imei,
        'planId': planId,
      };
}

class WarrantyPaymentSummaryModel extends WarrantyPaymentSummaryEntity {
  const WarrantyPaymentSummaryModel({
    super.selectedPlan,
    super.paymentSummary,
    required super.buttonText,
  });

  factory WarrantyPaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    final selectedPlanJson = json['selectedPlan'] ?? json['selected_plan'];
    final paymentSummaryJson = json['paymentSummary'] ?? json['payment_summary'];
    final buttonText = json['buttonText']?.toString() ?? json['button_text']?.toString() ?? '';

    return WarrantyPaymentSummaryModel(
      selectedPlan: selectedPlanJson != null
          ? SelectedPlanModel.fromJson(selectedPlanJson as Map<String, dynamic>)
          : null,
      paymentSummary: paymentSummaryJson != null
          ? PaymentSummaryModel.fromJson(paymentSummaryJson as Map<String, dynamic>)
          : null,
      buttonText: buttonText,
    );
  }
}

class SelectedPlanModel extends SelectedPlanEntity {
  const SelectedPlanModel({
    required super.planId,
    required super.planName,
    required super.durationMonths,
    required super.productName,
    required super.vehicleName,
    required super.vehicleNumber,
    required super.displayName,
    required super.originalPrice,
    required super.offerPrice,
  });

  factory SelectedPlanModel.fromJson(Map<String, dynamic> json) {
    final originalPriceVal = json['originalPrice'] ?? json['original_price'] ?? json['price'];
    final originalPrice = (originalPriceVal is num) ? originalPriceVal.toDouble() : (double.tryParse(originalPriceVal?.toString() ?? '') ?? 0.0);
    
    final offerPriceVal = json['offerPrice'] ?? json['offer_price'] ?? json['discountPrice'] ?? json['discount_price'] ?? json['price'];
    final offerPrice = (offerPriceVal is num) ? offerPriceVal.toDouble() : (double.tryParse(offerPriceVal?.toString() ?? '') ?? 0.0);

    final durationMonthsVal = json['durationMonths'] ?? json['duration_months'] ?? json['months'] ?? json['validity'];
    final durationMonths = (durationMonthsVal is num) ? durationMonthsVal.toInt() : (int.tryParse(durationMonthsVal?.toString() ?? '') ?? 0);

    return SelectedPlanModel(
      planId: json['planId']?.toString() ?? json['plan_id']?.toString() ?? json['_id']?.toString() ?? json['id']?.toString() ?? '',
      planName: json['planName']?.toString() ?? json['plan_name']?.toString() ?? json['name']?.toString() ?? '',
      durationMonths: durationMonths,
      productName: json['productName']?.toString() ?? json['product_name']?.toString() ?? json['product']?.toString() ?? '',
      vehicleName: json['vehicleName']?.toString() ?? json['vehicle_name']?.toString() ?? json['vehicle']?.toString() ?? '',
      vehicleNumber: json['vehicleNumber']?.toString() ?? json['vehicle_number']?.toString() ?? json['number']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? json['display_name']?.toString() ?? '',
      originalPrice: originalPrice,
      offerPrice: offerPrice,
    );
  }
}

class PaymentSummaryModel extends PaymentSummaryEntity {
  const PaymentSummaryModel({
    required super.vehicleText,
    required super.productName,
    required super.originalPrice,
    required super.discountText,
    required super.discountAmount,
    required super.payableAmount,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    final originalPriceVal = json['originalPrice'] ?? json['original_price'] ?? json['price'];
    final originalPrice = (originalPriceVal is num) ? originalPriceVal.toDouble() : (double.tryParse(originalPriceVal?.toString() ?? '') ?? 0.0);

    final discountAmountVal = json['discountAmount'] ?? json['discount_amount'] ?? json['discount'];
    final discountAmount = (discountAmountVal is num) ? discountAmountVal.toDouble() : (double.tryParse(discountAmountVal?.toString() ?? '') ?? 0.0);

    final payableAmountVal = json['payableAmount'] ?? json['payable_amount'] ?? json['payable'] ?? json['price'];
    final payableAmount = (payableAmountVal is num) ? payableAmountVal.toDouble() : (double.tryParse(payableAmountVal?.toString() ?? '') ?? 0.0);

    return PaymentSummaryModel(
      vehicleText: json['vehicleText']?.toString() ?? json['vehicle_text']?.toString() ?? '',
      productName: json['productName']?.toString() ?? json['product_name']?.toString() ?? '',
      originalPrice: originalPrice,
      discountText: json['discountText']?.toString() ?? json['discount_text']?.toString() ?? '',
      discountAmount: discountAmount,
      payableAmount: payableAmount,
    );
  }
}
