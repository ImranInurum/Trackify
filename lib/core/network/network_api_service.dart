import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../errors/exceptions.dart';
import '../utils/typedefs.dart';
import '../widgets/loading_screen_ol.dart';
import 'base_api_service.dart';


class NetworkApiService implements BaseApiServices {
  @override
  ResultFuture getGetApiResponse(String url, Map<String, dynamic> body) async {
    if (kDebugMode) {
      print(url);
    }
    final dynamic responseJson;
    try {
      final token = body.containsKey('auth') ? body['auth'] : '';
      final lang = body.containsKey('lang') ? body['lang'] ?? 'en' : 'en';

      final response = await http
          .get(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            if (lang.isNotEmpty) 'Accept-Language': lang,
          })
          .timeout(const Duration(seconds: 60));
      responseJson = _returnResponse(response, false, '', url);
    } on SocketException {
      LoadingScreenOL().hide();
      throw const Left(NoInternetException('NoInternetException [0]'));
    } on TimeoutException {
      LoadingScreenOL().hide();
      throw const Left(FetchDataException('Network Request time out[408]'));
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  ResultFuture getPostApiResponse(String url, Map<String, dynamic> dic) async {
    if (kDebugMode) {
      print('req======================>$url \n\n$dic');
    }
    final token = dic.containsKey('auth') ? dic['auth'] ?? '' : '';
    final lang = dic.containsKey('lang') ? dic['lang'] ?? 'en' : 'en';

    final dynamic responseJson;
    Map<String, dynamic> b = dic;
    try {
      b.remove('auth');
      b.remove('lang');

      final Response response = await http.post(Uri.parse(url), body: jsonEncode(b), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        if (lang.isNotEmpty) 'Accept-Language': lang,
      }).timeout(const Duration(seconds: 60));
      responseJson = _returnResponse(
          response, false, dic.containsKey('sessionToken') ? dic['sessionToken'] : '', url);
    } on SocketException {
      LoadingScreenOL().hide();
     // AppToast.toastMessage('Communication issue.');
      throw const Left(NoInternetException('Communication issue.'));
    } on TimeoutException {
      LoadingScreenOL().hide();
     // AppToast.toastMessage('Network Request time out');
      throw const Left(FetchDataException('Network Request time out'));
    }
    if (kDebugMode) {
      print(responseJson);
      print('responseJson======================>$responseJson');
    }
    LoadingScreenOL().hide();
    return responseJson;
  }

  @override
  ResultFuture getPostUploadMultiPartApiResponse(
      String url,
      Map<String, String> dic,
      dynamic fileBytes,
      String fileName,
      String uploadFileKeyName,
      String token,
      String reqMehod) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responseJson;
    try {
      final request = http.MultipartRequest(reqMehod.isEmpty ? 'POST' : reqMehod, Uri.parse(url));
      if (fileBytes != null && fileBytes.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            uploadFileKeyName, //'bulkShipmentsCsv'
            fileBytes ?? [],
            filename: fileName.isEmpty ? 'bubble_social' : fileName,
          ),
        );
      }
      if (token.isNotEmpty) {
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }

      request.fields.addAll(dic); //{'sessionToken': sessionToken}
      final http.Response response =
      await http.Response.fromStream(await request.send()).timeout(const Duration(seconds: 60));
      responseJson = _returnResponse(response, true, token, url);
    } on SocketException {
      throw const Left(NoInternetException('Communication issue.'));
    } on TimeoutException {
      throw const Left(FetchDataException('Network Request time out'));
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  Either<AppException, T> _returnResponse<T>(
      http.Response response, bool isMultipart, String sessionToken, String url) {
    if (kDebugMode) {
      print(response.statusCode);
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        final body = response.body.trim();
        dynamic responseJson;
        try {
          responseJson = jsonDecode(body);
        }catch(_){
          responseJson = body;
        }
        LoadingScreenOL().hide();
        return Right(responseJson);
      case 400:
        LoadingScreenOL().hide();
        throw Left(BadRequestException(response.body.toString().length < 160
            ? response.body.toString()
            : '${response.reasonPhrase}'));
      case 500:
        LoadingScreenOL().hide();
        throw Left(InternalServerException(response.body.toString().length < 160
            ? response.body.toString()
            : '${response.reasonPhrase}'));
      case 404:
        LoadingScreenOL().hide();
        throw Left(UnauthorisedException(response.body.toString().length < 160
            ? response.body.toString()
            : '${response.reasonPhrase}'));
      default:
        LoadingScreenOL().hide();
        throw const Left(FetchDataException(
            'Error occured while communicating with server')); //// isMultipart ? response.body : jsonDecode(response.body);
    }
  }

  Future<List<int>> getFileBytes(String filePath) async {
    final file = File(filePath);
    return await file.readAsBytes();
  }

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
      default:
        throw Exception('Unsupported file type: $extension');
    }
  }

  @override
  ResultFuture deleteResponse(String url, Map<String, dynamic> dic) async {
    if (kDebugMode) {
      print('req======================>$url \n\n$dic');
    }
    final token = dic.containsKey('auth') ? dic['auth'] : '';
    final dynamic responseJson;
    Map<String, dynamic> b = dic;
    try {
      b.remove('auth');
      final Response response = await http
          .patch(Uri.parse(url),
          body: jsonEncode(b),
          headers: token.isNotEmpty
              ? {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          }
              : {
            'Content-Type': 'application/json; charset=UTF-8',
          })
          .timeout(const Duration(seconds: 60));
      responseJson = _returnResponse(
          response, false, dic.containsKey('sessionToken') ? dic['sessionToken'] : '', url);
    } on SocketException {
      LoadingScreenOL().hide();
      throw const Left(NoInternetException('Communication issue.'));
    } on TimeoutException {
      LoadingScreenOL().hide();
      throw const Left(FetchDataException('Network Request time out'));
    }
    if (kDebugMode) {
      print(responseJson);
      print('responseJson======================>$responseJson');
    }
    return responseJson;
  }

  @override
  ResultFuture getDeleteApiResponse(String url, Map<String, dynamic> dic) async {
    if (kDebugMode) {
      print('req======================>$url \n\n$dic');
    }
    final token = dic.containsKey('auth') ? dic['auth'] : '';
    final dynamic responseJson;
    Map<String, dynamic> b = dic;
    try {
      b.remove('auth');
      final Response response = await http
          .delete(Uri.parse(url),
          body: jsonEncode(b),
          headers: token.isNotEmpty
              ? {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          }
              : {
            'Content-Type': 'application/json; charset=UTF-8',
          })
          .timeout(const Duration(seconds: 60));
      responseJson = _returnResponse(
          response, false, dic.containsKey('sessionToken') ? dic['sessionToken'] : '', url);
    } on SocketException {
      LoadingScreenOL().hide();
      throw const Left(NoInternetException('Communication issue.'));
    } on TimeoutException {
      LoadingScreenOL().hide();
      throw const Left(FetchDataException('Network Request time out'));
    }
    if (kDebugMode) {
      print(responseJson);
      print('responseJson======================>$responseJson');
    }
    return responseJson;
  }

  @override
  ResultFuture pathResponse(String url, Map<String, dynamic> dic) async {
    if (kDebugMode) {
      print('req======================>$url \n\n$dic');
    }
    final token = dic.containsKey('auth') ? dic['auth'] : '';
    final dynamic responseJson;
    Map<String, dynamic> b = dic;
    try {
      b.remove('auth');
      final Response response = await http
          .patch(Uri.parse(url),
          body: jsonEncode(b /*.remove('auth')*/),
          headers: token.isNotEmpty
              ? {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          }
              : {
            'Content-Type': 'application/json; charset=UTF-8',
          })
          .timeout(const Duration(seconds: 60));
      responseJson = _returnResponse(
          response, false, dic.containsKey('sessionToken') ? dic['sessionToken'] : '', url);
    } on SocketException {
      LoadingScreenOL().hide();
      throw const Left(NoInternetException('Communication issue.'));
    } on TimeoutException {
      LoadingScreenOL().hide();
      throw const Left(FetchDataException('Network Request time out'));
    }
    if (kDebugMode) {
      print(responseJson);
      print('responseJson======================>$responseJson');
    }
    return responseJson;
  }

  @override
  ResultFuture getPostDownloadZip(String url, Map<String, dynamic> dic) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responseJson;
    try {
      Response response = await http.post(Uri.parse(url), body: jsonEncode(dic), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      }).timeout(const Duration(seconds: 60));

      responseJson = _returnResponse(
          response, true, dic.containsKey('sessionToken') ? dic['sessionToken'] : '', url);
      // final request = http.MultipartRequest('POST', Uri.parse(url));
      // if (fileBytes != null && fileBytes.isNotEmpty) {
      //   request.files.add(
      //     await http.MultipartFile.fromBytes(
      //       uploadFileKeyName,//'bulkShipmentsCsv'
      //       fileBytes ?? [],
      //       filename: fileName.isEmpty ? 'bulkShipmentsCsv' : fileName,
      //     ),
      //   );
      // }
      // request.fields.addAll(dic);//{'sessionToken': sessionToken}
      // final http.Response response =
      //     await http.Response.fromStream(await request.send())
      //         .timeout(const Duration(seconds: 60));//9524637364//9019623429
      // responseJson = returnResponse(response,true);
    } on SocketException {
      throw const Left(NoInternetException('Communication issue.'));
    } on TimeoutException {
      throw const Left(FetchDataException('Network Request time out'));
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  ResultFuture patchApiResponse(String url, Map<String, dynamic> dic) async {
    if (kDebugMode) {
      print('req======================>$url \n\n$dic');
    }
    final token = dic.containsKey('auth') ? dic['auth'] ?? '' : '';
    final dynamic responseJson;
    Map<String, dynamic> b = dic;
    try {
      b.remove('auth');
      final Response response = await http
          .patch(Uri.parse(url),
          body: jsonEncode(b),
          headers: token.isNotEmpty
              ? {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          }
              : {
            'Content-Type': 'application/json; charset=UTF-8',
          })
          .timeout(const Duration(seconds: 60));
      responseJson = _returnResponse(
          response, false, dic.containsKey('sessionToken') ? dic['sessionToken'] : '', url);
    } on SocketException {
      LoadingScreenOL().hide();
      //AppToast.toastMessage('Communication issue.');
      throw const Left(NoInternetException('Communication issue.'));
    } on TimeoutException {
      LoadingScreenOL().hide();
     // AppToast.toastMessage('Network Request time out');
      throw const Left(FetchDataException('Network Request time out'));
    }
    if (kDebugMode) {
      print(responseJson);
      print('responseJson======================>$responseJson');
    }
    LoadingScreenOL().hide();
    return responseJson;
  }

  @override
  ResultFuture getPutApiResponse(String url, Map<String, dynamic> dic) async {
    if (kDebugMode) {
      print('req======================>$url \n\n$dic');
    }
    final token = dic.containsKey('auth') ? dic['auth'] ?? '' : '';
    final dynamic responseJson;
    Map<String, dynamic> b = dic;
    try {
      b.remove('auth');
      final Response response = await http
          .put(Uri.parse(url),
          body: jsonEncode(b),
          headers: token.isNotEmpty
              ? {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          }
              : {
            'Content-Type': 'application/json; charset=UTF-8',
          })
          .timeout(const Duration(seconds: 60));
      print("Responsee : ${response.body}");
      responseJson = _returnResponse(
          response, false, dic.containsKey('sessionToken') ? dic['sessionToken'] : '', url);
    } on SocketException {
      LoadingScreenOL().hide();
      //AppToast.toastMessage('Communication issue.');
      throw const Left(NoInternetException('Communication issue.'));
    } on TimeoutException {
      LoadingScreenOL().hide();
     // AppToast.toastMessage('Network Request time out');
      throw const Left(FetchDataException('Network Request time out'));
    }
    if (kDebugMode) {
      print(responseJson);
      print('responseJson======================>$responseJson');
    }
    LoadingScreenOL().hide();
    print("RESPONSE JSON : $responseJson");
    return responseJson;
  }
}
