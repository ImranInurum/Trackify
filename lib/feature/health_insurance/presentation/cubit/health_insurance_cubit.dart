import 'package:bloc/bloc.dart';
import 'package:trackify/feature/health_insurance/domain/usecase/health_insurance_usecase.dart';

import 'health_insurance_state.dart';

class HealthInsuranceCubit extends  Cubit<HealthInsuranceState>{

  final HealthInsuranceUseCase useCase;

  HealthInsuranceCubit(this.useCase) : super(HealthInsuranceState.initial());

  Future<void>getData()async{
    emit(state.copyWith(
      isLoading:  true
    ));

    final response = await useCase();
    emit(state.copyWith(
      isLoading:false,
      data: response,
    ));
  }

  void selectBloodGroup(String value){
    emit(state.copyWith(selectedBloodGroup:value));
  }

  void selectInsuranceList(String value){
    emit(state.copyWith(
      selectedInsurance: value
    ));
  }


}