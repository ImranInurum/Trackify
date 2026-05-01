import 'package:trackify/feature/app_updates/domain/entity/update_entity.dart';

abstract class UpdateRepository{
  Future<List<UpdateEntity>>getUpdates();
}