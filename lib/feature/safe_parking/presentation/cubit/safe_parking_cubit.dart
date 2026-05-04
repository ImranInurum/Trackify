import 'package:flutter_bloc/flutter_bloc.dart';
import 'safe_parking_state.dart';

class SafeParkingCubit extends Cubit<SafeParkingState> {
  SafeParkingCubit() : super(const SafeParkingState());

  void toggle() {
    emit(state.copyWith(isActivated: !state.isActivated));
  }
}
