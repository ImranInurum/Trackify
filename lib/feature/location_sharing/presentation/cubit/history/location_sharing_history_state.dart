import 'package:equatable/equatable.dart';
import '../../../data/models/share_history_model.dart';

abstract class LocationSharingHistoryState extends Equatable {
  const LocationSharingHistoryState();

  @override
  List<Object?> get props => [];
}

class LocationSharingHistoryInitial extends LocationSharingHistoryState {}

class LocationSharingHistoryLoading extends LocationSharingHistoryState {}

class LocationSharingHistoryLoaded extends LocationSharingHistoryState {
  final List<ShareHistoryItem> items;
  final bool hasReachedMax;

  const LocationSharingHistoryLoaded({
    required this.items,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [items, hasReachedMax];
}

class LocationSharingHistoryError extends LocationSharingHistoryState {
  final String message;

  const LocationSharingHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
