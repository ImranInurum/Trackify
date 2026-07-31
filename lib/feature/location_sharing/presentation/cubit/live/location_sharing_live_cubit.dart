import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'location_sharing_live_state.dart';
import '../../../data/models/share_history_model.dart';
import '../location_sharing_state.dart';

class LocationSharingLiveCubit extends Cubit<LocationSharingLiveState> {
  final NetworkApiService _apiService = NetworkApiService();
  final LocationSharingItem locationItem;
  int _currentPage = 1;
  final int _limit = 10;
  bool _isFetching = false;

  LocationSharingLiveCubit({required this.locationItem})
      : super(LocationSharingLiveInitial());

  Future<void> fetchLiveShares({bool isRefresh = false}) async {
    if (_isFetching) return;
    
    if (isRefresh) {
      _currentPage = 1;
      emit(LocationSharingLiveLoading());
    } else {
      if (state is LocationSharingLiveLoaded && (state as LocationSharingLiveLoaded).hasReachedMax) {
        return;
      }
      if (state is! LocationSharingLiveLoaded) {
        emit(LocationSharingLiveLoading());
      }
    }

    _isFetching = true;

    try {
      String queryParams = '?page=$_currentPage&limit=$_limit';
      if (locationItem.isPhone) {
        queryParams += '&shareType=device';
      } else {
        queryParams += '&shareType=ride&imei=${locationItem.imei}';
      }
      final url = '${ApiURL.baseURL}/api/share/live-shares$queryParams';
      final response = await _apiService.getGetApiResponse(url);

      response.fold(
        (failure) {
          emit(LocationSharingLiveError(failure.message));
        },
        (success) {
          if (success['success'] == true && success['data'] != null) {
            final List<dynamic> data = success['data'];
            final List<ShareHistoryItem> newItems = data
                .map((json) => ShareHistoryItem.fromJson(json))
                .toList();

            final bool hasReachedMax = data.length < _limit;

            if (state is LocationSharingLiveLoaded && !isRefresh) {
              final currentState = state as LocationSharingLiveLoaded;
              emit(LocationSharingLiveLoaded(
                items: currentState.items + newItems,
                hasReachedMax: hasReachedMax,
              ));
            } else {
              emit(LocationSharingLiveLoaded(
                items: newItems,
                hasReachedMax: hasReachedMax,
              ));
            }
            _currentPage++;
          } else {
            emit(LocationSharingLiveError(success['message']?.toString() ?? 'Failed to fetch live shares'));
          }
        },
      );
    } catch (e) {
      emit(LocationSharingLiveError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> stopSharing(
    String token, {
    void Function()? onSuccess,
    void Function(String)? onError,
  }) async {
    try {
      final url = '${ApiURL.baseURL}/api/share/stop/$token';
      final response = await _apiService.getPostApiResponse(url, {});

      response.fold(
        (failure) {
          if (onError != null) onError(failure.message);
        },
        (success) {
          if (success['success'] == true) {
            // Successfully stopped, re-fetch the list
            fetchLiveShares(isRefresh: true);
            if (onSuccess != null) {
              onSuccess();
            }
          } else {
            if (onError != null) {
              onError(success['message']?.toString() ?? 'Failed to stop sharing');
            }
          }
        },
      );
    } catch (e) {
      if (onError != null) onError(e.toString());
    }
  }
}
