import 'package:trackify/feature/order_summary/domain/entities/order_summary_entity.dart';

abstract class OrderSummaryRepository {
  Future<List<OrderSummaryEntity>> getOrderSummary();
  
}