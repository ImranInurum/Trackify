import 'package:equatable/equatable.dart';
import '../../domain/entity/plus_membership_entity.dart';


abstract class UpgradeToPlusState extends Equatable {
  const UpgradeToPlusState();

  @override
  List<Object?> get props => [];
}

class UpgradeToPlusInitial extends UpgradeToPlusState {}

class UpgradeToPlusLoading extends UpgradeToPlusState {}

class UpgradeToPlusSuccess extends UpgradeToPlusState {
  final PlusMembershipEntity details;

  const UpgradeToPlusSuccess(this.details);

  @override
  List<Object?> get props => [details];
}


class UpgradeToPlusFailure extends UpgradeToPlusState {
  final String message;

  const UpgradeToPlusFailure(this.message);

  @override
  List<Object?> get props => [message];
}
