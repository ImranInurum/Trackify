import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../state/notification_timeline_state.dart';
import '../../data/models/notification_timeline_model.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../domain/repository/notification_repository.dart';

class NotificationTimelineCubit extends Cubit<NotificationTimelineState> {
  final NotificationRepository _repository;

  NotificationTimelineCubit(this._repository) : super(NotificationTimelineInitial());

  final List<NotificationTimelineItem> _allNotifications = [];
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
    final t = title.toLowerCase().trim();
    if (t.startsWith('motion')) return 'Motion Sensed';
    if (t.startsWith('ignition off')) return 'Ignition Off';
    if (t.startsWith('ignition on')) return 'Ignition On';
    if (t.startsWith('accident')) return 'Accident Detected';
    if (t.startsWith('stationary fall')) return 'Stationary Fall Detected';
    if (t.startsWith('power supply off')) return 'Power Supply Off';
    if (t.startsWith('power supply on')) return 'Power Supply On';
    if (t.startsWith('vehicle switched off')) return 'Vehicle Switched Off';
    if (t.startsWith('vehicle switched on')) return 'Vehicle Switched On';
    if (t.startsWith('vibration')) return 'Vibration Sensed';
    if (t.contains('ignition')) return 'Ignition On';
    if (t.contains('power supply')) return 'Power Supply On';
    if (t.contains('vehicle switch')) return 'Vehicle Switched On';
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


