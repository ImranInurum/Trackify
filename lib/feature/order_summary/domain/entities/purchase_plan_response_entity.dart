import 'package:equatable/equatable.dart';

class PurchasePlanResponseEntity extends Equatable {
  final bool success;
  final String message;

  const PurchasePlanResponseEntity({
    required this.success,
    required this.message,
  });

  @override
  List<Object?> get props => [success, message];
}
