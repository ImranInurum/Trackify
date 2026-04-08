import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/shared_preferences.dart';
import '../../data/models/add_vehicle_request.dart';
import '../../domain/repository/add_vehicle_repository.dart';
import 'add_vehicle_state.dart';

class AddVehicleCubit extends Cubit<AddVehicleState> {
  final AddVehicleRepository _repository;

  AddVehicleCubit(this._repository) : super(AddVehicleInitial());

  Future<void> addVehicle({
    required String vehicleType,
    required String fuelType,
    required String vehicleMaker,
    required String vehicleNumber,
    required String vehicleModel,
  }) async {
    emit(AddVehicleLoading());
    
    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);
    
    final request = AddVehicleRequest(
      vehicleType: vehicleType,
      fuelType: fuelType,
      vehicleMaker: vehicleMaker,
      vehicleNumber: vehicleNumber,
      vehicleModel: vehicleModel,
      userId: userId,
    );

    final result = await _repository.addVehicle(request);

    result.fold(
      (failure) => emit(AddVehicleError(failure.message)),
      (success) => emit(AddVehicleSuccess(success)),
    );
  }
}
