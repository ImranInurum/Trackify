import 'package:trackify/feature/get_more_out/domain/entities/feature_entity.dart';

abstract class FeatureState{}

class FeatureInitial extends FeatureState{}

class FeatureLoaded extends FeatureState{
  final List<FeatureEntity>items;

  FeatureLoaded(this.items);
 }

