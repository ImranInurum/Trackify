import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';

import '../model/time_slot_model.dart';

class BookingRemoteDataSource {
  final BaseApiServices _apiServices;

  BookingRemoteDataSource(this._apiServices);

  /// GET SLOTS
  Future<SlotResponse> getSlots() async {
    final response = await _apiServices.getGetApiResponse(ApiURL.timeSlots);

    return response.fold(
      (l) => throw l,
      (r) => SlotResponse.fromJson(r['data']),
    );
  }
}