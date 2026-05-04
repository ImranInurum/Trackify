class SafeParkingState {
  final bool isActivated;

  const SafeParkingState({
    this.isActivated = false,
  });

  SafeParkingState copyWith({
    bool? isActivated,
  }) {
    return SafeParkingState(
      isActivated: isActivated ?? this.isActivated,
    );
  }
}
