import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/feature/map/data/entity/product_feature_model.dart';
import 'package:trackify/feature/map/presentation/cubit/product_feature_state.dart';

class ProductFeatureCubit extends Cubit<ProductFeatureState> {
  ProductFeatureCubit() : super(ProductFeatureInitial());

  static const _cacheKey = 'product_features_data';

  Future<void> fetchProductFeatures() async {
    // ── Load from cache first for instant display ──
    try {
      final box = Hive.box('map_cache');
      final cachedData = box.get(_cacheKey);
      if (cachedData != null) {
        final decoded = jsonDecode(cachedData.toString()) as List<dynamic>;
        final cached = decoded
            .map((e) => ProductFeatureModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (cached.isNotEmpty) {
          emit(ProductFeatureLoaded(features: cached));
        }
      }
    } catch (_) {}

    if (state is! ProductFeatureLoaded) {
      emit(ProductFeatureLoading());
    }

    // ── Fetch from network ──
    try {
      final response = await http
          .get(Uri.parse(ApiURL.productFeatures))
          .timeout(const Duration(seconds: 12));

      if (isClosed) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        List<dynamic> rawList = [];
        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map) {
          rawList = (decoded['data'] as List<dynamic>?) ??
              (decoded['features'] as List<dynamic>?) ??
              [];
        }

        final features = rawList
            .map((e) => ProductFeatureModel.fromJson(e as Map<String, dynamic>))
            .toList();

        // Cache the result
        try {
          final box = Hive.box('map_cache');
          box.put(_cacheKey, jsonEncode(features.map((e) => e.toJson()).toList()));
        } catch (_) {}

        if (!isClosed) {
          emit(ProductFeatureLoaded(features: features));
        }
      } else {
        if (state is! ProductFeatureLoaded) {
          emit(ProductFeatureError('Server error: ${response.statusCode}'));
        }
      }
    } catch (e) {
      debugPrint('[ProductFeatureCubit] Error: $e');
      if (!isClosed && state is! ProductFeatureLoaded) {
        emit(ProductFeatureError('Failed to load features'));
      }
    }
  }
}
