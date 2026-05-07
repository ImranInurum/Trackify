import 'package:trackify/feature/get_more_out/data/local%20data/feature_local_data.dart';
import 'package:trackify/feature/get_more_out/data/models/feature_model.dart';
import 'package:trackify/feature/get_more_out/domain/entities/feature_entity.dart';
import 'package:trackify/feature/get_more_out/domain/repository/feature_repository.dart';

class FeatureRepositoryImpl implements FeatureRepository{
  @override
  List<FeatureEntity> deviceItems() {
    return FeatureLocalData.deviceItem.map((e)=>FeatureModel.fromMap(e)).toList();
  }

  @override
  List<FeatureEntity> ridesItems() {
    return FeatureLocalData.rideItems.map((e)=>FeatureModel.fromMap(e)).toList();
  }

  @override
  List<FeatureEntity> safetyItems() {
    return FeatureLocalData.safetyItems.map((e)=>FeatureModel.fromMap(e)).toList();
  }

  @override
  List<FeatureEntity> trackingItems() {
   return FeatureLocalData.trackingItems.map((e)=>FeatureModel.fromMap(e)).toList();
  }


}