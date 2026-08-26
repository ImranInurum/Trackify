import 'package:equatable/equatable.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventorySuccess extends InventoryState {
  final String message;
  const InventorySuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class InventoryFailure extends InventoryState {
  final String message;
  const InventoryFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
