import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/network/api_host.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repository/product_repository.dart';
import '../local data/product_local_data.dart';
import '../model/product model.dart';

class ProductRepositoryImpl implements ProductRepository {

  @override
  Future<List<ProductEntity>> getProduct() async {
    try {
      final url = '${ApiURL.baseURL}/api/product-catalog/list?activeOnly=true';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          final List list = body['data'];
          if (list.isNotEmpty) {
            return list.map((e) => ProductModel.fromJson(e)).toList();
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching dynamic products from API: $e");
    }

    // Fallback to local data
    return ProductLocalData.products
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }
}