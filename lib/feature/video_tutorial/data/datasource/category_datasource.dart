import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';

import '../model/category_model.dart';

class CategoryRemoteData {

  Future<List<CategoryModel>>
  fetchCategories() async {

    final response = await http.get(
      Uri.parse(ApiURL.category),
    );

    final body = jsonDecode(response.body);

    final List data = body['data'];

    return data
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }
}