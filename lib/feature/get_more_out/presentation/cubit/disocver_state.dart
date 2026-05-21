// ===============================
// discover_state.dart
// ===============================

import '../../domain/entities/discover_entity.dart';

abstract class DiscoverState {}

class DiscoverInitial extends DiscoverState {}

class DiscoverLoading extends DiscoverState {}

class DiscoverLoaded extends DiscoverState {

  final List<DiscoverEntity> discoverList;

  DiscoverLoaded(this.discoverList);
}

class DiscoverError extends DiscoverState {

  final String message;

  DiscoverError(this.message);
}