import 'package:trackify/feature/video_tutorial/domain/entites/video_tutorial_entity.dart';

abstract class  TutorialRepository{
  Future<List<Tutorial>>getTutorials();
}