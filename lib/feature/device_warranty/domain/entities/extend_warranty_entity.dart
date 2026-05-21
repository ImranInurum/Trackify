import 'package:equatable/equatable.dart';

class ExtendWarrantyEntity extends Equatable {
  final String id;
  final String imei;
  final String vehicleId;
  final String planId;
  final int durationMonths;
  final String startDate;
  final String expiryDate;
  final String expiryDateText;
  final int daysLeft;
  final double amountPaid;
  final String paymentStatus;

  const ExtendWarrantyEntity({
    required this.id,
    required this.imei,
    required this.vehicleId,
    required this.planId,
    required this.durationMonths,
    required this.startDate,
    required this.expiryDate,
    required this.expiryDateText,
    required this.daysLeft,
    required this.amountPaid,
    required this.paymentStatus,
  });

  @override
  List<Object?> get props => [
        id,
        imei,
        vehicleId,
        planId,
        durationMonths,
        startDate,
        expiryDate,
        expiryDateText,
        daysLeft,
        amountPaid,
        paymentStatus,
      ];
}
