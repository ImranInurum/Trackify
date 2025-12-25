import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/shared_preferences.dart';
import '../../domain/usecase/auth_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCase _authCase;

  AuthCubit(this._authCase) : super(AuthInitial());

  Future<void> loginUser(Map<String, dynamic> body) async {
    emit(AuthLoading());
    final result = await _authCase.loginCall(body);

    result.fold((failure) => emit(AuthFailure(failure)), (user) async {
      final prefs = AppPreference.instance;
      await prefs.set(key: AppPreference.KEY_TOKEN, value: user.token ?? "");
      await prefs.set(
        key: AppPreference.KEY_USER_DETAILS,
        value: jsonEncode(user.user?.toJson()),
      );
      emit(AuthSuccess(user));
    });
  }

  Future<void> registerUser(Map<String, dynamic> body) async {
    emit(AuthLoading());
    final result = await _authCase.registerCall(body);

    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
