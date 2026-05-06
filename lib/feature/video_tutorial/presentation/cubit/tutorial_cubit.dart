import 'package:bloc/bloc.dart';
import 'package:flutter/animation.dart';
import 'package:trackify/feature/video_tutorial/domain/usecase/tutorial_usecase.dart';
import 'package:trackify/feature/video_tutorial/presentation/cubit/tutorial_state.dart';

class TutorialCubit extends Cubit<TutorialState>{
  final GetTutorial tutorial;

  TutorialCubit(this.tutorial) : super(TutorialInitial());

  void load(String type)async{
    emit(TutorialLoading());

    try{
      final data = await tutorial(type);
      emit(TutorialLoaded(data));
    }catch(e){
      emit(TutorialError('Failed'));
    }
  }
}