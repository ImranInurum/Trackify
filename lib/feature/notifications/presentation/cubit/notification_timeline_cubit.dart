import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/notification_timeline_state.dart';
import '../../data/models/notification_timeline_model.dart';

class NotificationTimelineCubit extends Cubit<NotificationTimelineState> {
  NotificationTimelineCubit() : super(NotificationTimelineInitial());

  final List<NotificationTimelineItem> _allNotifications = [
    // 6 May Wed
    NotificationTimelineItem(
      id: "1",
      title: "12:57:16 PM",
      description: "Motion sensed",
      time: "12:57:16 PM, 6 May Wed",
      category: "Motion sensed",
    ),
    NotificationTimelineItem(
      id: "2",
      title: "11:30:05 AM",
      description: "Vehicle switched on",
      time: "11:30:05 AM, 6 May Wed",
      category: "Vehicle switched on",
    ),
    NotificationTimelineItem(
      id: "3",
      title: "10:15:20 AM",
      description: "Accident detected",
      time: "10:15:20 AM, 6 May Wed",
      category: "Accident detected",
    ),
    NotificationTimelineItem(
      id: "3-1",
      title: "09:15:20 AM",
      description: "Ignition on",
      time: "09:15:20 AM, 6 May Wed",
      category: "Ignition on",
    ),
    NotificationTimelineItem(
      id: "3-2",
      title: "08:15:20 AM",
      description: "Power supply on",
      time: "08:15:20 AM, 6 May Wed",
      category: "Power supply on",
    ),
    NotificationTimelineItem(
      id: "2",
      title: "11:30:05 AM",
      description: "Vehicle switched on",
      time: "11:30:05 AM, 6 May Wed",
      category: "Vehicle switched on",
    ),
    NotificationTimelineItem(
      id: "3",
      title: "10:15:20 AM",
      description: "Accident detected",
      time: "10:15:20 AM, 6 May Wed",
      category: "Accident detected",
    ),
    NotificationTimelineItem(
      id: "3-1",
      title: "09:15:20 AM",
      description: "Ignition on",
      time: "09:15:20 AM, 6 May Wed",
      category: "Ignition on",
    ),
    NotificationTimelineItem(
      id: "3-2",
      title: "08:15:20 AM",
      description: "Power supply on",
      time: "08:15:20 AM, 6 May Wed",
      category: "Power supply on",
    ),
    // 5 May Tue
    NotificationTimelineItem(
      id: "4",
      title: "09:19:24 PM",
      description: "Vibration sensed",
      time: "09:19:24 PM, 5 May Tue",
      category: "Vibration sensed",
    ),
    NotificationTimelineItem(
      id: "5",
      title: "08:45:00 PM",
      description: "Vehicle switched off",
      time: "08:45:00 PM, 5 May Tue",
      category: "Vehicle switched off",
    ),
    NotificationTimelineItem(
      id: "6",
      title: "07:30:00 PM",
      description: "Motion sensed",
      time: "07:30:00 PM, 5 May Tue",
      category: "Motion sensed",
    ),
    NotificationTimelineItem(
      id: "7",
      title: "06:15:00 PM",
      description: "Ignition off",
      time: "06:15:00 PM, 5 May Tue",
      category: "Ignition off",
    ),
    NotificationTimelineItem(
      id: "4",
      title: "09:19:24 PM",
      description: "Vibration sensed",
      time: "09:19:24 PM, 5 May Tue",
      category: "Vibration sensed",
    ),
    NotificationTimelineItem(
      id: "5",
      title: "08:45:00 PM",
      description: "Vehicle switched off",
      time: "08:45:00 PM, 5 May Tue",
      category: "Vehicle switched off",
    ),
    NotificationTimelineItem(
      id: "6",
      title: "07:30:00 PM",
      description: "Motion sensed",
      time: "07:30:00 PM, 5 May Tue",
      category: "Motion sensed",
    ),
    NotificationTimelineItem(
      id: "7",
      title: "06:15:00 PM",
      description: "Ignition off",
      time: "06:15:00 PM, 5 May Tue",
      category: "Ignition off",
    ),
    // 4 May Mon
    NotificationTimelineItem(
      id: "8",
      title: "11:00:00 AM",
      description: "Stationary fall detected",
      time: "11:00:00 AM, 4 May Mon",
      category: "Stationary fall detected",
    ),
    NotificationTimelineItem(
      id: "9",
      title: "10:00:00 AM",
      description: "Vehicle switched on",
      time: "10:00:00 AM, 4 May Mon",
      category: "Vehicle switched on",
    ),
    NotificationTimelineItem(
      id: "10",
      title: "09:00:00 AM",
      description: "Power supply on",
      time: "09:00:00 AM, 4 May Mon",
      category: "Power supply on",
    ),
  ];

  void fetchTimeline() {
    emit(NotificationTimelineLoading());
    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(NotificationTimelineLoaded(notifications: _allNotifications));
    });
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
