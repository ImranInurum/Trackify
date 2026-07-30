import 'package:equatable/equatable.dart';
import '../../../data/models/share_history_model.dart';

abstract class LocationSharingLiveState extends Equatable {
  const LocationSharingLiveState();

  @override
  List<Object?> get props => [];
}

class LocationSharingLiveInitial extends LocationSharingLiveState {}

class LocationSharingLiveLoading extends LocationSharingLiveState {}

class LocationSharingLiveLoaded extends LocationSharingLiveState {
  final List<ShareHistoryItem> items;
  final bool hasReachedMax;

  const LocationSharingLiveLoaded({
    required this.items,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [items, hasReachedMax];
}

class LocationSharingLiveError extends LocationSharingLiveState {
  final String message;

  const LocationSharingLiveError(this.message);

  @override
  List<Object?> get props => [message];
}
