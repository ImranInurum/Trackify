class DocumentUploadedState {
  final String? dl;
  final String? other;
  final String? rc;
  final String? insurance;
  final String? puc;
  final String? bills;
  final bool isLoading;
  final String? error;

  const DocumentUploadedState({
    this.dl,
    this.other,
    this.rc,
    this.insurance,
    this.puc,
    this.bills,
    this.isLoading = false,
    this.error,
  });

  DocumentUploadedState copyWith({
    String? dl,
    String? other,
    String? rc,
    String? insurance,
    String? puc,
    String? bills,
    bool? isLoading,
    String? error,
  }) {
    return DocumentUploadedState(
      dl: dl ?? this.dl,
      other: other ?? this.other,
      rc: rc ?? this.rc,
      insurance: insurance ?? this.insurance,
      puc: puc ?? this.puc,
      bills: bills ?? this.bills,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}