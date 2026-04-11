import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/core/widgets/loading_screen_ol.dart';

import 'base_api_service.dart';
import 'exceptions.dart';

class NetworkApiService implements BaseApiServices {
  static const Duration _timeout = Duration(seconds: 60);

  /// Builds standardized headers for API requests.
  Map<String, String> _buildHeaders({
    String? overrideToken,
    String lang = 'en',
    bool isMultipart = false,
  }) {
    final tokenToUse = overrideToken ?? ApiURL.authToken;
    final headers = <String, String>{};
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json; charset=UTF-8';
    }
    if (tokenToUse.isNotEmpty) {
      headers['Authorization'] = 'Bearer $tokenToUse';
    }
    if (lang.isNotEmpty) {
      headers['Accept-Language'] = lang;
    }
    return headers;
  }

  Map<String, dynamic> _normalizeBody(dynamic raw) {
    if (raw == null) return <String, dynamic>{};

    if (raw is Map<String, dynamic>) return raw;

    if (raw is Map) {
      return raw.map((key, value) => MapEntry(key.toString(), value));
    }

    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) {
          return decoded.map((key, value) => MapEntry(key.toString(), value));
        }
      } catch (_) {}
    }

    return <String, dynamic>{};
  }

  String _extractToken(Map<String, dynamic> body) => body['auth']?.toString() ?? '';

  String _extractLang(Map<String, dynamic> body) => body['lang']?.toString() ?? 'en';

  /// A wrapper for safe API calls with centralized error handling and loading indicators.
  Future<Either<AppException, T>> _safeRequest<T>({
    required Future<http.Response> Function() request,
    required String method,
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    bool showLoader = false,
  }) async {
    try {
      if (showLoader) LoadingScreenOL().show();

      if (kDebugMode) {
        printCurlRequest(
          url: url,
          method: method,
          headers: headers,
          queryParams: queryParams,
          body: body,
        );
      }

      final response = await request().timeout(_timeout);
      return _parseHttpResponse<T>(response);
    } on SocketException {
      return const Left(NoInternetException('Check your internet connection.'));
    } on TimeoutException {
      return const Left(
        RequestTimeoutException('The request timed out. Please try again.'),
      );
    } on FormatException {
      return const Left(FetchDataException('Invalid response format from server.'));
    } catch (e) {
      return Left(FetchDataException('Unexpected connection error: $e'));
    } finally {
      if (showLoader) LoadingScreenOL().hide();
    }
  }

  /// Handles the HTTP response and maps it to appropriate [AppException] or success data.
  Either<AppException, T> _parseHttpResponse<T>(http.Response response) {
    return _parseBodyStatusResponse<T>(response, response.body);
  }

  /// Handles the Dio response and maps it to appropriate [AppException] or success data.
  // Either<AppException, T> _parseDioResponse<T>(dio.Response response) {
  //   return _parseBodyStatusResponse<T>(response, response.body);
  // }

  Either<AppException, T> _parseBodyStatusResponse<T>(
    dynamic response,
    dynamic responseBody,
  ) {
    final statusCode = response.statusCode;
    final body = _normalizeBody(responseBody);
    if (kDebugMode) {
      debugPrint("statusCode: $statusCode responseData:$body");
    }

    switch (statusCode) {
      case 200:
      case 201:
      case 204:
        return Right(body as T);
      case 400:
        return Left(
          BadRequestException(_readMessage(body, fallback: "Bad request"), 400),
        );
      case 401:
        return Left(
          UnauthorisedException(_readMessage(body, fallback: "Unauthorized"), 401),
        );
      case 403:
        return Left(ForbiddenException(_readMessage(body, fallback: "Forbidden"), 403));
      case 404:
        return Left(NotFoundException(_readMessage(body, fallback: "Not found"), 404));
      case 500:
        return Left(
          InternalServerException(
            _readMessage(body, fallback: "Server error. Please try again."),
            500,
          ),
        );
      case 502:
        return Left(
          InternalServerException(
            _readMessage(body, fallback: "Service temporarily unstable."),
            502,
          ),
        );
      case 503:
        return Left(
          InternalServerException(
            _readMessage(body, fallback: "Service unavailable. Try later."),
            503,
          ),
        );
      default:
        return Left(
          FetchDataException(_readMessage(body, fallback: "Unexpected server error")),
        );
    }
  }

  String _readMessage(
    Map<String, dynamic> body, {
    String fallback = 'Something went wrong',
  }) {
    final dynamic raw = body['message'];
    if (raw is String && raw.trim().isNotEmpty) return raw;
    return fallback;
  }

  @override
  ResultFuture<dynamic> getGetApiResponse(String url) {
    final headers = _buildHeaders();
    return _safeRequest(
      request: () => http.get(Uri.parse(url), headers: headers),
      method: 'GET',
      url: url,
      headers: headers,
    );
  }

  @override
  ResultFuture<dynamic> getPostApiResponse(String url, Map<String, dynamic> body) {
    final headers = _buildHeaders();
    final requestBody = _normalizeBody(body);

    return _safeRequest(
      request: () =>
          http.post(Uri.parse(url), headers: headers, body: jsonEncode(requestBody)),
      method: 'POST',
      url: url,
      headers: headers,
      body: requestBody,
    );
  }

  @override
  ResultFuture<dynamic> getPutApiResponse(String url, Map<String, dynamic> body) {
    final headers = _buildHeaders();
    final requestBody = _normalizeBody(body);

    return _safeRequest(
      request: () =>
          http.put(Uri.parse(url), headers: headers, body: jsonEncode(requestBody)),
      method: 'PUT',
      url: url,
      headers: headers,
      body: requestBody,
    );
  }

  @override
  ResultFuture<dynamic> patchApiResponse(String url, Map<String, dynamic> body) {
    final headers = _buildHeaders();
    final requestBody = _normalizeBody(body);

    return _safeRequest(
      request: () =>
          http.patch(Uri.parse(url), headers: headers, body: jsonEncode(requestBody)),
      method: 'PATCH',
      url: url,
      headers: headers,
      body: requestBody,
    );
  }

  @override
  ResultFuture<dynamic> pathResponse(String url, Map<String, dynamic> body) {
    return patchApiResponse(url, body);
  }

  @override
  ResultFuture<dynamic> deleteResponse(String url, Map<String, dynamic> body) {
    return getDeleteApiResponse(url, body);
  }

  @override
  ResultFuture<dynamic> getDeleteApiResponse(String url, Map<String, dynamic> body) {
    final headers = _buildHeaders();
    final requestBody = _normalizeBody(body);

    return _safeRequest(
      request: () =>
          http.delete(Uri.parse(url), headers: headers, body: jsonEncode(requestBody)),
      method: 'DELETE',
      url: url,
      headers: headers,
      body: requestBody,
    );
  }

  @override
  ResultFuture<dynamic> getPostDownloadZip(String url, Map<String, dynamic> body) {
    return getPostApiResponse(url, body);
  }

  @override
  ResultFuture<dynamic> getPostUploadMultiPartApiResponse(
    String url,
    Map<String, String> fields,
    dynamic fileBytes,
    String fileName,
    String fileKey,
    String method,
  ) async {
    try {
      final request = http.MultipartRequest(
        method.toUpperCase().isEmpty ? 'POST' : method.toUpperCase(),
        Uri.parse(url),
      );

      request.fields.addAll(fields);

      if (fileBytes != null && fileBytes.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            fileKey,
            fileBytes,
            filename: fileName.isEmpty ? 'upload_file' : fileName,
            contentType: getContentType(fileName.isEmpty ? 'file.bin' : fileName),
          ),
        );
      }

      final headers = _buildHeaders(isMultipart: true);
      request.headers.addAll(headers);

      if (kDebugMode) {
        _printMultipartCurl(
          url: url,
          method: method,
          headers: headers,
          fields: fields,
          fileKey: fileKey,
          fileName: fileName,
        );
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _parseHttpResponse(response);
    } on SocketException {
      return const Left(NoInternetException('Check your connection.'));
    } on TimeoutException {
      return const Left(RequestTimeoutException('Upload timed out.'));
    } catch (e) {
      return Left(FetchDataException('Multipart Error: $e'));
    }
  }

  /// Helper to read file bytes from a local path.
  Future<List<int>> getFileBytes(String filePath) async {
    final file = File(filePath);
    return file.readAsBytes();
  }

  /// Maps file extensions to the correct MediaType for multipart uploads.
  MediaType getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'mp4':
        return MediaType('video', 'mp4');
      case 'webm':
        return MediaType('video', 'webm');
      case 'avi':
        return MediaType('video', 'avi');
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'doc':
      case 'docx':
        return MediaType('application', 'msword');
      default:
        throw Exception('Unsupported file type: $extension');
    }
  }

  /// Prints a debug-friendly cURL command for the request.
  void printCurlRequest({
    required String url,
    required String method,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    dynamic body,
  }) {
    if (queryParams != null && queryParams.isNotEmpty) {
      url += '?${Uri(queryParameters: queryParams).query}';
    }

    String curlCommand = "curl -X $method '$url'";

    headers?.forEach((key, value) {
      curlCommand += " -H '$key: $value'";
    });

    if (body != null) {
      final bodyString = body is String ? body : jsonEncode(body);
      curlCommand += " -d '$bodyString'";
    }
    debugPrint('cURL Command:\n$curlCommand\n');
  }

  static void _printMultipartCurl({
    required String url,
    required String method,
    Map<String, String>? headers,
    required Map<String, String> fields,
    String? fileKey,
    String? fileName,
  }) {
    var curl = "curl --location -X $method '$url'";

    headers?.forEach((k, v) {
      curl += " -H '$k: $v'";
    });

    fields.forEach((k, v) {
      curl += " --form '$k=\"$v\"'";
    });

    if (fileKey != null && fileName != null) {
      curl += " --form '$fileKey=@\"$fileName\"'";
    }

    print("Multipart cURL:\n$curl\n");
  }
}
