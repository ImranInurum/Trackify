import '../../../../core/utils/typedefs.dart';
import '../../data/entity/login_response_model.dart';

abstract interface class AuthRepository {
  ResultFuture<LoginResponseModel> loginWithEmailPassword(Map<String, dynamic> body);
  ResultFuture<LoginResponseModel> sighUpWithEmailPassword(Map<String, dynamic> body);
}
