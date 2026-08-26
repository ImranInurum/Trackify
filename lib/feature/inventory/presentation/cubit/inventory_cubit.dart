import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/add_inventory_usecase.dart';
import '../../data/models/add_inventory_request.dart';
import 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final AddInventoryUseCase addInventoryUseCase;

  InventoryCubit(this.addInventoryUseCase) : super(InventoryInitial());

  Future<void> addInventory(String imei, String modelNo) async {
    emit(InventoryLoading());
    final request = AddInventoryRequest(imei: imei, modelNo: modelNo);
    final result = await addInventoryUseCase(request);
    result.fold(
      (failure) => emit(InventoryFailure(message: failure.message)),
      (message) => emit(InventorySuccess(message: message)),
    );
  }
}
