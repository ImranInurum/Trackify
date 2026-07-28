import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/document_folder/data/models/document_upload_request.dart';
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

  Future<bool> updateDocument({
    required String documentId,
    required DocumentUploadRequest request,
    List<int>? frontImageBytes,
    String? frontImageName,
    List<int>? backImageBytes,
    String? backImageName,
  }) async {
    final result = await _repository.updateDocument(
      documentId: documentId,
      request: request,
      frontImageBytes: frontImageBytes,
      frontImageName: frontImageName,
      backImageBytes: backImageBytes,
      backImageName: backImageName,
    );
    return result.fold(
      (failure) {
        emit(DocumentFolderError(failure.message));
        return false;
      },
      (response) => true,
    );
  }

  Future<bool> deleteDocument(String documentId) async {
    final result = await _repository.deleteDocument(documentId);
    return result.fold(
      (failure) {
        emit(DocumentFolderError(failure.message));
        return false;
      },
      (data) => true,
    );
  }
}
