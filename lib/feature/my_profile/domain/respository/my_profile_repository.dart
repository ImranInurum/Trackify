import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_request.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_response.dart';

abstract class MyProfileRepository {
  ResultFuture<UpdateProfileResponse> updateProfile({
    required String userId,
    required UpdateProfileRequest request,
    List<int>? profileImageBytes,
    String? profileImageName,
  });
}
