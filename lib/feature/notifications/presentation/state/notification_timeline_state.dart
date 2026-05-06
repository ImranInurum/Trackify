import '../../data/models/notification_timeline_model.dart';

abstract class NotificationTimelineState {}

class NotificationTimelineInitial extends NotificationTimelineState {}

class NotificationTimelineLoading extends NotificationTimelineState {}

class NotificationTimelineLoaded extends NotificationTimelineState {
  final List<NotificationTimelineItem> notifications;
  final List<String> selectedCategories;
  final String? selectedTimePeriod;

  NotificationTimelineLoaded({
    required this.notifications,
    this.selectedCategories = const [],
    this.selectedTimePeriod,
  });
}

class NotificationTimelineError extends NotificationTimelineState {
  final String message;
  NotificationTimelineError(this.message);
}
