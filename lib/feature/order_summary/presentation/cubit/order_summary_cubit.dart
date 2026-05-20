import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/purchase_plan_request_model.dart';
import '../../domain/usecase/purchase_data_plan_usecase.dart';
import 'order_summary_state.dart';

class OrderSummaryCubit extends Cubit<OrderSummaryState> {
  final PurchaseDataPlanUseCase _purchaseDataPlanUseCase;

  OrderSummaryCubit(this._purchaseDataPlanUseCase) : super(OrderSummaryInitial());

  Future<void> purchaseDataPlan({
    required String imei,
    required String planId,
    required String paymentStatus,
    required num amountPaid,
  }) async {
    emit(OrderSummaryPurchaseLoading());

    final request = PurchasePlanRequestModel(
      imei: imei,
      planId: planId,
      paymentStatus: paymentStatus,
      amountPaid: amountPaid,
    );

    final result = await _purchaseDataPlanUseCase(request);

    result.fold(
      (failure) => emit(OrderSummaryPurchaseError(failure.message)),
      (response) => emit(OrderSummaryPurchaseSuccess(response.message)),
    );
  }
}