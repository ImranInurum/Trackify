import 'package:equatable/equatable.dart';
import '../../domain/entities/extend_warranty_entity.dart';

abstract class ExtendWarrantyState extends Equatable {
  const ExtendWarrantyState();

  @override
  List<Object?> get props => [];
}

class ExtendWarrantyInitial extends ExtendWarrantyState {
  const ExtendWarrantyInitial();
}

class ExtendWarrantyLoading extends ExtendWarrantyState {
  const ExtendWarrantyLoading();
}

class ExtendWarrantySuccess extends ExtendWarrantyState {
  final ExtendWarrantyEntity extendedWarranty;
  final String message;

  const ExtendWarrantySuccess(this.extendedWarranty, this.message);

  @override
  List<Object?> get props => [extendedWarranty, message];
}

class ExtendWarrantyError extends ExtendWarrantyState {
  final String message;

  const ExtendWarrantyError(this.message);

  @override
  List<Object?> get props => [message];
}
