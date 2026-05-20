import 'package:equatable/equatable.dart';

class CurrentPlanEntity extends Equatable {
  final String id;
  final String imei;
  final String planId;
  final String planName;
  final int durationMonths;
  final String currentPlanText;
  final String startDate;
  final String expiryDate;
  final String expiryDateText;
  final int daysLeft;
  final double amountPaid;
  final String paymentStatus;

  // Vehicle info
  final String vehicleNumber;
  final String vehicleMaker;
  final String vehicleModel;
  final String vehicleType;

  const CurrentPlanEntity({
    required this.id,
    required this.imei,
    required this.planId,
    required this.planName,
    required this.durationMonths,
    required this.currentPlanText,
    required this.startDate,
    required this.expiryDate,
    required this.expiryDateText,
    required this.daysLeft,
    required this.amountPaid,
    required this.paymentStatus,
    required this.vehicleNumber,
    required this.vehicleMaker,
    required this.vehicleModel,
    required this.vehicleType,
  });

  @override
  List<Object?> get props => [
        id,
        imei,
        planId,
        planName,
        durationMonths,
        currentPlanText,
        startDate,
        expiryDate,
        expiryDateText,
        daysLeft,
        amountPaid,
        paymentStatus,
        vehicleNumber,
        vehicleMaker,
        vehicleModel,
        vehicleType,
      ];
}
