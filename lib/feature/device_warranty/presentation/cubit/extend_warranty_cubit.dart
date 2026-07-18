import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/app/app_navigation.dart';
import '../../data/model/extend_warranty_model.dart';
import '../../data/model/verify_payment_model.dart';
import '../../domain/usecase/extend_warranty_usecase.dart';
import '../../domain/usecase/verify_payment_usecase.dart';
import 'extend_warranty_state.dart';

class ExtendWarrantyCubit extends Cubit<ExtendWarrantyState> {
  final ExtendWarrantyUseCase _extendWarrantyUseCase;
  final VerifyPaymentUseCase _verifyPaymentUseCase;

  ExtendWarrantyCubit(this._extendWarrantyUseCase, this._verifyPaymentUseCase)
      : super(const ExtendWarrantyInitial());

  void extendWarranty({
    required String imei,
    required String planId,
    required String paymentMethod,
    required double amountPaid,
  }) async {
    emit(const ExtendWarrantyLoading());

    if (imei.isEmpty) {
      emit(const ExtendWarrantyError("IMEI is required"));
      return;
    }
    if (planId.isEmpty) {
      emit(const ExtendWarrantyError("Plan ID is required"));
      return;
    }

    final request = ExtendWarrantyRequest(
      imei: imei,
      planId: planId,
      paymentMethod: paymentMethod,
      amountPaid: amountPaid,
    );

    final result = await _extendWarrantyUseCase(request);

    result.fold(
      (failure) => emit(ExtendWarrantyError(failure.message)),
      (entity) {
        emit(ExtendWarrantySuccess(entity, "Order created successfully"));
      },
    );
  }

  void verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
  }) async {
    emit(const ExtendWarrantyLoading());
    final request = VerifyPaymentRequest(
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
    );
    final result = await _verifyPaymentUseCase(request);
    
    result.fold(
      (failure) => emit(ExtendWarrantyError(failure.message)),
      (_) {
        AppPreference.instance.setBool(key: 'KEY_WARRANTY_EXPIRED', value: false).then((_) {
          AppNavigation.refreshNavigationState();
        });
        emit(const VerifyPaymentSuccess("Payment verified successfully"));
      },
    );
  }
}
