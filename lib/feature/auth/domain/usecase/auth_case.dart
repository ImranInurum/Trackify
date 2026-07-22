import 'package:trackify/feature/auth/domain/repository/auth_repository.dart';

import '../../../../core/utils/typedefs.dart';
import '../../data/entity/login_response_model.dart';
import '../../data/entity/register_user_model.dart';

class AuthCase {
  final AuthRepository authRepository;
  AuthCase(this.authRepository);

  ResultFuture<LoginResponseModel> loginCall(Map<String, dynamic> body) {
    return authRepository.loginWithEmailPassword(body);
  }

  ResultFuture<RegisterUserModel> registerCall(Map<String, dynamic> body) {
    return authRepository.sighUpWithEmailPassword(body);
  }

  ResultFuture<dynamic> sendOtpCall(Map<String, dynamic> body) {
    return authRepository.sendOtp(body);
  }

  ResultFuture<dynamic> verifyOtpCall(Map<String, dynamic> body) {
    return authRepository.verifyOtp(body);
  }

  ResultFuture<dynamic> resetPasswordCall(Map<String, dynamic> body) {
    return authRepository.resetPassword(body);
  }

  ResultFuture<LoginResponseModel> socialLoginCall(Map<String, dynamic> body) {
    return authRepository.socialLogin(body);
  }

  ResultFuture<dynamic> saveFcmTokenCall(Map<String, dynamic> body) {
    return authRepository.saveFcmToken(body);
  }

  ResultFuture<dynamic> changePasswordCall(Map<String, dynamic> body) {
    return authRepository.changePassword(body);
  }
}
