import '../../domain/entities/discover_entity.dart';

class DiscoverModel extends DiscoverEntity {

  DiscoverModel({
    required super.title,
    required super.subtitle,
    required super.exploredText,
    required super.image,
    required super.id
  });

  factory DiscoverModel.fromMap(Map<String, dynamic> map,) {
    return DiscoverModel(

      title: map['title'] ?? "",

      subtitle: map['description'] ?? "",

      exploredText:
      map['exploredText'] ?? "",

      image:
      map['bannerImage'] ?? "",

      id: map['_id']?? "",
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': subtitle,
      'exploredText': exploredText,
      'bannerImage': image,
      '_id': id,
    };
  }

  static List<DiscoverModel> fromList(List data,) {
    return data
        .map(
          (e) => DiscoverModel.fromMap(e),
    )
        .toList();
  }
}