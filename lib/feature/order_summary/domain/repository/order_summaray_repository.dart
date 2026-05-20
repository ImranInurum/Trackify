import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/order_summary/domain/entities/order_summary_entity.dart';
import 'package:trackify/feature/order_summary/domain/entities/purchase_plan_response_entity.dart';
import '../../data/model/purchase_plan_request_model.dart';

abstract class OrderSummaryRepository {
  Future<List<OrderSummaryEntity>> getOrderSummary();
  ResultFuture<PurchasePlanResponseEntity> purchaseDataPlan(PurchasePlanRequestModel request);
}