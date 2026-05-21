import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_request.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_response.dart';
import 'package:trackify/feature/my_profile/domain/respository/my_profile_repository.dart';

class MyProfileRepositoryImpl extends MyProfileRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<UpdateProfileResponse> updateProfile({
    required String userId,
    required UpdateProfileRequest request,
    List<int>? profileImageBytes,
    String? profileImageName,
  }) async {
    try {
      final url = ApiURL.updateProfile(userId);
      final body = request.toJson();

      final Either<AppException, dynamic> result;
      if (profileImageBytes != null) {
        final Map<String, String> stringBody = {};
        body.forEach((key, value) {
          if (value != null) {
            stringBody[key] = value.toString();
          }
        });
        result = await _apiServices.getPostUploadMultiPartApiResponse(
          url,
          stringBody,
          profileImageBytes,
          profileImageName ?? 'profile.jpg',
          'userProfile',
          'PUT',
        );
      } else {
        result = await _apiServices.getPutApiResponse(url, body);
      }

      return result.fold(
        (failure) => Left(failure),
        (data) => Right(UpdateProfileResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
