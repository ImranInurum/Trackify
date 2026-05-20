import 'package:equatable/equatable.dart';
import 'fuel_logs_state.dart';

abstract class RefuelHistoryState extends Equatable {
  const RefuelHistoryState();

  @override
  List<Object?> get props => [];
}

class RefuelHistoryInitial extends RefuelHistoryState {}

class RefuelHistoryLoading extends RefuelHistoryState {}

class RefuelHistoryLoaded extends RefuelHistoryState {
  final List<RefuelLog> refuelLogs;

  /// Unique timestamp to force Equatable to detect re-emissions
  /// of identical data (e.g. after reload).
  final DateTime loadedAt;

  RefuelHistoryLoaded({
    required this.refuelLogs,
  }) : loadedAt = DateTime.now();

  @override
  List<Object?> get props => [refuelLogs, loadedAt];
}

class RefuelHistoryError extends RefuelHistoryState {
  final String message;

  const RefuelHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
