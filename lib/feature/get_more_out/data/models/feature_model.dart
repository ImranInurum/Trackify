import 'package:trackify/feature/get_more_out/domain/entities/feature_entity.dart';

class FeatureModel extends FeatureEntity {
  FeatureModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.icon,
  });

  factory FeatureModel.fromMap(Map<String, dynamic> map) {
    return FeatureModel(
      id: map['_id']?.toString() ?? map['id']?.toString() ?? "",
      title: map['title']?.toString() ?? "",
      subtitle: map['shortDescription']?.toString() ?? "",
      icon: map['icon']?.toString() ?? "",
    );
  }

  static List<FeatureModel> fromList(
    List data,
  ) {
    return data
        .map(
          (e) => FeatureModel.fromMap(e),
        )
        .toList();
  }
}