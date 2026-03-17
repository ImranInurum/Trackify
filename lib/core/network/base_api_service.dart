
import '../utils/typedefs.dart';

abstract class BaseApiServices {
  ResultFuture getGetApiResponse(String serviceUrl, Map<String, dynamic> body);
  ResultFuture getPostApiResponse(String serviceUrl, Map<String, dynamic> body);
  ResultFuture patchApiResponse(String serviceUrl, Map<String, dynamic> body);
  ResultFuture getPutApiResponse(String serviceUrl,Map<String,dynamic> body);
  ResultFuture getDeleteApiResponse(
      String serviceUrl, Map<String, dynamic> body);
  ResultFuture getPostDownloadZip(String serviceUrl, Map<String, dynamic> body);
  ResultFuture getPostUploadMultiPartApiResponse(
      String url,
      Map<String, String> dic,
      dynamic fileBytes,
      String fileName,
      String key,
      String token,
      String reqMethod);
  ResultFuture deleteResponse(String serviceUrl, Map<String, dynamic> body);
  ResultFuture pathResponse(String serviceUrl, Map<String, dynamic> body);

}
