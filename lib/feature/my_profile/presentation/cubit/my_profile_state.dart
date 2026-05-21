import 'package:trackify/feature/auth/data/entity/login_response_model.dart';

abstract class MyProfileState {
  const MyProfileState();
}

class MyProfileInitial extends MyProfileState {}

class MyProfileLoading extends MyProfileState {}

class MyProfileSuccess extends MyProfileState {
  final User user;
  final String message;

  const MyProfileSuccess({required this.user, required this.message});
}

class MyProfileError extends MyProfileState {
  final String errorMessage;

  const MyProfileError({required this.errorMessage});
}
