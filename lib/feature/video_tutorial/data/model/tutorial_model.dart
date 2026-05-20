import '../../../../core/config/network/api_host.dart';
import '../../domain/entites/video_tutorial_entity.dart';

class TutorialModel extends Tutorial {

  TutorialModel({
    required super.id,
    required super.title,
    required super.thumbnail,
    required super.videoUrl,
  });

  factory TutorialModel.fromJson(
      Map<String, dynamic> json) {

    final video = json['video_url'] ?? '';
    final thumbnail = json['video_thumbnail'] ?? '';

    return TutorialModel(
      id: json['id'].toString(),

      title: json['video_title'] ?? '',

      thumbnail:
      thumbnail.startsWith('http')
          ? thumbnail
          : "${ApiURL.baseURL}/$thumbnail",

      videoUrl:
      video.startsWith('http')
          ? video
          : "${ApiURL.baseURL}/$video",
    );
  }
}