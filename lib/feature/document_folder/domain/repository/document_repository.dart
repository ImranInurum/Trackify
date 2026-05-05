import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';

/// Picker source type — used by PickFileUseCase and the UI bottom sheet.
enum PickerType { camera, gallery, pdf }

abstract class DocumentRepository {
  Future<String?> pickFile(PickerType type);
  Future<void> saveDocument(DocumentEntity doc);
  Future<List<DocumentEntity>> getDocuments();
}