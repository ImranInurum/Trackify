import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/feature/map/data/entity/promo_video_model.dart';
import 'package:trackify/core/utils/typedefs.dart';

abstract class PromoVideoRepository {
  ResultFuture<List<PromoVideoModel>> getPromoVideos(String imei);
}
