import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/feature/help_and_support/domain/repository/help_support_repository.dart';

class HelpSupportRepositoryImpl extends HelpSupportRepository {
  static final BaseApiServices _apiServices = NetworkApiService();
}
