import '../../domain/entity/current_plan_entity.dart';

class CurrentPlanModel extends CurrentPlanEntity {
  const CurrentPlanModel({
    required super.id,
    required super.imei,
    required super.planId,
    required super.planName,
    required super.durationMonths,
    required super.currentPlanText,
    required super.startDate,
    required super.expiryDate,
    required super.expiryDateText,
    required super.daysLeft,
    required super.amountPaid,
    required super.paymentStatus,
    required super.vehicleNumber,
    required super.vehicleMaker,
    required super.vehicleModel,
    required super.vehicleType,
  });

  factory CurrentPlanModel.fromJson(Map<String, dynamic> json) {
    final vehicle = json['vehicle'] as Map<String, dynamic>? ?? {};
    final plan = json['currentPlan'] as Map<String, dynamic>? ?? {};

    return CurrentPlanModel(
      id: plan['_id'] as String? ?? '',
      imei: plan['imei'] as String? ?? '',
      planId: plan['planId'] as String? ?? '',
      planName: plan['planName'] as String? ?? '',
      durationMonths: plan['durationMonths'] as int? ?? 0,
      currentPlanText: plan['currentPlanText'] as String? ?? '',
      startDate: plan['startDate'] as String? ?? '',
      expiryDate: plan['expiryDate'] as String? ?? '',
      expiryDateText: plan['expiryDateText'] as String? ?? '',
      daysLeft: plan['daysLeft'] as int? ?? 0,
      amountPaid: (plan['amountPaid'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: plan['paymentStatus'] as String? ?? '',
      vehicleNumber: vehicle['vehicleNumber'] as String? ?? '',
      vehicleMaker: vehicle['vehicleMaker'] as String? ?? '',
      vehicleModel: vehicle['vehicleModel'] as String? ?? '',
      vehicleType: vehicle['vehicleType'] as String? ?? '',
    );
  }
}
