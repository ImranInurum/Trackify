import 'package:trackify/core/utils/typedefs.dart';

abstract class BaseApiServices {
  ResultFuture<dynamic> getGetApiResponse(String url, {Map<String, dynamic>? body});
  ResultFuture<dynamic> getPostApiResponse(String url, Map<String, dynamic> body);
  ResultFuture<dynamic> patchApiResponse(String url, Map<String, dynamic> body);
  ResultFuture<dynamic> getPutApiResponse(String url, Map<String, dynamic> body);
  ResultFuture<dynamic> getDeleteApiResponse(String url, Map<String, dynamic> body);
  ResultFuture<dynamic> getPostDownloadZip(String url, Map<String, dynamic> body);
  ResultFuture<dynamic> getPostUploadMultiPartApiResponse(
    String url,
    Map<String, String> fields,
    dynamic fileBytes,
    String fileName,
    String fileKey,
    String method,
  );
  ResultFuture<dynamic> postUploadMultipleFilesApiResponse({
    required String url,
    required Map<String, String> fields,
    required List<Map<String, dynamic>> files,
    required String method,
  });
  ResultFuture<dynamic> deleteResponse(String url, Map<String, dynamic> body);
  ResultFuture<dynamic> pathResponse(String url, Map<String, dynamic> body);
}
