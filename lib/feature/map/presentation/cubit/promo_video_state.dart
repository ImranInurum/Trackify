import 'package:equatable/equatable.dart';
import 'package:trackify/feature/map/data/entity/promo_video_model.dart';

abstract class PromoVideoState extends Equatable {
  const PromoVideoState();

  @override
  List<Object> get props => [];
}

class PromoVideoInitial extends PromoVideoState {}

class PromoVideoLoading extends PromoVideoState {}

class PromoVideoLoaded extends PromoVideoState {
  final List<PromoVideoModel> videos;
  final bool hasMore;

  const PromoVideoLoaded({required this.videos, this.hasMore = false});

  @override
  List<Object> get props => [videos, hasMore];
}

class PromoVideoError extends PromoVideoState {
  final String message;

  const PromoVideoError(this.message);

  @override
  List<Object> get props => [message];
}
