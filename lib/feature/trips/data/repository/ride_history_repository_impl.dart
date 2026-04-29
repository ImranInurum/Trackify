import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/typedefs.dart';

import '../../domain/repository/ride_history_repository.dart';
import '../entity/ride_history_response_model.dart';
import '../entity/ride_model.dart';

class RideHistoryRepositoryImpl implements RideHistoryRepository {
  final NetworkApiService _apiService = NetworkApiService();

  @override
  ResultFuture<List<Ride>> rideHistory(Map<String, dynamic> body) async {
    try {
      debugPrint('ride history request body: $body');
      final result = await _apiService.getPostApiResponse(
        ApiURL.journeyRideHistory,
        body,
      );

      return result.fold(
        (exception) => Left(exception),
        (response) {
          debugPrint('ride history response received: $response');
          try {
            final historyResponse = RideHistoryResponseModel.fromJson(response);
            
            if (historyResponse.status == true && historyResponse.data != null) {
              final rides = historyResponse.data!
                  .asMap()
                  .entries
                  .map((entry) => Ride.fromTripModel(
                        entry.key.toString(),
                        entry.value,
                      ))
                  .toList();
              return Right(rides);
            }
            
            return const Right([]);
          } catch (e) {
            debugPrint('Error parsing ride history: $e');
            return Left(FetchDataException('Parsing error: $e'));
          }
        },
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException('Unexpected error: $e'));
    }
  }
}
