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

      final userCredential = await GoogleAuthService.instance.signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        final firebaseUser = userCredential.user!;

        // 1. Get the Firebase ID Token
        final String? token = await firebaseUser.getIdToken();

        // 2. Map Firebase User to your local 'User' model
        final localUser = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? "Google User",
          email: firebaseUser.email,
          role: "user", // Default role
        );

        // 3. Create the full LoginResponseModel
        final loginResponse = LoginResponseModel(
          status: "success",
          message: "Google Login Successful",
          token: token,
          user: localUser,
        );

        // 4. Persist Data (Same as your regular login)
        final prefs = AppPreference.instance;
        await prefs.set(key: AppPreference.KEY_TOKEN, value: token ?? "");
        await prefs.set(
          key: AppPreference.KEY_USER_DETAILS,
          value: jsonEncode(localUser.toJson()),
        );

        // 5. Emit success with the correct type (LoginResponseModel)
        emit(AuthSuccess(loginResponse));
        LoadingScreenOL().hide();
      } else {
        LoadingScreenOL().hide();
      }
    } catch (e) {
      print("Google Login Failed ${e.toString()}");
      LoadingScreenOL().hide();
    }
  }
}
