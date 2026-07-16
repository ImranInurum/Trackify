import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/map/data/entity/promo_video_model.dart';
import 'package:trackify/feature/map/domain/repository/promo_video_repository.dart';

class PromoVideoRepositoryImpl implements PromoVideoRepository {
  final NetworkApiService _apiService = NetworkApiService();

  @override
  ResultFuture<List<PromoVideoModel>> getPromoVideos(String imei) async {
    try {
      final result = await _apiService.getGetApiResponse(ApiURL.promoVideos(imei));

      return result.fold(
        (exception) => Left(exception),
        (response) {
          try {
            if (response is Map<String, dynamic> && (response['status'] == true || response['success'] == true)) {
              final dataList = response['data'] as List<dynamic>?;
              if (dataList != null) {
                final videos = dataList.map((e) => PromoVideoModel.fromJson(e as Map<String, dynamic>)).toList();
                return Right(videos);
              }
            }
            return const Right([]);
          } catch (e) {
            debugPrint('Error parsing promo videos: $e');
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
