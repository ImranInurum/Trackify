import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/warranty_payment_summary_model.dart';
import '../../domain/usecase/get_warranty_payment_summary_usecase.dart';
import 'warranty_payment_summary_state.dart';

class WarrantyPaymentSummaryCubit extends Cubit<WarrantyPaymentSummaryState> {
  final GetWarrantyPaymentSummaryUseCase _getWarrantyPaymentSummaryUseCase;

  WarrantyPaymentSummaryCubit(this._getWarrantyPaymentSummaryUseCase)
      : super(const WarrantyPaymentSummaryInitial());

  void load({required String imei, required String planId}) async {
    emit(const WarrantyPaymentSummaryLoading());

    if (imei.isEmpty) {
      emit(const WarrantyPaymentSummaryError("IMEI is required"));
      return;
    }
    if (planId.isEmpty) {
      emit(const WarrantyPaymentSummaryError("Plan ID is required"));
      return;
    }

    final request = WarrantyPaymentSummaryRequest(imei: imei, planId: planId);
    final result = await _getWarrantyPaymentSummaryUseCase(request);

    result.fold(
      (failure) => emit(WarrantyPaymentSummaryError(failure.message)),
      (paymentSummary) => emit(WarrantyPaymentSummaryLoaded(paymentSummary)),
    );
  }
}
