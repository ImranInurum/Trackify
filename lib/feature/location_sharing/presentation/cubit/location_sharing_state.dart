import 'package:equatable/equatable.dart';

abstract class LocationSharingState extends Equatable {
  const LocationSharingState();

  @override
  List<Object?> get props => [];
}

class LocationSharingInitial extends LocationSharingState {}

class LocationSharingLoading extends LocationSharingState {}

class LocationSharingLoaded extends LocationSharingState {
  final List<LocationSharingItem> items;

  const LocationSharingLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class LocationSharingError extends LocationSharingState {
  final String message;

  const LocationSharingError(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationSharingItem extends Equatable {
  final String id;
  final String name;
  final String? subtitle;
  final bool isSharing;
  final bool isPhone;

  const LocationSharingItem({
    required this.id,
    required this.name,
    this.subtitle,
    this.isSharing = false,
    this.isPhone = false,
  });

  LocationSharingItem copyWith({
    String? id,
    String? name,
    String? subtitle,
    bool? isSharing,
    bool? isPhone,
  }) {
    return LocationSharingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      isSharing: isSharing ?? this.isSharing,
      isPhone: isPhone ?? this.isPhone,
    );
  }

  @override
  List<Object?> get props => [id, name, subtitle, isSharing, isPhone];
}
