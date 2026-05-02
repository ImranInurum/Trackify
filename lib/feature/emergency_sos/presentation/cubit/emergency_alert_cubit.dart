import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/emergency_alert_usecase.dart';
import 'emergency_alert_state.dart';

class EmergencyAlertCubit extends Cubit<EmergencyAlertState> {

  final EmergencyAlertUsecase usecase;

  Timer? timer;
  int seconds = 10;

  EmergencyAlertCubit(this.usecase)
      : super(EmergencyAlertIntial());

  void startTimer() {
    emit(EmergencyTimerTick(seconds));

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (seconds > 0) {
          seconds--;

          emit(
            EmergencyTimerTick(seconds),
          );

          if (seconds == 0) {
            timer.cancel();
            sendAlert();
          }
        } else {
          timer.cancel();
        }
      },
    );
  }

  Future<void> sendAlert() async {
    emit(EmergencySending());

    try {
      final result = await usecase();

      emit(
        EmergencySent(
          result.message,
        ),
      );
    } catch (e) {
      emit(
        EmergencyError(
          e.toString(),
        ),
      );
    }
  }

  void cancelAlert() {
    timer?.cancel();
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}