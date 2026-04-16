import 'package:equatable/equatable.dart';
import '../../data/entity/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final NotificationModel notificationModel;

  const NotificationLoaded(this.notificationModel);

  @override
  List<Object?> get props => [notificationModel];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
