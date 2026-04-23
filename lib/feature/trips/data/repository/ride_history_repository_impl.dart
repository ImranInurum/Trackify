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
            
            // If the API returns a status: true and has a summary, map it to a Ride entity.
            // For now, we take the summary as one 'Ride' entry in the list.
            if (historyResponse.status == true && historyResponse.summary != null) {
              final ride = Ride.fromSummary("1", historyResponse.summary!);
              return Right([ride]);
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
