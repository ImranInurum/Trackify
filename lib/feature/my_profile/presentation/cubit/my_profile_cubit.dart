import 'package:bloc/bloc.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_request.dart';
import 'package:trackify/feature/my_profile/domain/use_case/my_profile_use_case.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final MyProfileUseCase _myProfileUseCase;

  MyProfileCubit(this._myProfileUseCase) : super(MyProfileInitial());

  Future<void> updateProfile({
    required String userId,
    required UpdateProfileRequest request,
    List<int>? profileImageBytes,
    String? profileImageName,
  }) async {
    emit(MyProfileLoading());
    final result = await _myProfileUseCase.updateProfile(
      userId: userId,
      request: request,
      profileImageBytes: profileImageBytes,
      profileImageName: profileImageName,
    );
    result.fold(
      (failure) => emit(MyProfileError(errorMessage: failure.message)),
      (response) {
        if (response.success && response.data != null) {
          emit(MyProfileSuccess(user: response.data!, message: response.message));
        } else {
          emit(MyProfileError(
            errorMessage: response.message.isNotEmpty
                ? response.message
                : 'Failed to update profile',
          ));
        }
      },
    );
  }

  void reset() {
    emit(MyProfileInitial());
  }
}
