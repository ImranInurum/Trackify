import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/constants/api_constants.dart';
import 'package:trackify/core/errors/exceptions.dart';
import 'package:trackify/core/network/base_api_service.dart';
import 'package:trackify/core/network/network_api_service.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/onboarding/data/models/logo_model.dart';
import 'package:trackify/feature/onboarding/domain/entities/logo_entity.dart';
import 'package:trackify/feature/onboarding/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<LogoEntity> getLogo() async {
    try {
      final res = await _apiServices.getGetApiResponse(ApiConstants.logoUrl, {});
      return res.fold(
        (error) => Left(error),
        (data) {
          if (data is List && data.isNotEmpty) {
            return Right(LogoModel.fromJson(data.first));
          }
          return const Left(FetchDataException("Invalid response format"));
        },
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}
