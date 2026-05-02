import 'package:bloc/bloc.dart';
import 'package:trackify/feature/app_updates/domain/use_case/get_update_use_case.dart';
import 'package:trackify/feature/app_updates/presentiation/cubit/update_cubit_state.dart';

class UpdateCubit extends Cubit<UpdateState>{
  final GetUpdateUseCase getUpdateUseCase;

  UpdateCubit(this.getUpdateUseCase):super(UpdateInitial());

  void fetchUpdates()async{
    emit(UpdateLoading());

    try{
      final data = await getUpdateUseCase();
      emit(UpdateLoaded(data));
    }catch(e){
      emit(UpdateError(e.toString()));
    }
  }
}
