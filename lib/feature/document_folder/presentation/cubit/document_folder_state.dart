import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';

abstract class DocumentFolderState {}

class DocumentFolderInitial extends DocumentFolderState {}

class DocumentFolderLoading extends DocumentFolderState {}

class DocumentFolderLoaded extends DocumentFolderState {
  final List<DocumentEntity> documents;

  DocumentFolderLoaded(this.documents);
}

class DocumentFolderError extends DocumentFolderState {
  final String message;

  DocumentFolderError(this.message);
}
