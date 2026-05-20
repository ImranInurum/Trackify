import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data source/refuel_data_source.dart';
import 'refuel_history_state.dart';
import 'fuel_logs_state.dart';

class RefuelHistoryCubit extends Cubit<RefuelHistoryState> {
  final RefuelDataSource _dataSource;

  /// Stores the current IMEI so we can reload after adding a refuel.
  String _currentImei = '';

  RefuelHistoryCubit(this._dataSource) : super(RefuelHistoryInitial());

  /// Returns the current refuel count from the loaded state.
  int get refuelCount {
    final currentState = state;
    if (currentState is RefuelHistoryLoaded) {
      return currentState.refuelLogs.length;
    }
    return 0;
  }

  Future<void> loadRefuelHistory(String imei) async {
    try {
      _currentImei = imei;
      emit(RefuelHistoryLoading());

      final refuelLogs = await _dataSource.getRefuelLogs(imei);

      // Create a completely new unmodifiable list so that:
      // 1. Equatable detects the change (new list reference + loadedAt).
      // 2. No external code can mutate the emitted list.
      emit(
        RefuelHistoryLoaded(
          refuelLogs: List<RefuelLog>.unmodifiable(refuelLogs),
        ),
      );
    } catch (e) {
      print("REFUEL HISTORY ERROR : $e");
      emit(
        RefuelHistoryError(
          e.toString(),
        ),
      );
    }
  }

  /// Reloads the refuel history using the last known IMEI.
  /// Call this after successfully adding a new refuel entry.
  Future<void> reloadHistory() async {
    if (_currentImei.isNotEmpty) {
      await loadRefuelHistory(_currentImei);
    }
  }
}
