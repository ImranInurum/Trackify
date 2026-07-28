import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';

class DocumentListResponse {
  final bool success;
  final String? message;
  final List<DocumentEntity> documents;

  DocumentListResponse({
    required this.success,
    this.message,
    required this.documents,
  });

  factory DocumentListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<DocumentEntity> docs = [];
    if (list != null) {
      docs = list.map((i) => DocumentEntity.fromJson(i)).toList();
    }
    return DocumentListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      documents: docs,
    );
  }
}
