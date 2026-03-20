import 'package:equatable/equatable.dart';
import 'package:trackify/feature/onboarding/domain/entities/logo_entity.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final LogoEntity logo;
  const SplashLoaded(this.logo);

  @override
  List<Object?> get props => [logo];
}

class SplashError extends SplashState {
  final String? message;
  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}
