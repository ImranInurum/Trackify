import 'package:trackify/feature/get_more_out/domain/entities/feature_entity.dart';

abstract class FeatureRepository{

  List<FeatureEntity> safetyItems();

  List<FeatureEntity> trackingItems();

  List<FeatureEntity> ridesItems();

  List<FeatureEntity> deviceItems();
}