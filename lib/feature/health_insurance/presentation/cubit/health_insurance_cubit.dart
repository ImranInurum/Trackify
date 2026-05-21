import 'package:bloc/bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/health_insurance/data/model/save_health_insurance_model.dart';
import 'package:trackify/feature/health_insurance/domain/usecase/health_insurance_usecase.dart';
import 'package:trackify/feature/health_insurance/domain/usecase/save_health_insurance_usecase.dart';

import 'health_insurance_state.dart';

class HealthInsuranceCubit extends Cubit<HealthInsuranceState> {
  final HealthInsuranceUseCase useCase;
  final SaveHealthInsuranceUseCase saveUseCase;

  HealthInsuranceCubit({
    required this.useCase,
    required this.saveUseCase,
  }) : super(HealthInsuranceState.initial());

  Future<void> getData() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await useCase();
      emit(state.copyWith(isLoading: false, data: response));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void selectBloodGroup(String value) {
    emit(state.copyWith(selectedBloodGroup: value));
  }

  void selectInsuranceList(String name, String id) {
    emit(state.copyWith(
      selectedInsurance: name,
      selectedInsuranceId: id,
    ));
  }

  Future<void> save({
    required String cardNumber,
    required String policyNumber,
  }) async {
    final bloodGroup = state.selectedBloodGroup;
    final insuranceId = state.selectedInsuranceId;

    if (bloodGroup == null || bloodGroup.isEmpty) {
      emit(state.copyWith(saveError: 'Please select a blood group'));
      return;
    }
    if (insuranceId == null || insuranceId.isEmpty) {
      emit(state.copyWith(saveError: 'Please select a health insurance'));
      return;
    }
    if (cardNumber.isEmpty) {
      emit(state.copyWith(saveError: 'Please enter your insurance card number'));
      return;
    }
    if (policyNumber.isEmpty) {
      emit(state.copyWith(saveError: 'Please enter your policy number'));
      return;
    }

    final userId = AppPreference.instance.getSync(key: AppPreference.KEY_USER_ID);

    emit(state.copyWith(isSaving: true, saveError: null, saveSuccess: false));
    try {
      await saveUseCase(SaveHealthInsuranceRequest(
        userId: userId,
        bloodGroup: bloodGroup,
        healthInsuranceId: insuranceId,
        healthInsuranceCardNumber: cardNumber,
        policyNumber: policyNumber,
      ));
      emit(state.copyWith(isSaving: false, saveSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSaving: false, saveError: e.toString()));
    }
  }
}
