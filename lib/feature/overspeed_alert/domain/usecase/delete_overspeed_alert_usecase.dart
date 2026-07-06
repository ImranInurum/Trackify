import 'package:trackify/core/utils/typedefs.dart';
import '../repository/overspeed_alert_repository.dart';

class DeleteOverspeedAlertUsecase {
  final OverspeedAlertRepository repository;

  DeleteOverspeedAlertUsecase(this.repository);

  ResultFuture<String> call(String id) {
    return repository.deleteOverspeedAlert(id);
  }
}
