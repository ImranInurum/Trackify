import 'package:equatable/equatable.dart';

import '../../../../core/config/network/exceptions.dart';
import '../../data/entity/login_response_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

class AuthSuccess extends AuthState {
  final LoginResponseModel user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final AppException error;
  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ForgotPasswordOtpSent extends AuthState {}

class ForgotPasswordOtpVerified extends AuthState {}

class ForgotPasswordResetSuccess extends AuthState {}

class ChangePasswordLoading extends AuthState {}

class ChangePasswordSuccess extends AuthState {}

class ChangePasswordFailure extends AuthState {
  final AppException error;
  const ChangePasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
