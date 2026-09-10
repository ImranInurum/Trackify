import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/network/api_host.dart';
import '../../../../core/constants/app_images.dart';

import '../models/geo_fence_model.dart';

class GeoFenceIntroDataSource {
  Future<List<GeoFenceIntroModel>> getIntroSlides(
    String categoryId,
  ) async {
    if (categoryId.startsWith('cat_')) {
      return _getFallbackSlides(categoryId);
    }
    try {
      final response = await http.get(
        Uri.parse(
          ApiURL.geoFenceIntro.replaceAll('{featureId}', categoryId),
        ),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final list = GeoFenceIntroModel.fromApiResponse(decodedData);
        if (list.length > 1) return list;
      }
    } catch (_) {}
    return _getFallbackSlides(categoryId);
  }

  List<GeoFenceIntroModel> _getFallbackSlides(String categoryId) {
    final catLower = categoryId.toLowerCase();

    if (catLower.contains('geofence')) {
      return [
        GeoFenceIntroModel(
          title: "Set Up Virtual Boundaries",
          description: "Create custom geofence radius or boundary shapes around home, office, or frequently visited places.",
          image: AppImages.exploreApp,
          buttonText: "Set Up Geofence Now",
        ),
        GeoFenceIntroModel(
          title: "Real-Time Entry & Exit Alerts",
          description: "Get immediate notification alerts as soon as your vehicle enters or exits a predefined boundary.",
          image: AppImages.trackingImage,
          buttonText: "Go to Geofence",
        ),
      ];
    } else if (catLower.contains('location') || catLower.contains('tracking')) {
      return [
        GeoFenceIntroModel(
          title: "Live Vehicle Location Sharing",
          description: "Share temporary or live location tracking links with family and friends safely.",
          image: AppImages.trackingImage,
          buttonText: "Start Sharing Location",
        ),
        GeoFenceIntroModel(
          title: "Custom Link Expiration",
          description: "Choose link validity durations (1 hr, 8 hrs, 24 hrs) and manage shared links effortlessly.",
          image: AppImages.exploreApp,
          buttonText: "Go to Location Sharing",
        ),
      ];
    } else if (catLower.contains('parking') || catLower.contains('safe')) {
      return [
        GeoFenceIntroModel(
          title: "Safe Parking Mode",
          description: "Activate Safe Parking when leaving your vehicle in public or unmonitored parking spots.",
          image: AppImages.safeParking,
          buttonText: "Enable Safe Parking",
        ),
        GeoFenceIntroModel(
          title: "Instant Anti-Theft Siren",
          description: "Receive high-priority alarm notifications if any unauthorized motion or ignition is detected.",
          image: AppImages.rideImage,
          buttonText: "Go to Safe Parking",
        ),
      ];
    } else if (catLower.contains('speed') || catLower.contains('overspeed')) {
      return [
        GeoFenceIntroModel(
          title: "Custom Speed Thresholds",
          description: "Configure speed limit alerts to ensure safe driving habits and protect your vehicle.",
          image: AppImages.rideImage,
          buttonText: "Set Overspeed Alert",
        ),
        GeoFenceIntroModel(
          title: "Instant Speed Violation Alerts",
          description: "Get real-time push alerts whenever your vehicle exceeds your designated speed limit.",
          image: AppImages.trackingImage,
          buttonText: "Go to Overspeed Alerts",
        ),
      ];
    }

    return [
      GeoFenceIntroModel(
        title: "Trackify Smart Features",
        description: "Explore advanced GPS tracking, geofencing, and smart anti-theft security tools.",
        image: AppImages.trackingImage,
        buttonText: "Explore Now",
      ),
    ];
  }
}