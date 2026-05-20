import 'package:trackify/feature/video_tutorial/domain/entites/video_tutorial_entity.dart';
import 'package:trackify/feature/video_tutorial/domain/repository/tutorial_repository.dart';

class GetTutorial {

  final TutorialRepository repository;

  GetTutorial(this.repository);

  Future<List<Tutorial>> call(
      String categoryId) async {

    return await repository
        .getTutorials(categoryId);
  }
}