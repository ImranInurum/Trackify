import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/constants/api_constants.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/auth/domain/repository/auth_repository.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/base_api_service.dart';
import '../../../../core/network/network_api_service.dart';
import '../entity/login_response_model.dart';

class AuthRepositoryImpl implements AuthRepository{
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<LoginResponseModel> loginWithEmailPassword(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiConstants.login, body);
      return res.fold(
            (error) => Left(error),
            (data) => Right(LoginResponseModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<LoginResponseModel> sighUpWithEmailPassword(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiConstants.registerUser, body);
      return res.fold(
            (error) => Left(error),
            (data) => Right(LoginResponseModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

}