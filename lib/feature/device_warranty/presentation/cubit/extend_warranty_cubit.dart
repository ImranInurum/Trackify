import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/app/app_navigation.dart';
import '../../data/model/extend_warranty_model.dart';
import '../../domain/usecase/extend_warranty_usecase.dart';
import 'extend_warranty_state.dart';

class ExtendWarrantyCubit extends Cubit<ExtendWarrantyState> {
  final ExtendWarrantyUseCase _extendWarrantyUseCase;

  ExtendWarrantyCubit(this._extendWarrantyUseCase)
      : super(const ExtendWarrantyInitial());

  void extendWarranty({
    required String imei,
    required String planId,
    required String paymentStatus,
    required String transactionId,
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
      paymentStatus: paymentStatus,
      transactionId: transactionId,
      paymentMethod: paymentMethod,
      amountPaid: amountPaid,
    );

    final result = await _extendWarrantyUseCase(request);

    result.fold(
      (failure) => emit(ExtendWarrantyError(failure.message)),
      (entity) {
        AppPreference.instance.setBool(key: 'KEY_WARRANTY_EXPIRED', value: false).then((_) {
          AppNavigation.refreshNavigationState();
        });
        emit(ExtendWarrantySuccess(entity, "Warranty extended successfully"));
      },
    );
  }
}
