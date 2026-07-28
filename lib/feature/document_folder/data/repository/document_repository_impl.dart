import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/document_folder/data/data_sources/document_local_datasources.dart';
import 'package:trackify/feature/document_folder/data/models/document_upload_request.dart';
import 'package:trackify/feature/document_folder/data/models/document_upload_response.dart';
import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';
import 'package:trackify/feature/document_folder/data/models/document_list_response.dart';
import 'package:trackify/feature/document_folder/domain/repository/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentLocalDataSource dataSource;
  static final BaseApiServices _apiServices = NetworkApiService();

  DocumentRepositoryImpl(this.dataSource);

  @override
  Future<List<DocumentEntity>> getDocuments() {
    return dataSource.getAll();
  }

  @override
  ResultFuture<List<DocumentEntity>> getDocumentsByVehicleId(String vehicleId) async {
    try {
      final url = ApiURL.getDocuments;
      final result = await _apiServices.getGetApiResponse(
        url,
        body: {'vehicleId': vehicleId},
      );
      
      return result.fold(
        (failure) => Left(failure),
        (data) {
          try {
            final response = DocumentListResponse.fromJson(data);
            return Right(response.documents);
          } catch (e) {
            return Right(<DocumentEntity>[]);
          }
        },
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException('Unexpected repository error: $e'));
    }
  }

  @override
  Future<String?> pickFile(PickerType type) {
    return dataSource.pickFile(type);
  }

  @override
  Future<void> saveDocument(DocumentEntity doc) {
    return dataSource.save(doc);
  }

  @override
  ResultFuture<DocumentUploadResponse> uploadDocument({
    required DocumentUploadRequest request,
    List<int>? frontImageBytes,
    String? frontImageName,
    List<int>? backImageBytes,
    String? backImageName,
  }) async {
    try {
      final url = ApiURL.uploadDocument;
      final fields = request.toFields();

      final files = <Map<String, dynamic>>[];

      if (frontImageBytes != null && frontImageName != null && frontImageBytes.isNotEmpty) {
        files.add({
          'key': 'frontImage',
          'bytes': frontImageBytes,
          'name': frontImageName,
        });
      }

      if (backImageBytes != null && backImageName != null && backImageBytes.isNotEmpty) {
        files.add({
          'key': 'backImage',
          'bytes': backImageBytes,
          'name': backImageName,
        });
      }

      final result = await _apiServices.postUploadMultipleFilesApiResponse(
        url: url,
        fields: fields,
        files: files,
        method: 'POST',
      );

      return result.fold(
        (failure) => Left(failure),
        (data) => Right(DocumentUploadResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException('Unexpected repository error: $e'));
    }
  }

  @override
  ResultFuture<DocumentUploadResponse> updateDocument({
    required String documentId,
    required DocumentUploadRequest request,
    List<int>? frontImageBytes,
    String? frontImageName,
    List<int>? backImageBytes,
    String? backImageName,
  }) async {
    try {
      final url = ApiURL.updateDocument(documentId);
      final fields = request.toFields();

      final files = <Map<String, dynamic>>[];

      if (frontImageBytes != null && frontImageName != null && frontImageBytes.isNotEmpty) {
        files.add({
          'key': 'frontImage',
          'bytes': frontImageBytes,
          'name': frontImageName,
        });
      }

      if (backImageBytes != null && backImageName != null && backImageBytes.isNotEmpty) {
        files.add({
          'key': 'backImage',
          'bytes': backImageBytes,
          'name': backImageName,
        });
      }

      final result = await _apiServices.postUploadMultipleFilesApiResponse(
        url: url,
        fields: fields,
        files: files,
        method: 'PUT',
      );

      return result.fold(
        (failure) => Left(failure),
        (data) => Right(DocumentUploadResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException('Unexpected repository error: $e'));
    }
  }

  @override
  ResultFuture<dynamic> deleteDocument(String documentId) async {
    try {
      final url = ApiURL.deleteDocument(documentId);
      final result = await _apiServices.getDeleteApiResponse(url, {});
      return result;
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException('Unexpected repository error: $e'));
    }
  }
}