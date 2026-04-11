import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/my_garage/domain/use_case/my_garage_use_case.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_state.dart';

import '../../../../../core/utils/shared_preferences.dart';

class MyGarageCubit extends Cubit<MyGarageState> {
  final MyGarageUseCase _myGarageUseCase = MyGarageUseCase();

  MyGarageCubit() : super(MyGarageInitial());

  Future<void> fetchVehicles() async {
    emit(VehiclesLoading());

    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);

    if (userId.isEmpty) {
      emit(const FetchVehicleError("User session not found. Please log in again."));
      return;
    }

    final result = await _myGarageUseCase.getVehicles(userId: userId);

    result.fold(
      (failure) => emit(FetchVehicleError(failure.message ?? "Unexpected error")),
      (response) {
        final vehicles = response.vehicles ?? [];
        emit(VehiclesLoaded(vehicles));
      },
    );
  }
}
