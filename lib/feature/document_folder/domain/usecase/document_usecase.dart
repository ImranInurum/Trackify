import 'package:trackify/feature/document_folder/domain/repository/document_repository.dart';

import '../entities/doucment_entity.dart';

class PickFileUseCase{
  final DocumentRepository repository;

  PickFileUseCase(this.repository);

  Future<String?>call(PickerType type){
    return repository.pickFile(type);
  }

}

class SaveDocumentUseCase {
  final DocumentRepository repo;
  SaveDocumentUseCase(this.repo);

  Future<void> call(DocumentEntity doc) {
    return repo.saveDocument(doc);
  }
}

class GetDocumentsUseCase {
  final DocumentRepository repo;
  GetDocumentsUseCase(this.repo);

  Future<List<DocumentEntity>> call() {
    return repo.getDocuments();
  }
}