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
}
