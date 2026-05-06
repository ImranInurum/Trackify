import 'package:bloc/bloc.dart';

import '../services/picker_service.dart';
import 'document_state.dart';

/// Simple cubit — no UseCase, no Repository, no DI.
/// Picks files directly via [PickerService] and updates state.
class DocumentUploadCubit extends Cubit<DocumentUploadedState> {
  DocumentUploadCubit() : super(const DocumentUploadedState());

  // ── Private pick helper ──────────────────────────────────────────────────

  Future<void> _pick(
    PickSource source,
    DocumentUploadedState Function(String path) buildNextState,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final path = await PickerService.pick(source);
      if (path != null) {
        emit(buildNextState(path));
      } else {
        // User cancelled — just clear the loader
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // ── Public methods — one per document slot ───────────────────────────────

  Future<void> setDL(PickSource source) =>
      _pick(source, (p) => state.copyWith(dl: p, isLoading: false));

  Future<void> setOther(PickSource source) =>
      _pick(source, (p) => state.copyWith(other: p, isLoading: false));

  Future<void> setRC(PickSource source) =>
      _pick(source, (p) => state.copyWith(rc: p, isLoading: false));

  Future<void> setInsurance(PickSource source) =>
      _pick(source, (p) => state.copyWith(insurance: p, isLoading: false));

  Future<void> setPUC(PickSource source) =>
      _pick(source, (p) => state.copyWith(puc: p, isLoading: false));

  Future<void> setBills(PickSource source) =>
      _pick(source, (p) => state.copyWith(bills: p, isLoading: false));
}