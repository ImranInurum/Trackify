import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/order_summary/data/model/purchase_plan_request_model.dart';
import 'package:trackify/feature/order_summary/domain/entities/purchase_plan_response_entity.dart';
import 'package:trackify/feature/order_summary/domain/repository/order_summaray_repository.dart';

class PurchaseDataPlanUseCase {
  final OrderSummaryRepository repository;

  PurchaseDataPlanUseCase(this.repository);

  ResultFuture<PurchasePlanResponseEntity> call(PurchasePlanRequestModel request) async {
    return await repository.purchaseDataPlan(request);
  }
}
