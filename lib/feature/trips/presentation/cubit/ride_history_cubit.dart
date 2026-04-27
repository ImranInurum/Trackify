import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_state.dart';
import '../../../../core/services/geocoding_service.dart';
import '../../data/entity/ride_model.dart';
import '../../domain/usecase/ride_history_use_case.dart';


class RideHistoryCubit extends Cubit<RideHistoryState> {
  final RideHistoryUseCase _assignDeviceUseCase;

  RideHistoryCubit(this._assignDeviceUseCase) : super(RideHistoryInitial());
  final prefs = AppPreference.instance;
  Future<void> getRideHistoryData() async {
    emit(RideHistoryLoading());
    await Future.delayed(const Duration(seconds: 2));
    await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);
    final iMEI = await prefs.get(key: AppPreference.IMEI);
    final request = {
      'imei': iMEI ,
    };
    debugPrint('Assigning device with request: $request');
    final result = await _assignDeviceUseCase.getRideHistory(body: request);
    result.fold(
          (exception) => emit(RideHistoryFailure(exception)),
          (data) {
            emit(RideHistorySuccess(data));
            _geocodeRides(data);
          },
    );
  }

  Future<void> _geocodeRides(List<Ride> rides) async {
    final geocodingService = GeocodingService.instance;
    final updatedRides = List<Ride>.from(rides);

    for (int i = 0; i < updatedRides.length; i++) {
      final ride = updatedRides[i];
      final validPoints = ride.polylinePoints
          .where((p) => p.latitude != 0.0 && p.longitude != 0.0)
          .toList();
          
      if (validPoints.isNotEmpty) {
        final startName = await geocodingService.reverseGeocode(validPoints.first);
        final endName = await geocodingService.reverseGeocode(validPoints.last);

        if (startName != ride.startLocation || endName != ride.endLocation) {
          updatedRides[i] = ride.copyWith(
            startLocation: startName,
            endLocation: endName,
          );
          
          if (!isClosed) {
            emit(RideHistorySuccess(List.from(updatedRides)));
          }
        }
      }
    }
  }
}
