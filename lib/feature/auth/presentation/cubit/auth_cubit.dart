import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/google_auth_service.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../../../core/widgets/loading_screen_ol.dart';
import '../../data/entity/login_response_model.dart';
import '../../domain/usecase/auth_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCase _authCase;

  AuthCubit(this._authCase) : super(AuthInitial());

  Future<void> loginUser(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    final stopwatch = Stopwatch()..start();
    final result = await _authCase.loginCall(body);
    print('Network + decode took: ${stopwatch.elapsedMilliseconds}ms');

    result.fold((failure) => emit(AuthFailure(failure)), (user) async {
      final sw = Stopwatch()..start();

      final prefs = AppPreference.instance;
      await prefs.set(key: AppPreference.KEY_TOKEN, value: user.token ?? "");
      await prefs.set(
        key: AppPreference.KEY_USER_DETAILS,
        value: jsonEncode(user.user?.toJson()),
      );
      print('Prefs write took: ${sw.elapsedMilliseconds}ms');

      emit(AuthSuccess(user));
      LoadingScreenOL().hide();
    });
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
    final result = await _authCase.sendOtpCall(body);
    result.fold(
      (failure) {
        LoadingScreenOL().hide();
        emit(AuthFailure(failure));
      },
      (data) {
        LoadingScreenOL().hide();
        emit(ForgotPasswordOtpSent());
      },
    );
  }

  Future<void> verifyOtp(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    final result = await _authCase.verifyOtpCall(body);
    result.fold(
      (failure) {
        LoadingScreenOL().hide();
        emit(AuthFailure(failure));
      },
      (data) {
        LoadingScreenOL().hide();
        emit(ForgotPasswordOtpVerified());
      },
    );
  }

  Future<void> resetPassword(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    final result = await _authCase.resetPasswordCall(body);
    result.fold(
      (failure) {
        LoadingScreenOL().hide();
        emit(AuthFailure(failure));
      },
      (data) {
        LoadingScreenOL().hide();
        emit(ForgotPasswordResetSuccess());
      },
    );
  }

  Future<void> loginWithGoogle() async {
    try {
      LoadingScreenOL().show();
      emit(AuthLoading());

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
            LoadingScreenOL().hide();
            emit(AuthFailure(failure));
          },
          (user) async {
            final prefs = AppPreference.instance;
            await prefs.set(
                key: AppPreference.KEY_TOKEN, value: user.token ?? "");
            await prefs.set(
              key: AppPreference.KEY_USER_DETAILS,
              value: jsonEncode(user.user?.toJson()),
            );

            emit(AuthSuccess(user));
            LoadingScreenOL().hide();
          },
        );
      } else {
        LoadingScreenOL().hide();
      }
    } catch (e) {
      print("Google Login Failed ${e.toString()}");
      LoadingScreenOL().hide();
    }
  }
}
