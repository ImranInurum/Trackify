import 'package:trackify/feature/order_summary/domain/entities/order_summary_entity.dart';
import 'package:trackify/feature/order_summary/domain/repository/order_summaray_repository.dart';

class GetOrderSummary {
  final OrderSummaryRepository repository;

  GetOrderSummary(this.repository);

  Future<List<OrderSummaryEntity>>call()async{
    return await repository.getOrderSummary();
  }
}