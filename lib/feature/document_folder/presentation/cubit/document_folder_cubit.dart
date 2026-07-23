import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/document_folder/domain/repository/document_repository.dart';
import 'document_folder_state.dart';

class DocumentFolderCubit extends Cubit<DocumentFolderState> {
  final DocumentRepository _repository;

  DocumentFolderCubit(this._repository) : super(DocumentFolderInitial());

  Future<void> fetchDocuments(String vehicleId) async {
    emit(DocumentFolderLoading());
    final result = await _repository.getDocumentsByVehicleId(vehicleId);
    
    result.fold(
      (failure) => emit(DocumentFolderError(failure.message)),
      (documents) => emit(DocumentFolderLoaded(documents)),
    );
  }
}
