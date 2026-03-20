import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/onboarding/domain/usecases/get_logo_usecase.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GetLogoUseCase getLogoUseCase;

  SplashCubit(this.getLogoUseCase) : super(SplashInitial());

  Future<void> fetchLogo() async {
    emit(SplashLoading());
    final result = await getLogoUseCase();
    result.fold(
      (failure) => emit(SplashError(failure.message)),
      (logo) => emit(SplashLoaded(logo)),
    );
  }
}
