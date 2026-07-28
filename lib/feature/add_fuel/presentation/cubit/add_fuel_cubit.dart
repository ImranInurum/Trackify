import 'package:bloc/bloc.dart';
import 'package:trackify/feature/add_fuel/domain/entities/add_fuel_entity.dart';
import 'package:trackify/feature/add_fuel/domain/usecase/add_fuel_usecase.dart';
import 'package:trackify/feature/add_fuel/presentation/cubit/add_fuel_state.dart';

class AddFuelCubit extends  Cubit<AddFuelState>{

  final AddFuelUseCase useCase;

  AddFuelCubit(this.useCase) : super(AddFuelInitial());

  Future<void>saveFuel(
      AddFuelEntity entity,
      )async{
    try{
      emit( AddFuelLoading());
      await useCase.call(entity);
      
      emit(AddFuelSuccess());

    }catch(e){
      emit(AddFuelError(e.toString()));
    }
  }

  Future<void> updateFuel(
      String refuelId,
      AddFuelEntity entity,
      )async{
    try{
      emit(AddFuelLoading());
      await useCase.updateFuel(refuelId, entity);
      
      emit(AddFuelSuccess());
    }catch(e){
      emit(AddFuelError(e.toString()));
    }
  }

}