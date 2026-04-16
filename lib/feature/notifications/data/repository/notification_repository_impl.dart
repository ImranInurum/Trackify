import 'package:fpdart/fpdart.dart';
import '../../../../core/config/network/api_host.dart';
import '../../../../core/config/network/base_api_service.dart';
import '../../../../core/config/network/exceptions.dart';
import '../../../../core/config/network/network_api_service.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/repository/notification_repository.dart';
import '../entity/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<NotificationModel> getNotifications(String userId) async {
    try {
      final res = await _apiServices.getGetApiResponse(ApiURL.notifications(userId));
      return res.fold(
        (error) => Left(error),
        (data) => Right(NotificationModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
