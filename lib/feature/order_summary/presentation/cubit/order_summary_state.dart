import 'package:trackify/feature/order_summary/domain/entities/order_summary_entity.dart';

abstract class OrderSummaryState{}

class OrderSummaryInitial extends OrderSummaryState{}

class OrderSummaryLoading extends OrderSummaryState{}

class OrderSummaryLoaded extends OrderSummaryState{

  final List<OrderSummaryEntity> plans;
  final OrderSummaryEntity selectedPlans;

  OrderSummaryLoaded({
    required this.plans,
    required this.selectedPlans,
});
}

class OrderSummaryError extends OrderSummaryState {

  final String message;

  OrderSummaryError(this.message);
}
