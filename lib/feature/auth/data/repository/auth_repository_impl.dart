import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/auth/domain/repository/auth_repository.dart';

import '../../../../core/config/network/exceptions.dart';
import '../entity/login_response_model.dart';
import '../entity/register_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<LoginResponseModel> loginWithEmailPassword(
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.login, body);
      return res.fold(
        (error) => Left(error),
        (data) => Right(LoginResponseModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<RegisterUserModel> sighUpWithEmailPassword(
    Map<String, dynamic> body,
  ) async {
    try {
      dynamic fileBytes;
      String fileName = 'profile.jpg';
      if (body.containsKey('userProfileBytes')) {
        fileBytes = body.remove('userProfileBytes');
      }
      if (body.containsKey('userProfileName')) {
        fileName = body.remove('userProfileName');
      }

      final Map<String, String> stringBody = {};
      body.forEach((key, value) {
        if (value != null) {
          stringBody[key] = value.toString();
        }
      });

      final res = await _apiServices.getPostUploadMultiPartApiResponse(
        ApiURL.registerUser,
        stringBody,
        fileBytes,
        fileName,
        'userProfile',
        'POST',
      );

      return res.fold(
        (error) => Left(error),
        (data) => Right(RegisterUserModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<dynamic> sendOtp(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.sendOtp, body);
      return res.fold((error) => Left(error), (data) => Right(data));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<dynamic> verifyOtp(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.verifyOtp, body);
      return res.fold((error) => Left(error), (data) => Right(data));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<dynamic> resetPassword(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.resetPassword, body);
      return res.fold((error) => Left(error), (data) => Right(data));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<LoginResponseModel> socialLogin(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.socialLogin, body);
      return res.fold(
        (error) => Left(error),
        (data) => Right(LoginResponseModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<dynamic> saveFcmToken(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.saveFcmToken, body);
      return res.fold((error) => Left(error), (data) => Right(data));
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
