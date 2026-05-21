import '../../domain/entities/geo_fence_intro_entity.dart';

class GeoFenceIntroModel
    extends GeoFenceIntroEntity {

  GeoFenceIntroModel({

    required super.image,

    required super.title,

    required super.description,
    required super.buttonText,
  });

  factory GeoFenceIntroModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return GeoFenceIntroModel(
      image: (map['introImages'] != null && map['introImages'].isNotEmpty)
          ? map['introImages'][0].toString()
          : (map['image']?.toString() ?? ""),
      title: map['introTitle']?.toString() ?? map['title']?.toString() ?? "",
      description: map['introDescription']?.toString() ?? map['description']?.toString() ?? "",
      buttonText: map['buttonText']?.toString() ?? "",
    );
  }

  static List<GeoFenceIntroModel> fromApiResponse(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];
    if (data == null) return [];

    if (data is List) {
      return data.map((e) => GeoFenceIntroModel.fromMap(e as Map<String, dynamic>)).toList();
    } else if (data is Map) {
      return [GeoFenceIntroModel.fromMap(data as Map<String, dynamic>)];
    }
    
    return [];
  }
}