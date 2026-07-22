import '../../../../core/utils/typedefs.dart';
import '../../data/entity/login_response_model.dart';
import '../../data/entity/register_user_model.dart';

abstract interface class AuthRepository {
  ResultFuture<LoginResponseModel> loginWithEmailPassword(Map<String, dynamic> body);
  ResultFuture<RegisterUserModel> sighUpWithEmailPassword(Map<String, dynamic> body);
  ResultFuture<dynamic> sendOtp(Map<String, dynamic> body);
  ResultFuture<dynamic> verifyOtp(Map<String, dynamic> body);
  ResultFuture<dynamic> resetPassword(Map<String, dynamic> body);
  ResultFuture<LoginResponseModel> socialLogin(Map<String, dynamic> body);
  ResultFuture<dynamic> saveFcmToken(Map<String, dynamic> body);
  ResultFuture<dynamic> changePassword(Map<String, dynamic> body);
}
