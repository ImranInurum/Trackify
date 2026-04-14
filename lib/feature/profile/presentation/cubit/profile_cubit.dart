import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/profile/domain/use_case/profile_use_case.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_state.dart';

import '../../../../../core/utils/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileUseCase _psUseCase;

  ProfileCubit(this._psUseCase) : super(ProfileInitial());

  Future<void> fetchVehicles() async {
    emit(VehiclesLoading());

    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);

    if (userId.isEmpty) {
      emit(const FetchVehicleError("User session not found. Please log in again."));
      return;
    }

    final result = await _psUseCase.getVehicles(userId: userId);

    result.fold(
      (failure) => emit(FetchVehicleError(failure.message ?? "Unexpected error")),
      (response) {
        final vehicles = response.vehicles ?? [];
        emit(VehiclesLoaded(vehicles));
      },
    );
  }
}
