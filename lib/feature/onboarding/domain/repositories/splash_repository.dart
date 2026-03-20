import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/onboarding/domain/entities/logo_entity.dart';

abstract class SplashRepository {
  ResultFuture<LogoEntity> getLogo();
}
