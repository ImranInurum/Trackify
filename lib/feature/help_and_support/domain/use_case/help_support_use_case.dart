import 'package:trackify/feature/help_and_support/data/repository_impl/help_support_repository_impl.dart';
import 'package:trackify/feature/help_and_support/domain/repository/help_support_repository.dart';

class HelpSupportUseCase {
  final HelpSupportRepository repository = HelpSupportRepositoryImpl();
}
