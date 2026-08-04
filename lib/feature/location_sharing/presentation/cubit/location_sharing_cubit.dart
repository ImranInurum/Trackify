import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/common/repositories/common_repo_impl.dart'
    as trackify;
import 'package:trackify/core/common/widgets/unlock_device_dialog.dart';
import '../../../../l10n/app_localizations.dart';
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
      final trackify.CommonRepositoryImpl commonRepo =
          trackify.CommonRepositoryImpl();
      final res = await commonRepo.getUserVehicles();

      res.fold(
        (failure) {
          debugPrint('Error fetching vehicles: ${failure.message}');
        },
        (vehicleListResponse) {
          final vehicles = vehicleListResponse.vehicles ?? [];
          for (var vehicle in vehicles) {
            items.add(
              LocationSharingItem(
                id: vehicle.id ?? vehicle.imei ?? '',
                name:
                    '${vehicle.vehicleMaker ?? ''} ${vehicle.vehicleModel ?? ''} (${vehicle.vehicleNumber ?? ''})',
                isSharing: false,
                isPhone: false,
                imei: vehicle.imei ?? '',
              ),
            );
          }
        },
      );
    } catch (e) {
      debugPrint('Error loading vehicles in LocationSharingCubit: $e');
    }

    emit(LocationSharingLoaded(items: items));

    // Fetch active share counts for each item
    for (int i = 0; i < items.length; i++) {
      fetchActiveShareCount(items[i]);
    }
  }

  Future<void> fetchActiveShareCount(LocationSharingItem item) async {
    try {
      String queryParams = '?page=1&limit=50';
      if (item.isPhone) {
        queryParams += '&shareType=device';
      } else {
        if (item.imei.isEmpty) return; // Can't fetch without IMEI
        queryParams += '&shareType=ride&imei=${item.imei}';
      }
      final url = '${ApiURL.baseURL}/api/share/live-shares$queryParams';
      final response = await _apiService.getGetApiResponse(url);

      response.fold(
        (failure) {}, // Ignore errors silently to not break UI
        (success) {
          if (success['success'] == true && success['data'] != null) {
            final List<dynamic> data = success['data'];
            final activeCount = data.length;
            
            // Update the state
            if (state is LocationSharingLoaded) {
              final currentStateItems = (state as LocationSharingLoaded).items;
              final updatedItems = currentStateItems.map((existingItem) {
                if (existingItem.id == item.id) {
                  return existingItem.copyWith(
                    activeShareCount: activeCount,
                    isSharing: activeCount > 0,
                  );
                }
                return existingItem;
              }).toList();
              
              emit(LocationSharingLoaded(items: updatedItems));
            }
          }
        },
      );
    } catch (e) {
      debugPrint('Error fetching live shares for ${item.name}: $e');
    }
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

  Future<void> shareLiveLocation(
    BuildContext context,
    String id,
    int duration,
  ) async {
    if (state is! LocationSharingLoaded) return;

    final items = (state as LocationSharingLoaded).items;
    final itemIndex = items.indexWhere((e) => e.id == id);
    if (itemIndex == -1) return;

    final item = items[itemIndex];

    try {
      final prefs = AppPreference.instance;
      final userId = await prefs.get(key: AppPreference.KEY_USER_ID);

      // 1. Create Share Link
      final createUrl = '${ApiURL.baseURL}/api/share/create';
      final shareType = item.isPhone ? 'device' : 'ride';

      final Map<String, dynamic> createBody = {
        "shareType": shareType,
        "expiresInHours": duration == -30 ? (30 / 60.0) : (duration == 0 ? 8760 : duration),
        "userId": userId,
      };

      if (shareType == 'ride') {
        if (item.imei.isEmpty) {
          if (context.mounted) {
            showUnlockDeviceDialog(context, "Location Sharing");
          }
          return;
        }
        createBody['imei'] = item.imei;
        createBody['startDate'] = DateTime.now().toUtc().toIso8601String();
        createBody['endDate'] = DateTime.now()
            .toUtc()
            .add(duration == -30 ? const Duration(minutes: 30) : Duration(hours: duration == 0 ? 8760 : duration))
            .toIso8601String();
      } else {
        createBody['imei'] = null;
      }

      final createResult = await _apiService.getPostApiResponse(
        createUrl,
        createBody,
      );

      String webLink = '';
      String? errorMessage;

      createResult.fold(
        (failure) {
          debugPrint('Error creating share link: ${failure.message}');
          errorMessage = failure.message;
        },
        (success) {
          if (success['success'] == true && success['data'] != null) {
            webLink = success['data']['webLink'] ?? '';
          } else {
            errorMessage =
                success['message']?.toString() ?? (context.mounted ? AppLocalizations.of(context)!.failedToCreateShareLink : 'Failed to create share link');
          }
        },
      );

      if (webLink.isEmpty) {
        if (context.mounted && errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error),
          );
        }
        return;
      }

      // Update UI state so the card shows active sharing optimistically
      final updatedItems = List<LocationSharingItem>.from(items);
      updatedItems[itemIndex] = item.copyWith(isSharing: true, activeShareCount: item.activeShareCount + 1);
      emit(LocationSharingLoaded(items: updatedItems));

      // Refresh the live api count for this item from backend
      fetchActiveShareCount(item);

      // Trigger native share sheet
      await Share.share(webLink);
    } catch (e) {
      debugPrint('Exception in shareLiveLocation: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString()),
              backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    }
  }
}
