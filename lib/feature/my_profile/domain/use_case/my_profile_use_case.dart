import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_request.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_response.dart';
import 'package:trackify/feature/my_profile/domain/respository/my_profile_repository.dart';

class MyProfileUseCase {
  final MyProfileRepository repository;
  MyProfileUseCase(this.repository);

  ResultFuture<UpdateProfileResponse> updateProfile({
    required String userId,
    required UpdateProfileRequest request,
    List<int>? profileImageBytes,
    String? profileImageName,
  }) async {
    return await repository.updateProfile(
      userId: userId,
      request: request,
      profileImageBytes: profileImageBytes,
      profileImageName: profileImageName,
    );
  }
}
