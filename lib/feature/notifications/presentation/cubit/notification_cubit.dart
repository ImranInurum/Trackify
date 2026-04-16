import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../domain/repository/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;

  NotificationCubit(this._repository) : super(NotificationInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    
    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);
    
    if (userId.isEmpty) {
      emit(const NotificationError("User ID not found"));
      return;
    }

    final result = await _repository.getNotifications(userId);
    
    result.fold(
      (error) => emit(NotificationError(error.message)),
      (data) => emit(NotificationLoaded(data)),
    );
  }
}
