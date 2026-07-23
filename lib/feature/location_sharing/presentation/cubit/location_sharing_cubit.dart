import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/common/repositories/common_repo_impl.dart' as trackify;
import 'location_sharing_state.dart';

class LocationSharingCubit extends Cubit<LocationSharingState> {
  final NetworkApiService _apiService = NetworkApiService();

  LocationSharingCubit() : super(LocationSharingInitial());

  void loadLocations() async {
    emit(LocationSharingLoading());

    // Fetch actual device ID for the phone
    String phoneDeviceId = 'UNKNOWN_DEVICE';
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          phoneDeviceId = androidInfo.id;
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          phoneDeviceId = iosInfo.identifierForVendor ?? 'UNKNOWN_DEVICE';
        }
      }
    } catch (e) {
      debugPrint('Error fetching device ID: $e');
    }

    // Keep Phone Location as the first item
    final items = [
      LocationSharingItem(
        id: 'phone',
        name: "Your Phone's Location",
        isSharing: false,
        isPhone: true,
        imei: phoneDeviceId,
      ),
    ];

    try {
      final trackify.CommonRepositoryImpl commonRepo = trackify.CommonRepositoryImpl();
      final res = await commonRepo.getUserVehicles();

      res.fold(
        (failure) {
          debugPrint('Error fetching vehicles: ${failure.message}');
        },
        (vehicleListResponse) {
          final vehicles = vehicleListResponse.vehicles ?? [];
          for (var vehicle in vehicles) {
            items.add(LocationSharingItem(
              id: vehicle.id ?? vehicle.imei ?? '',
              name: '${vehicle.vehicleMaker ?? ''} ${vehicle.vehicleModel ?? ''} (${vehicle.vehicleNumber ?? ''})',
              isSharing: false,
              isPhone: false,
              imei: vehicle.imei ?? '',
            ));
          }
        },
      );
    } catch (e) {
      debugPrint('Error loading vehicles in LocationSharingCubit: $e');
    }

    emit(LocationSharingLoaded(items: items));
  }

  void toggleSharing(String id) {
    if (state is LocationSharingLoaded) {
      final items = (state as LocationSharingLoaded).items;
      final updatedItems = items.map((item) {
        if (item.id == id) {
          return item.copyWith(isSharing: !item.isSharing);
        }
        return item;
      }).toList();
      emit(LocationSharingLoaded(items: updatedItems));
    }
  }

  Future<void> shareLiveLocation(BuildContext context, String id, int duration) async {
    if (state is! LocationSharingLoaded) return;
    
    final items = (state as LocationSharingLoaded).items;
    final itemIndex = items.indexWhere((e) => e.id == id);
    if (itemIndex == -1) return;
    
    final item = items[itemIndex];
    
    try {
      // 1. Create Share Link
      final createUrl = '${ApiURL.baseURL}/api/share/create';
      final shareType = item.isPhone ? 'device' : 'ride';
      
      final Map<String, dynamic> createBody = {
        "shareType": shareType,
        "expiresInHours": duration == 0 ? 8760 : duration,
      };

      if (shareType == 'ride') {
        createBody['imei'] = item.imei.isNotEmpty ? item.imei : 'UNKNOWN_IMEI';
        createBody['startDate'] = DateTime.now().toUtc().toIso8601String();
        createBody['endDate'] = DateTime.now().toUtc().add(Duration(hours: duration == 0 ? 8760 : duration)).toIso8601String();
      } else {
        createBody['imei'] = null;
      }
      
      final createResult = await _apiService.getPostApiResponse(createUrl, createBody);
      
      String token = '';
      String? errorMessage;
      
      createResult.fold(
        (failure) {
          debugPrint('Error creating share link: ${failure.message}');
          errorMessage = failure.message;
        },
        (success) {
          if (success['success'] == true && success['data'] != null) {
            token = success['data']['token'];
          } else {
            errorMessage = success['message']?.toString() ?? 'Failed to create share link';
          }
        },
      );
      
      if (token.isEmpty) {
        if (context.mounted && errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage!), backgroundColor: Colors.red));
        }
        return;
      }
      
      // 2. Fetch mapLink
      final endpoint = shareType == 'device' ? 'device' : 'ride';
      final fetchUrl = '${ApiURL.baseURL}/api/share/$endpoint/$token';
      
      final fetchResult = await _apiService.getGetApiResponse(fetchUrl);
      
      String shareUrl = '';
      
      fetchResult.fold(
        (failure) {
          debugPrint('Error fetching share link: ${failure.message}');
          errorMessage = failure.message;
        },
        (success) {
          if (success['success'] == true) {
            shareUrl = success['deepLink'] ?? success['result']?['mapLink'] ?? '';
          } else {
            errorMessage = success['message']?.toString() ?? 'Failed to fetch share link';
          }
        },
      );
      
      if (shareUrl.isEmpty) {
        if (context.mounted && errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage!), backgroundColor: Colors.red));
        }
        return;
      }
      
      // 3. Share the link
      if (shareUrl.isNotEmpty) {
        // Update UI state so the card shows active sharing
        final updatedItems = List<LocationSharingItem>.from(items);
        updatedItems[itemIndex] = item.copyWith(isSharing: true);
        emit(LocationSharingLoaded(items: updatedItems));

        // Trigger native share sheet
        await Share.share('Track my live location here: $shareUrl');
      }
      
    } catch (e) {
      debugPrint('Exception in shareLiveLocation: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    }
  }
}