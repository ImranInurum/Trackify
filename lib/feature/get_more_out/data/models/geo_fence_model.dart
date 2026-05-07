import '../../domain/entities/geo_fence_intro_entity.dart';

class GeoFenceIntroModel
    extends GeoFenceIntroEntity {

  GeoFenceIntroModel({

    required super.image,

    required super.title,

    required super.description,
  });

  factory GeoFenceIntroModel.fromMap(
      Map<String, dynamic> map) {

    return GeoFenceIntroModel(

      image: map['image'],

      title: map['title'],

      description: map['description'],
    );
  }
}