import 'package:trackify/feature/document_folder/data/data_sources/document_local_datasources.dart';
import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';
import 'package:trackify/feature/document_folder/domain/repository/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository{

  final DocumentLocalDataSource dataSource;

  DocumentRepositoryImpl(this.dataSource);

  @override
  Future<List<DocumentEntity>> getDocuments() {
    return dataSource.getAll();
  }

  @override
  Future<String?> pickFile(PickerType type) {
    return dataSource.pickFile(type);
  }

  @override
  Future<void> saveDocument(DocumentEntity doc) {
    return dataSource.save(doc);
  }



}