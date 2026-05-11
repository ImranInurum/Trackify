/// presentation/cubit/health_insurance_state.dart

import '../../domain/entities/health_insurance_entity.dart';

class HealthInsuranceState {

  final bool isLoading;

  final HealthInsuranceEntity? data;

  final String? selectedBloodGroup;

  final String? selectedInsurance;

  final String? error;

  HealthInsuranceState({
    required this.isLoading,
    required this.data,
    required this.selectedBloodGroup,
    required this.selectedInsurance,
    required this.error,
  });

  /// INITIAL STATE
  factory HealthInsuranceState.initial() {

    return HealthInsuranceState(

      isLoading: false,

      data: null,

      selectedBloodGroup: null,

      selectedInsurance: null,

      error: null,
    );
  }

  /// COPY WITH
  HealthInsuranceState copyWith({

    bool? isLoading,

    HealthInsuranceEntity? data,

    String? selectedBloodGroup,

    String? selectedInsurance,

    String? error,
  }) {

    return HealthInsuranceState(

      isLoading:
      isLoading ?? this.isLoading,

      data:
      data ?? this.data,

      selectedBloodGroup:
      selectedBloodGroup ??
          this.selectedBloodGroup,

      selectedInsurance:
      selectedInsurance ??
          this.selectedInsurance,

      error:
      error ?? this.error,
    );
  }
}