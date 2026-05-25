import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
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
    final iMEI = await prefs.get(key: AppPreference.IMEI);
    final box = Hive.box('map_cache');
    final cacheKey = 'ride_history_$iMEI';
    final cachedData = box.get(cacheKey);

    List<Ride>? cachedList;
    if (cachedData != null) {
      try {
        final decoded = jsonDecode(cachedData.toString()) as List<dynamic>;
        cachedList = decoded.map((e) => Ride.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        // Cache parsing failed, ignore
      }
    }

    if (cachedList != null && cachedList.isNotEmpty) {
      emit(RideHistorySuccess(cachedList));
    } else {
      emit(RideHistoryLoading());
    }

    final request = {
      'imei': iMEI,
    };
    debugPrint('Assigning device with request: $request');
    final result = await _assignDeviceUseCase.getRideHistory(body: request);
    result.fold(
      (exception) {
        if (cachedList == null || cachedList.isEmpty) {
          emit(RideHistoryFailure(exception));
        }
      },
      (data) {
        try {
          box.put(cacheKey, jsonEncode(data.map((e) => e.toJson()).toList()));
        } catch (_) {
          // Cache saving failed, ignore
        }
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

  void sortRides(String sortBy, bool isRecentToOldest) {
    if (state is! RideHistorySuccess) return;
    
    final currentRides = List<Ride>.from((state as RideHistorySuccess).rides);
    
    currentRides.sort((a, b) {
      int comparison = 0;
      
      switch (sortBy) {
        case 'Date':
          // Assuming date is in a sortable format or using index/id if not
          comparison = a.startTime.compareTo(b.startTime);
          break;
        case 'Distance':
          comparison = a.distance.compareTo(b.distance);
          break;
        case 'Duration':
          // Extract minutes for comparison
          int durA = int.tryParse(a.duration.replaceAll('m', '')) ?? 0;
          int durB = int.tryParse(b.duration.replaceAll('m', '')) ?? 0;
          comparison = durA.compareTo(durB);
          break;
      }
      
      return isRecentToOldest ? -comparison : comparison;
    });
    
    emit(RideHistorySuccess(currentRides));
  }
}
