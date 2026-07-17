import 'package:equatable/equatable.dart';

class WarrantyPaymentSummaryEntity extends Equatable {
  final SelectedPlanEntity? selectedPlan;
  final PaymentSummaryEntity? paymentSummary;
  final String buttonText;
  final String? orderId;

  const WarrantyPaymentSummaryEntity({
    this.selectedPlan,
    this.paymentSummary,
    required this.buttonText,
    this.orderId,
  });

  @override
  List<Object?> get props => [selectedPlan, paymentSummary, buttonText, orderId];
}

class SelectedPlanEntity extends Equatable {
  final String planId;
  final String planName;
  final int durationMonths;
  final String productName;
  final String vehicleName;
  final String vehicleNumber;
  final String displayName;
  final double originalPrice;
  final double offerPrice;

  const SelectedPlanEntity({
    required this.planId,
    required this.planName,
    required this.durationMonths,
    required this.productName,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.displayName,
    required this.originalPrice,
    required this.offerPrice,
  });

  @override
  List<Object?> get props => [
        planId,
        planName,
        durationMonths,
        productName,
        vehicleName,
        vehicleNumber,
        displayName,
        originalPrice,
        offerPrice,
      ];
}

class PaymentSummaryEntity extends Equatable {
  final String vehicleText;
  final String productName;
  final double originalPrice;
  final String discountText;
  final double discountAmount;
  final double payableAmount;

  const PaymentSummaryEntity({
    required this.vehicleText,
    required this.productName,
    required this.originalPrice,
    required this.discountText,
    required this.discountAmount,
    required this.payableAmount,
  });

  @override
  List<Object?> get props => [
        vehicleText,
        productName,
        originalPrice,
        discountText,
        discountAmount,
        payableAmount,
      ];
}
