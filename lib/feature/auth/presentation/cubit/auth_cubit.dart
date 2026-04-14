import 'dart:convert';

import 'package:trackify/core/config/network/api_host.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/google_auth_service.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../../../core/widgets/loading_screen_ol.dart';
import '../../../../core/config/network/exceptions.dart';
import '../../domain/usecase/auth_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCase _authCase;

  AuthCubit(this._authCase) : super(AuthInitial());

  Future<void> loginUser(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    try {
      final result = await _authCase.loginCall(body);
      await result.fold(
        (failure) async {
          emit(AuthFailure(failure));
        },
        (user) async {
          final prefs = AppPreference.instance;
          await prefs.set(key: AppPreference.KEY_TOKEN, value: user.token ?? "");
          await prefs.set(key: AppPreference.KEY_USER_ID, value: user.user?.id ?? "");
          await prefs.set(
            key: AppPreference.KEY_USER_DETAILS,
            value: jsonEncode(user.user?.toJson()),
          );
          ApiURL.updateAuthToken(user.token ?? "");
          await _updateFcmToken(user.user?.id ?? "");
          emit(AuthSuccess(user));
        },
      );
    } finally {
      LoadingScreenOL().hide();
    }
  }

  Future<void> registerUser(Map<String, dynamic> body) async {
    emit(AuthLoading());
    final result = await _authCase.registerCall(body);
    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (user) => emit(RegisterSuccess()),
    );
  }

  Future<void> sendOtp(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    try {
      final result = await _authCase.sendOtpCall(body);
      result.fold(
        (failure) {
          emit(AuthFailure(failure));
        },
        (data) {
          emit(ForgotPasswordOtpSent());
        },
      );
    } finally {
      LoadingScreenOL().hide();
    }
  }

  Future<void> verifyOtp(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    try {
      final result = await _authCase.verifyOtpCall(body);
      result.fold(
        (failure) {
          emit(AuthFailure(failure));
        },
        (data) {
          emit(ForgotPasswordOtpVerified());
        },
      );
    } finally {
      LoadingScreenOL().hide();
    }
  }

  Future<void> resetPassword(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    try {
      final result = await _authCase.resetPasswordCall(body);
      result.fold(
        (failure) {
          emit(AuthFailure(failure));
        },
        (data) {
          emit(ForgotPasswordResetSuccess());
        },
      );
    } finally {
      LoadingScreenOL().hide();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final userCredential =
          await GoogleAuthService.instance.signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        final firebaseUser = userCredential.user!;

        final body = {
          "name": firebaseUser.displayName ?? "Google User",
          "email": firebaseUser.email,
          "socialId": firebaseUser.uid,
        };

        final result = await _authCase.socialLoginCall(body);

        result.fold(
          (failure) {
            emit(AuthFailure(failure));
          },
          (user) async {
            final prefs = AppPreference.instance;
            await prefs.set(
                key: AppPreference.KEY_TOKEN, value: user.token ?? "");
            await prefs.set(
                key: AppPreference.KEY_USER_ID, value: user.user?.id ?? "");
            await prefs.set(
              key: AppPreference.KEY_USER_DETAILS,
              value: jsonEncode(user.user?.toJson()),
            );
            ApiURL.updateAuthToken(user.token ?? "");

            await _updateFcmToken(user.user?.id ?? "");

            emit(AuthSuccess(user));
          },
        );
      } else {}
    } catch (e) {
      print("Google Login Failed ${e.toString()}");
    }
  }

  Future<void> _updateFcmToken(String userId) async {
    try {
      final fcmToken = await AppPreference.instance.get(key: AppPreference.KEY_FCM_TOKEN);
      if (fcmToken.isNotEmpty && userId.isNotEmpty) {
        final body = {"userId": userId, "fcmToken": fcmToken};
        final result = await _authCase.saveFcmTokenCall(body);
        result.fold(
          (failure) => print('Failed to save FCM token: $failure'),
          (data) => print('FCM token saved successfully: $data'),
        );
      } else {
        print('FCM token or userId is empty, skipping save. FCM: $fcmToken, UID: $userId');
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }
}
