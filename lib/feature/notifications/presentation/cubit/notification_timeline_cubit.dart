import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../state/notification_timeline_state.dart';
import '../../data/models/notification_timeline_model.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../domain/repository/notification_repository.dart';

class NotificationTimelineCubit extends Cubit<NotificationTimelineState> {
  final NotificationRepository _repository;

  NotificationTimelineCubit(this._repository) : super(NotificationTimelineInitial());

  List<NotificationTimelineItem> _allNotifications = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;

  Future<void> fetchTimeline({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || _currentPage >= _totalPages) return;
      _isLoadingMore = true;
      _currentPage++;
    } else {
      emit(NotificationTimelineLoading());
      _currentPage = 1;
      _allNotifications.clear();
    }
    
    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);
    
    if (userId.isEmpty) {
      emit(NotificationTimelineLoaded(notifications: []));
      return;
    }

    final result = await _repository.getNotifications(userId, page: _currentPage, limit: 20);
    
    result.fold(
      (error) {
        if (!loadMore) emit(NotificationTimelineLoaded(notifications: []));
        _isLoadingMore = false;
      },
      (data) {
        _totalPages = data.totalPages ?? 1;
        final notifications = data.data ?? [];
        
        final newItems = notifications.map((n) {
          String formattedTime = '';
          if (n.createdAt != null && n.createdAt!.isNotEmpty) {
            try {
              final dateTime = DateTime.parse(n.createdAt!).toLocal();
              // Formats as "12:57:16 PM, 6 May Wed"
              formattedTime = DateFormat('h:mm:ss a, d MMM EEE').format(dateTime);
            } catch (e) {
              formattedTime = n.createdAt!;
            }
          }
          
          String desc = n.description ?? '';
          if (desc.contains('\n')) {
            desc = desc.split('\n').first;
          }
          
          return NotificationTimelineItem(
            id: n.id ?? '',
            title: formattedTime.isNotEmpty ? formattedTime.split(', ').first : (n.title ?? 'Notification'),
            description: n.title ?? desc,
            time: formattedTime,
            category: _deriveCategory(n.title ?? ''),
          );
        }).toList();
        
        _allNotifications.addAll(newItems);
        _isLoadingMore = false;
        emit(NotificationTimelineLoaded(notifications: List.from(_allNotifications)));
      },
    );
  }

  String _deriveCategory(String title) {
    title = title.toLowerCase();
    if (title.contains('motion')) return 'Alerts';
    if (title.contains('ignition')) return 'Vehicle Info';
    if (title.contains('speed')) return 'Alerts';
    if (title.contains('geo')) return 'Geofence';
    if (title.contains('service')) return 'Maintenance';
    return 'General';
  }

  void applyFilters({List<String>? categories, String? timePeriod}) {
    emit(NotificationTimelineLoading());

    Future.delayed(const Duration(milliseconds: 300), () {
      List<NotificationTimelineItem> filtered = _allNotifications;

      if (categories != null && categories.isNotEmpty) {
        filtered = filtered
            .where((item) => categories.contains(item.category))
            .toList();
      }

      // Note: timePeriod filtering would be implemented here in a real app

      emit(
        NotificationTimelineLoaded(
          notifications: filtered,
          selectedCategories: categories ?? [],
          selectedTimePeriod: timePeriod,
        ),
      );
    });
  }
}


