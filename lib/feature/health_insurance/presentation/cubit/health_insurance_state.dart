import '../../domain/entities/health_insurance_entity.dart';

class HealthInsuranceState {
  final bool isLoading;
  final HealthInsuranceEntity? data;
  final String? selectedBloodGroup;
  final String? selectedInsurance;     // display name
  final String? selectedInsuranceId;   // _id for API
  final String? error;
  final bool isSaving;
  final bool saveSuccess;
  final String? saveError;

  HealthInsuranceState({
    required this.isLoading,
    required this.data,
    required this.selectedBloodGroup,
    required this.selectedInsurance,
    required this.selectedInsuranceId,
    required this.error,
    required this.isSaving,
    required this.saveSuccess,
    required this.saveError,
  });

  factory HealthInsuranceState.initial() {
    return HealthInsuranceState(
      isLoading: false,
      data: null,
      selectedBloodGroup: null,
      selectedInsurance: null,
      selectedInsuranceId: null,
      error: null,
      isSaving: false,
      saveSuccess: false,
      saveError: null,
    );
  }

  HealthInsuranceState copyWith({
    bool? isLoading,
    HealthInsuranceEntity? data,
    String? selectedBloodGroup,
    String? selectedInsurance,
    String? selectedInsuranceId,
    String? error,
    bool? isSaving,
    bool? saveSuccess,
    String? saveError,
  }) {
    return HealthInsuranceState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      selectedBloodGroup: selectedBloodGroup ?? this.selectedBloodGroup,
      selectedInsurance: selectedInsurance ?? this.selectedInsurance,
      selectedInsuranceId: selectedInsuranceId ?? this.selectedInsuranceId,
      error: error ?? this.error,
      isSaving: isSaving ?? this.isSaving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      saveError: saveError ?? this.saveError,
    );
  }
}
