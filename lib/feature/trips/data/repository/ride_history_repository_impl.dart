import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/typedefs.dart';

import '../../domain/repository/ride_history_repository.dart';
import '../entity/ride_model.dart';



class RideHistoryRepositoryImpl implements RideHistoryRepository {
  final NetworkApiService _apiService = NetworkApiService();

  final List<Ride> rideHistoryList = [
    Ride(
      id: "1",
      date: "Thursday, Apr 02, 2026",
      startTime: "09:12 AM",
      endTime: "10:04 AM",
      distance: 12.4,
      duration: "52m",
      avgSpeed: 23.8,
      topSpeed: 45.2,
      startLocation: "Indiranagar, Bangalore",
      endLocation: "MG Road, Bangalore",
      mapImageUrl: "https://api.placeholder.com/400/200",
    ),
  ];

  @override
  ResultFuture<List<Ride>> rideHistory(Map<String, dynamic> body) async {
    try {
      debugPrint('Assigning device with request: $body');
      // final response = await _apiService.getPostApiResponse(
      //   ApiURL.assignDevices,
      //   body,
      // );
      // debugPrint('ride history response: $response');
      // NetworkApiService's getPostApiResponse already returns an Either<AppException, dynamic>
      return  Right(rideHistoryList) ;
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException('Unexpected error: $e'));
    }
  }
}
