import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/auth_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCase _authCase;

  AuthCubit(this._authCase) : super(AuthInitial());

  Future<void> loginUser(Map<String, dynamic> body) async {
    emit(AuthLoading());
    final result = await _authCase.loginCall(body);

    result.fold(
          (failure) => emit(AuthFailure(failure)),
          (user) => emit(AuthSuccess(user)),
    );
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
