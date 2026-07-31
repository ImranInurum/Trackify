import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data source/refuel_data_source.dart';
import 'refuel_history_state.dart';
import 'fuel_logs_state.dart';

class RefuelHistoryCubit extends Cubit<RefuelHistoryState> {
  final RefuelDataSource _dataSource;

  /// Stores the current vehicleId so we can reload after adding a refuel.
  String _currentVehicleId = '';

  RefuelHistoryCubit(this._dataSource) : super(RefuelHistoryInitial());

  /// Returns the current refuel count from the loaded state.
  int get refuelCount {
    final currentState = state;
    if (currentState is RefuelHistoryLoaded) {
      return currentState.refuelLogs.length;
    }
    return 0;
  }

  Future<void> loadRefuelHistory(String vehicleId) async {
    try {
      _currentVehicleId = vehicleId;
      emit(RefuelHistoryLoading());

      final refuelLogs = await _dataSource.getRefuelLogs(vehicleId);

      // Create a completely new unmodifiable list so that:
      // 1. Equatable detects the change (new list reference + loadedAt).
      // 2. No external code can mutate the emitted list.
      if (isClosed) return;
      emit(
        RefuelHistoryLoaded(
          refuelLogs: List<RefuelLog>.unmodifiable(refuelLogs),
        ),
      );
    } catch (e) {
      print("REFUEL HISTORY ERROR : $e");
      if (isClosed) return;
      emit(
        RefuelHistoryError(
          e.toString(),
        ),
      );
    }
  }

  /// Reloads the refuel history using the last known vehicleId.
  /// Call this after successfully adding a new refuel entry.
  Future<void> reloadHistory() async {
    if (_currentVehicleId.isNotEmpty) {
      await loadRefuelHistory(_currentVehicleId);
    }
  }

  Future<void> deleteRefuelLog(String refuelId) async {
    try {
      await _dataSource.deleteRefuelLog(_currentVehicleId, refuelId);
      await reloadHistory();
    } catch (e) {
      print("DELETE REFUEL ERROR : $e");
    }
  }
}
