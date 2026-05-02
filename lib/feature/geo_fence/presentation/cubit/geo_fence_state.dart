import 'package:equatable/equatable.dart';
import '../../domain/entity/geo_fence_entity.dart';

abstract class GeoFenceState extends Equatable {
  const GeoFenceState();

  @override
  List<Object?> get props => [];
}

class GeoFenceInitial extends GeoFenceState {}

class GeoFenceLoading extends GeoFenceState {}

class GeoFenceLoaded extends GeoFenceState {
  final List<GeoFenceEntity> geoFences;

  const GeoFenceLoaded({
    required this.geoFences,
  });

  GeoFenceLoaded copyWith({
    List<GeoFenceEntity>? geoFences,
  }) {
    return GeoFenceLoaded(
      geoFences: geoFences ?? this.geoFences,
    );
  }

  @override
  List<Object?> get props => [geoFences];
}

class GeoFenceError extends GeoFenceState {
  final String message;
  const GeoFenceError(this.message);

  @override
  List<Object?> get props => [message];
}

class GeoFenceSubmitting extends GeoFenceState {}

class GeoFenceSuccess extends GeoFenceState {}

// New state for form interactions
class GeoFenceFormUpdated extends GeoFenceState {
  final double latitude;
  final double longitude;
  final double radius;
  final String selectedType;
  final String? address;

  const GeoFenceFormUpdated({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.selectedType,
    this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius, selectedType, address];
}
