import 'package:trackify/feature/video_tutorial/data/model/tutorial_model.dart';
import 'package:trackify/feature/video_tutorial/domain/entites/video_tutorial_entity.dart';

class TutorialRemoteData{
  Future<List<Tutorial>> fetchTutorial()async{
    await Future.delayed(Duration(seconds: 1));

    return[
      TutorialModel(
          title: "Live Tracking",
          thumbnail: "https://img.youtube.com/vi/ysz5S6PUM-U/0.jpg",
          videoUrl:  "https://v.ftcdn.net/17/21/31/95/700_F_1721319590_OIqc7oH4tEGtyZ9xnMtrkq6sKswlgF3b_ST.mp4",
          type: "location",
      ),
      TutorialModel(
          title: "installation",
          thumbnail:  "https://img.youtube.com/vi/aqz-KE-bpKQ/0.jpg",
          videoUrl:   "https://v.ftcdn.net/05/77/35/85/700_F_577358584_p5u34UeIWmNxIdQjoQvJHcYYoVxbE0tG_ST.mp4",
          type: "installation"
      ),
      TutorialModel(
          title: "Feature",
          thumbnail: "https://img.youtube.com/vi/ScMzIvxBSi4/0.jpg",
          videoUrl:  "https://v.ftcdn.net/01/07/75/23/240_F_107752309_njfbUAZPnzA6Zxc840QOpG7uSjbKj9RM_ST.mp4",
          type: "features",
      ),
      TutorialModel(
        title: "Live voice",
        thumbnail: "https://img.youtube.com/vi/ysz5S6PUM-U/0.jpg",
        videoUrl:  "https://assets.mixkit.co/videos/51585/51585-720.mp4",
        type: "voice",
      ),

    ];
  }
}