abstract class OrderSummaryState {}

class OrderSummaryInitial extends OrderSummaryState {}

class OrderSummaryPurchaseLoading extends OrderSummaryState {}

class OrderSummaryPurchaseSuccess extends OrderSummaryState {
  final String message;

  OrderSummaryPurchaseSuccess(this.message);
}

class OrderSummaryPurchaseError extends OrderSummaryState {
  final String message;

  OrderSummaryPurchaseError(this.message);
}
