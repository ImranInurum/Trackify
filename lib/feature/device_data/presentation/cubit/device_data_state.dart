abstract class DeviceDataState {}

class DeviceDataLoading extends DeviceDataState {}

class DeviceDataLoaded extends DeviceDataState {
  final int selectedIndex;

  DeviceDataLoaded({this.selectedIndex = 0});

  DeviceDataLoaded copyWith({int? selectedIndex}) {
    return DeviceDataLoaded(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class DeviceDataError extends DeviceDataState {
  final String message;
  DeviceDataError(this.message);
}