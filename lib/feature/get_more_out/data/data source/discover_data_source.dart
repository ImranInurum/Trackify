// ===============================
// discover_remote_data_source.dart
// ===============================

import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/constants/app_images.dart';
import '../models/discover_model.dart';

class DiscoverDataSource {
  Future<List<DiscoverModel>> getDiscoverFeatures() async {
    try {
      final response = await NetworkApiService().getGetApiResponse(
        ApiURL.discover,
      );

      return response.fold(
        (failure) => _getFallbackFeatures(),
        (success) {
          if (success['success'] == true &&
              success['data'] != null &&
              (success['data'] as List).isNotEmpty) {
            final List data = success['data'];
            final list = DiscoverModel.fromList(data);
            return _mergeAllFeatures(list);
          } else {
            return _getFallbackFeatures();
          }
        },
      );
    } catch (_) {
      return _getFallbackFeatures();
    }
  }

  List<DiscoverModel> _mergeAllFeatures(List<DiscoverModel> apiList) {
    final fallbacks = _getFallbackFeatures();
    final Map<String, DiscoverModel> map = {};

    for (final f in fallbacks) {
      map[f.id] = f;
    }

    for (final item in apiList) {
      final titleLower = item.title.toLowerCase();

      if (titleLower.contains('geofence')) {
        map['cat_geofence'] = DiscoverModel(
          id: 'cat_geofence',
          title: item.title,
          subtitle: item.subtitle.isNotEmpty ? item.subtitle : map['cat_geofence']!.subtitle,
          image: map['cat_geofence']!.image,
          exploredText: item.exploredText.isNotEmpty ? item.exploredText : map['cat_geofence']!.exploredText,
        );
      } else if (titleLower.contains('parking') || titleLower.contains('safe')) {
        map['cat_safe_parking'] = DiscoverModel(
          id: 'cat_safe_parking',
          title: item.title,
          subtitle: item.subtitle.isNotEmpty ? item.subtitle : map['cat_safe_parking']!.subtitle,
          image: map['cat_safe_parking']!.image,
          exploredText: item.exploredText.isNotEmpty ? item.exploredText : map['cat_safe_parking']!.exploredText,
        );
      } else if (titleLower.contains('speed') || titleLower.contains('overspeed')) {
        map['cat_overspeed'] = DiscoverModel(
          id: 'cat_overspeed',
          title: item.title,
          subtitle: item.subtitle.isNotEmpty ? item.subtitle : map['cat_overspeed']!.subtitle,
          image: map['cat_overspeed']!.image,
          exploredText: item.exploredText.isNotEmpty ? item.exploredText : map['cat_overspeed']!.exploredText,
        );
      } else {
        map['cat_tracking'] = DiscoverModel(
          id: 'cat_tracking',
          title: item.title,
          subtitle: item.subtitle.isNotEmpty ? item.subtitle : map['cat_tracking']!.subtitle,
          image: map['cat_tracking']!.image,
          exploredText: item.exploredText.isNotEmpty ? item.exploredText : map['cat_tracking']!.exploredText,
        );
      }
    }

    return map.values.toList();
  }

  List<DiscoverModel> _getFallbackFeatures() {
    return [
      DiscoverModel(
        id: 'cat_tracking',
        title: 'Vehicle Tracking & Location Sharing',
        subtitle: 'Track your vehicle live, share location with family, and locate your vehicle in crowded areas',
        image: AppImages.trackingImage,
        exploredText: '0/1 Feature explored',
      ),
      DiscoverModel(
        id: 'cat_geofence',
        title: 'Geofence Security',
        subtitle: 'Set safe zones and receive instant alerts when vehicle enters or leaves boundary',
        image: AppImages.exploreApp,
        exploredText: '0/1 Feature explored',
      ),
      DiscoverModel(
        id: 'cat_safe_parking',
        title: 'Safe Parking Mode',
        subtitle: 'Protect your vehicle against theft with real-time motion and ignition alerts',
        image: AppImages.safeParking,
        exploredText: '0/1 Feature explored',
      ),
      DiscoverModel(
        id: 'cat_overspeed',
        title: 'Speed & Trip Analytics',
        subtitle: 'Set custom overspeed limits and analyze detailed trip history logs',
        image: AppImages.rideImage,
        exploredText: '0/1 Feature explored',
      ),
    ];
  }
}