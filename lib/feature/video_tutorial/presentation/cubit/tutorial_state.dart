import 'package:trackify/feature/video_tutorial/domain/entites/video_tutorial_entity.dart';

abstract class TutorialState{}

class TutorialInitial extends TutorialState{}

class TutorialLoading extends TutorialState{}

class TutorialLoaded extends TutorialState{
  final List<Tutorial>list;

  TutorialLoaded(this.list);
}

class TutorialError extends TutorialState{
  final String message;

  TutorialError(this.message);
}