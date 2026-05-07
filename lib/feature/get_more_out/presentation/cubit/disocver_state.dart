import '../../domain/entities/discover_entity.dart';

abstract class DiscoverState {}

class DiscoverInitial extends DiscoverState {}

class DiscoverLoaded extends DiscoverState {

  final List<DiscoverEntity> features;

  DiscoverLoaded(this.features);
}