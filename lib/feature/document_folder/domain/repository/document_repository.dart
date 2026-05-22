import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/document_folder/data/models/document_upload_request.dart';
import 'package:trackify/feature/document_folder/data/models/document_upload_response.dart';
import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';

/// Picker source type — used by PickFileUseCase and the UI bottom sheet.
enum PickerType { camera, gallery, pdf }

abstract class DocumentRepository {
  Future<String?> pickFile(PickerType type);
  Future<void> saveDocument(DocumentEntity doc);
  Future<List<DocumentEntity>> getDocuments();

  ResultFuture<DocumentUploadResponse> uploadDocument({
    required DocumentUploadRequest request,
    required List<int> frontImageBytes,
    required String frontImageName,
    List<int>? backImageBytes,
    String? backImageName,
  });
}