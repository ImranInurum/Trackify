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

  String currentSortBy = 'Date';
  bool currentIsRecentToOldest = true;

  Future<void> getRideHistoryData() async {
    final iMEI = await prefs.get(key: AppPreference.IMEI);
    if (iMEI == null || iMEI.isEmpty) {
      emit(RideHistorySuccess(const []));
      return;
    }

    final distanceUnit = await prefs.get(key: AppPreference.KEY_DISTANCE_UNIT);
    final unit = distanceUnit.isNotEmpty ? distanceUnit : 'km';
    
    final box = Hive.box('map_cache');
    final cacheKey = 'ride_history_${iMEI}_$unit';
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
      'unit': unit,
    };
    debugPrint('Fetching ride history with request: $request');
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
    currentSortBy = sortBy;
    currentIsRecentToOldest = isRecentToOldest;
    
    if (state is! RideHistorySuccess) return;
    
    final currentRides = List<Ride>.from((state as RideHistorySuccess).rides);
    
    currentRides.sort((a, b) {
      int comparison = 0;
      
      switch (sortBy) {
        case 'Date':
          final dateA = DateTime.tryParse(a.rawStartTime) ?? _parseFallback(a);
          final dateB = DateTime.tryParse(b.rawStartTime) ?? _parseFallback(b);
          comparison = dateB.compareTo(dateA); // Descending
          break;
        case 'Distance':
          comparison = b.distance.compareTo(a.distance); // Descending
          break;
        case 'Duration':
          // Extract minutes for comparison
          int durA = int.tryParse(a.duration.replaceAll('m', '')) ?? 0;
          int durB = int.tryParse(b.duration.replaceAll('m', '')) ?? 0;
          comparison = durB.compareTo(durA); // Descending
          break;
      }
      
      return isRecentToOldest ? comparison : -comparison;
    });
    
    emit(RideHistorySuccess(currentRides));
  }

  DateTime _parseFallback(Ride ride) {
    try {
      final dateParts = ride.date.split('/');
      if (dateParts.length == 3) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);
        
        int hour = 0;
        int minute = 0;
        final timeParts = ride.startTime.split(' ');
        if (timeParts.length == 2) {
          final time = timeParts[0].split(':');
          if (time.length == 2) {
            hour = int.parse(time[0]);
            minute = int.parse(time[1]);
            if (timeParts[1].toUpperCase() == 'PM' && hour != 12) {
              hour += 12;
            } else if (timeParts[1].toUpperCase() == 'AM' && hour == 12) {
              hour = 0;
            }
          }
        }
        return DateTime(year, month, day, hour, minute);
      }
    } catch (_) {}
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
