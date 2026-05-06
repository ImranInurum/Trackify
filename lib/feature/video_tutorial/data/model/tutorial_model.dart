import '../../domain/entites/video_tutorial_entity.dart';

class TutorialModel extends Tutorial {
  TutorialModel({
    required super.title,
    required super.thumbnail,
    required super.videoUrl,
    required super.type});

  factory TutorialModel.fromJson(Map<String,dynamic>json){
    return TutorialModel(
        title: json['title'],
        thumbnail: json['thumbnail'],
        videoUrl: json['videoUrl'],
        type: json['type']
    );
  }
  
}