import 'package:equatable/equatable.dart';
import '../../data/model/time_slot_model.dart';

abstract class BookingSlotState extends Equatable {

  @override
  List<Object?> get props => [];
}

class BookingSlotInitial
    extends BookingSlotState {}

class BookingSlotLoading
    extends BookingSlotState {}

class BookingSlotLoaded
    extends BookingSlotState {

  final SlotResponse slotResponse;

  BookingSlotLoaded({
    required this.slotResponse,
  });

  @override
  List<Object?> get props => [
    slotResponse,
  ];
}

class BookingSlotError
    extends BookingSlotState {

  final String message;

  BookingSlotError({
    required this.message,
  });

  @override
  List<Object?> get props => [
    message,
  ];
}