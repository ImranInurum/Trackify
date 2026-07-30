import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'location_sharing_history_state.dart';
import '../../../data/models/share_history_model.dart';
import '../location_sharing_state.dart';

class LocationSharingHistoryCubit extends Cubit<LocationSharingHistoryState> {
  final NetworkApiService _apiService = NetworkApiService();
  final LocationSharingItem locationItem;
  int _currentPage = 1;
  final int _limit = 10;
  bool _isFetching = false;

  LocationSharingHistoryCubit({required this.locationItem})
      : super(LocationSharingHistoryInitial());

  Future<void> fetchHistory({bool isRefresh = false}) async {
    if (_isFetching) return;
    
    if (isRefresh) {
      _currentPage = 1;
      emit(LocationSharingHistoryLoading());
    } else {
      if (state is LocationSharingHistoryLoaded && (state as LocationSharingHistoryLoaded).hasReachedMax) {
        return;
      }
      if (state is! LocationSharingHistoryLoaded) {
        emit(LocationSharingHistoryLoading());
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
      final url = '${ApiURL.baseURL}/api/share/my-shares$queryParams';
      final response = await _apiService.getGetApiResponse(url);

      response.fold(
        (failure) {
          emit(LocationSharingHistoryError(failure.message));
        },
        (success) {
          if (success['success'] == true && success['data'] != null) {
            final List<dynamic> data = success['data'];
            final List<ShareHistoryItem> newItems = data
                .map((json) => ShareHistoryItem.fromJson(json))
                .toList();

            final bool hasReachedMax = data.length < _limit;

            if (state is LocationSharingHistoryLoaded && !isRefresh) {
              final currentState = state as LocationSharingHistoryLoaded;
              emit(LocationSharingHistoryLoaded(
                items: currentState.items + newItems,
                hasReachedMax: hasReachedMax,
              ));
            } else {
              emit(LocationSharingHistoryLoaded(
                items: newItems,
                hasReachedMax: hasReachedMax,
              ));
            }
            _currentPage++;
          } else {
            emit(LocationSharingHistoryError(success['message']?.toString() ?? 'Failed to fetch history'));
          }
        },
      );
    } catch (e) {
      emit(LocationSharingHistoryError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }
}
