import '../../../../core/utils/typedefs.dart';
import '../../data/entity/notification_model.dart';

abstract interface class NotificationRepository {
  ResultFuture<NotificationModel> getNotifications(String userId);
}
