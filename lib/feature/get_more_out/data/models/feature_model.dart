import 'package:trackify/feature/get_more_out/domain/entities/feature_entity.dart';

class  FeatureModel extends FeatureEntity{
  FeatureModel({
     required super.title,
    required super.subtitle,
    required super.icon
  });

  factory FeatureModel.fromMap(Map<String,dynamic>map){
    return FeatureModel(
        title: map['title'],
        subtitle: map['subtitle'],
        icon: map['icon']
    );
  }
}