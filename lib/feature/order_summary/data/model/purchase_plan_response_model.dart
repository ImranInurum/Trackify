import '../../domain/entities/purchase_plan_response_entity.dart';

class PurchasePlanResponseModel extends PurchasePlanResponseEntity {
  const PurchasePlanResponseModel({
    required super.success,
    required super.message,
  });

  factory PurchasePlanResponseModel.fromJson(Map<String, dynamic> json) {
    return PurchasePlanResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? 'Data plan purchased successfully',
    );
  }
}
