import 'package:trackify/feature/get_more_out/domain/entities/discover_entity.dart';

class DiscoverModel extends DiscoverEntity{

  DiscoverModel({
    required super.title,
    required super.subtitle,
    required super.exploredText,
    required super.image
  });

  factory DiscoverModel.fromMap(Map<String,dynamic>map){
    return DiscoverModel(
        title: map['title'] ?? " ",
        subtitle: map['subtitle'] ?? " ",
        exploredText: map['exploredText']?? " ",
        image: map['image']?? " "
    );
  }
}