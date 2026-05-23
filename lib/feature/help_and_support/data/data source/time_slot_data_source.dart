import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/network/api_host.dart';

import '../model/time_slot_model.dart';

class BookingRemoteDataSource {

  /// GET SLOTS
  Future<SlotResponse> getSlots() async {

    final response = await http.get(

      Uri.parse(ApiURL.timeSlots),

      headers: {
        "Content-Type":
        "application/json",
      },
    );

    final jsonData =
    jsonDecode(response.body);

    if (response.statusCode == 200 &&
        jsonData["success"] == true) {

      return SlotResponse.fromJson(
        jsonData["data"],
      );

    } else {

      throw Exception(

        jsonData["message"] ??
            "Failed to fetch slots",
      );
    }
  }

  /// POST SLOT
  Future<Map<String, dynamic>>
  bookSlot({

    required String token,
    required String slotId,

  }) async {

    final response = await http.post(

      Uri.parse(
        ApiURL.bookingSlot,
      ),

      headers: {

        "Content-Type":
        "application/json",

        "Authorization":
        "Bearer $token",
      },

      body: jsonEncode({

        "callSlotId":
        slotId,
      }),
    );

    final jsonData =
    jsonDecode(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      return jsonData;

    } else {

      throw Exception(

        jsonData["message"] ??
            "Failed to book slot",
      );
    }
  }
}