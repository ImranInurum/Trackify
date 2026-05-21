import 'package:equatable/equatable.dart';
import '../../domain/entities/warranty_payment_summary_entity.dart';

abstract class WarrantyPaymentSummaryState extends Equatable {
  const WarrantyPaymentSummaryState();

  @override
  List<Object?> get props => [];
}

class WarrantyPaymentSummaryInitial extends WarrantyPaymentSummaryState {
  const WarrantyPaymentSummaryInitial();
}

class WarrantyPaymentSummaryLoading extends WarrantyPaymentSummaryState {
  const WarrantyPaymentSummaryLoading();
}

class WarrantyPaymentSummaryLoaded extends WarrantyPaymentSummaryState {
  final WarrantyPaymentSummaryEntity paymentSummary;

  const WarrantyPaymentSummaryLoaded(this.paymentSummary);

  @override
  List<Object?> get props => [paymentSummary];
}

class WarrantyPaymentSummaryError extends WarrantyPaymentSummaryState {
  final String message;

  const WarrantyPaymentSummaryError(this.message);

  @override
  List<Object?> get props => [message];
}
