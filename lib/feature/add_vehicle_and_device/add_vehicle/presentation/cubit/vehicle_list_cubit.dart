// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../core/utils/shared_preferences.dart';
// import '../../domain/repository/add_vehicle_repository.dart';
// import 'vehicle_list_state.dart';
//
// class VehicleListCubit extends Cubit<VehicleListState> {
//   final AddVehicleRepository _repository;
//
//   VehicleListCubit(this._repository) : super(VehicleListInitial());
//
//   Future<void> fetchVehicles() async {
//     emit(VehicleListLoading());
//
//     final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);
//
//     if (userId.isEmpty) {
//       emit(const VehicleListError("User session not found. Please log in again."));
//       return;
//     }
//
//     final result = await _repository.getVehicles(userId);
//
//     result.fold(
//       (failure) => emit(VehicleListError(failure.message ?? "Unexpected error")),
//       (response) {
//         final vehicles = response.vehicles ?? [];
//         emit(VehicleListLoaded(vehicles));
//       },
//     );
//   }
// }
