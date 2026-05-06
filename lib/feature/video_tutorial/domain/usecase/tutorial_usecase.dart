import 'package:trackify/feature/video_tutorial/domain/entites/video_tutorial_entity.dart';
import 'package:trackify/feature/video_tutorial/domain/repository/tutorial_repository.dart';

class GetTutorial {

  final TutorialRepository repository;

  GetTutorial(this.repository);

  Future<List<Tutorial>>call(String type)async{
    final all = await repository.getTutorials();
    return all.where((e)=>e.type.toLowerCase()==type.toLowerCase()).toList();
  }
}