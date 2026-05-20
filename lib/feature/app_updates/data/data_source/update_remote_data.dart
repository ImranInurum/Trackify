import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';
import '../model/update_model.dart';

class UpdateRemoteDataSource {

  Future<List<UpdateModel>> getUpdates() async {

    final response = await http.get(
      Uri.parse(ApiURL.appUpdate),
    );

    if (response.statusCode == 200) {

      final decodeData = jsonDecode(response.body);

      final List data = decodeData['data'];

      return data
          .where(
            (e) =>
        (e['title'] ?? "")
            .toString()
            .trim()
            .isNotEmpty &&
            (e['description'] ?? "")
                .toString()
                .trim()
                .isNotEmpty,
      )
          .map((e) => UpdateModel.fromJson(e))
          .toList();

    } else {
      throw Exception("Failed to load update");
    }
  }
}