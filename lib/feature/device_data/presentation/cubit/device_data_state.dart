import 'package:equatable/equatable.dart';
import '../../domain/entity/current_plan_entity.dart';
import '../../domain/entity/recharge_plan_entity.dart';

abstract class DeviceDataState extends Equatable {
  const DeviceDataState();

  @override
  List<Object?> get props => [];
}

class DeviceDataLoading extends DeviceDataState {
  const DeviceDataLoading();
}

class DeviceDataLoaded extends DeviceDataState {
  final List<RechargePlanEntity> plans;
  final int selectedIndex;
  final CurrentPlanEntity? currentPlan;

  const DeviceDataLoaded({
    required this.plans,
    this.selectedIndex = 0,
    this.currentPlan,
  });

  DeviceDataLoaded copyWith({
    List<RechargePlanEntity>? plans,
    int? selectedIndex,
    CurrentPlanEntity? currentPlan,
  }) {
    return DeviceDataLoaded(
      plans: plans ?? this.plans,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      currentPlan: currentPlan ?? this.currentPlan,
    );
  }

  @override
  List<Object?> get props => [plans, selectedIndex, currentPlan];
}

class DeviceDataError extends DeviceDataState {
  final String message;

  const DeviceDataError(this.message);

  @override
  List<Object?> get props => [message];
}