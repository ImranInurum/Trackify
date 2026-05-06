import 'package:trackify/feature/video_tutorial/data/datasource/tutorial_remote_data.dart';
import 'package:trackify/feature/video_tutorial/domain/entites/video_tutorial_entity.dart';
import 'package:trackify/feature/video_tutorial/domain/repository/tutorial_repository.dart';

class TutorialRepositoryImplement implements TutorialRepository{
  final TutorialRemoteData remote;

  TutorialRepositoryImplement(this.remote);

  @override
  Future<List<Tutorial>> getTutorials() {
   return remote.fetchTutorial();
  }

}