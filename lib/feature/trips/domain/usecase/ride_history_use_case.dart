import 'package:trackify/core/utils/typedefs.dart';

import '../../data/entity/ride_model.dart';
import '../repository/ride_history_repository.dart';


class RideHistoryUseCase {
  final RideHistoryRepository _repository;

  RideHistoryUseCase(this._repository);

  ResultFuture<List<Ride>> getRideHistory({required  Map<String, dynamic> body}) {
    return _repository.rideHistory(body);
  }
}
