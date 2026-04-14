import 'package:bloc/bloc.dart';
import 'package:trackify/feature/my_profile/domain/use_case/my_profile_use_case.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final MyProfileUseCase _myProfileUseCase;

  MyProfileCubit(this._myProfileUseCase) : super(MyProfileInitial());
}
