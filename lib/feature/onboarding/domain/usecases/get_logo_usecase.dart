import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/onboarding/domain/entities/logo_entity.dart';
import 'package:trackify/feature/onboarding/domain/repositories/splash_repository.dart';

class GetLogoUseCase {
  final SplashRepository repository;

  GetLogoUseCase(this.repository);

  ResultFuture<LogoEntity> call() async {
    return await repository.getLogo();
  }
}
